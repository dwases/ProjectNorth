extends StaticBody2D
class_name Tower

@export var stats: TowerStats

@onready var menu = $TowerMenu
@onready var range_circle = $TowerMenu/RangeCircle
@onready var btn_upgrade = $TowerMenu/UpgradeButton
@onready var btn_sell = $TowerMenu/DestroyButton
@onready var barrel: Sprite2D = $Barrel

var targets_in_range: Array[Node2D] = []

func _ready():
	# Ukrywamy menu na start
	menu.visible = false
	
	# Podłączamy sygnały przycisków
	btn_upgrade.pressed.connect(_on_upgrade_button_pressed)
	btn_sell.pressed.connect(_on_destroy_button_pressed)
	
	# Inicjalizujemy kółko zasięgu (jeśli statystyki są załadowane)
	if stats:
		range_circle.update_circle(stats.Zasieg)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle_menu()
func toggle_menu():
	menu.visible = not menu.visible
	
	if menu.visible:
		# Jeśli otwieramy menu, warto odświeżyć promień (np. po upgrade)
		range_circle.update_circle(stats.Zasieg)
		
		# Pro Tip: Tu możesz wysłać sygnał do "GameManagera", 
		# żeby zamknął menu innych wież (żeby nie mieć otwartych 10 na raz).
		add_to_group("selected_towers")
	else:
		remove_from_group("selected_towers")

func get_best_target() -> Node2D:
	var all_targets = get_all_targets()
	if all_targets.is_empty():
		return null
	all_targets.sort_custom(func(a, b):
		if a.loudness != b.loudness:
			return a.loudness > b.loudness
		return a.get_parent().progress > b.get_parent().progress
	)
	
	return all_targets[0]
var can_shoot = true

func shoot(target: Node2D):
	can_shoot = false
	
	if stats.projectile_visual:
		spawn_visual_projectile(target)
	else:
		apply_hit_logic(target)
		
	$ReloadTimer.wait_time = 1.0 / stats.Attack_speed
	$ReloadTimer.start()

func spawn_visual_projectile(target: Node2D):
	var visuals = Sprite2D.new()
	visuals.texture = stats.projectile_visual
	get_tree().current_scene.add_child(visuals)
	
	visuals.global_position = global_position
	visuals.look_at(target.global_position)
	
	var tween = create_tween()
	var flight_time = 0.2 #do przemyślenia czy nie zmienić na zmienną
	tween.tween_property(visuals, "global_position", target.global_position, flight_time)
	tween.tween_callback(func():
		apply_hit_logic(target) 
		visuals.queue_free()
	)

func apply_hit_logic(target: Node2D):
	#sprawdź czy typ jeszcze nie zdechł
	if not is_instance_valid(target):
		return
	if target.has_method("take_damage"):
		target.take_damage(stats.Damage)
		
	if stats.tower_effect:
		stats.tower_effect.apply_effect(target)

func _on_reload_timer_timeout():
	can_shoot = true
var heard_enemies_timers: Dictionary = {} 

func hear_enemy(enemy: Node2D):
	var expire_time = Time.get_ticks_msec() + 1000
	heard_enemies_timers[enemy] = expire_time

func _process(delta):
	var current_time = Time.get_ticks_msec()
	var target = get_best_target()
	if target and can_shoot:
		shoot(target)
	for enemy in heard_enemies_timers.keys():
		if not is_instance_valid(enemy):
			heard_enemies_timers.erase(enemy)
			continue
			
		if current_time >= heard_enemies_timers[enemy]:
			heard_enemies_timers.erase(enemy)
		
	if get_all_targets().size() > 0:
		barrel.look_at(get_best_target().global_position)
		barrel.global_rotation_degrees += 45

func get_all_targets() -> Array:
	var combined_targets = []
	combined_targets.append_array(targets_in_range) 
	for enemy in heard_enemies_timers.keys():
		if is_instance_valid(enemy) and not combined_targets.has(enemy):
			combined_targets.append(enemy)
			
	return combined_targets


func _on_upgrade_button_pressed() -> void:
	print("Kliknięto Upgrade!")
	range_circle.update_circle(stats.Zasieg)


func _on_destroy_button_pressed() -> void:
	print("Sprzedano wieżę")
	queue_free()
