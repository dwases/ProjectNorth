extends StaticBody2D
class_name Tower

@export var stats: TowerStats
@onready var menu = $TowerMenu
@onready var range_circle = $TowerMenu/RangeCircle
@onready var btn_upgrade = $TowerMenu/RangeCircle/VBoxContainer/UpgradeButton
@onready var btn_sell = $TowerMenu/RangeCircle/VBoxContainer2/DestroyButton
@onready var barrel: Sprite2D = $Barrel

var targets_in_range: Array[Node2D] = []
@onready var is_snapping: bool = true
@onready var slot_detector: Area2D = $SlotDetector


func _ready():
	# Ukrywamy menu na start
	menu.visible = false
	barrel.texture = stats.tower_texture
	
	# Inicjalizujemy kółko zasięgu (jeśli statystyki są załadowane)
	if stats:
		range_circle.update_circle(stats.Zasieg)

func _input_event(viewport, event, shape_idx):
	if not is_snapping:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and GameInstance.is_placing_mode == false:
			toggle_menu()
			range_circle.update_circle(stats.Zasieg)
	else:
		if can_be_placed and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_snapping = false
			GameInstance.is_placing_mode = false
		pass
	
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
	
	# --- KROK 1: CZYSZCZENIE (Sanity Check) ---
	# Musimy to zrobić PRZED sortowaniem, żeby nie wywalić gry na dostępie do .stats
	# Iterujemy od tyłu, żeby bezpiecznie usuwać elementy z tablicy
	for i in range(all_targets.size() - 1, -1, -1):
		var target = all_targets[i]
		
		# Sprawdzamy czy obiekt jest "Freed" (usunięty)
		if not is_instance_valid(target):
			# Usuwamy z tablicy lokalnej
			all_targets.remove_at(i)
			
			# Zgodnie z prośbą: Czyścimy też słownik pamięci słuchowej
			# (Nawet jeśli klucza nie ma, erase jest bezpieczne)
			heard_enemies_timers.erase(target) 
			continue

	# Jeśli po czyszczeniu nikogo nie ma, kończymy
	if all_targets.is_empty():
		return null

	# --- KROK 2: SORTOWANIE ---
	# Teraz jest bezpieczne, bo mamy tylko żywych wrogów
	all_targets.sort_custom(func(a, b):
		# Safety check: upewnij się, że obiekt ma zmienne
		var a_loud = a.stats.loudness if "stats" in a and a.stats else 0
		var b_loud = b.stats.loudness if "stats" in b and b.stats else 0
		
		var a_prog = a.get_parent().progress if a.get_parent() is PathFollow2D else 0
		var b_prog = b.get_parent().progress if b.get_parent() is PathFollow2D else 0
		
		if a_loud != b_loud:
			return a_loud > b_loud
		return a_prog > b_prog
	)
	
	# --- KROK 3: LOGIKA ZAGŁUSZANIA ---
	var max_loudness = all_targets[0].stats.loudness
	
	for target in all_targets:
		var current_loudness = target.stats.loudness
		
		# Jeśli trafiliśmy na kogoś cichszego niż lider, a lider nie był w zasięgu -> przerywamy
		if current_loudness < max_loudness:
			return null
			
		var dist = global_position.distance_to(target.global_position)
		
		if dist <= stats.Zasieg:
			return target
			
	return null
var can_shoot = true

func shoot(target: Node2D):
	var turret_shot_audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	turret_shot_audio.stream = preload("res://Sounds/turret shot sound.wav")
	#money_gain_audio.volume_db = -10
	turret_shot_audio.autoplay = true
	get_tree().current_scene.add_child(turret_shot_audio)
	
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

var can_be_placed: bool = true

func _process(delta: float) -> void:
	if is_snapping:
		can_be_placed = true;
		global_position = get_global_mouse_position()
		if slot_detector.has_overlapping_bodies():
			for area in slot_detector.get_overlapping_bodies():
				if area == self:
					continue
				can_be_placed = false;
		else:
			can_be_placed = true
			pass
	else: 
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
		if target and is_instance_valid(target):
			barrel.look_at(target.global_position)
			barrel.global_rotation_degrees += 45

func get_all_targets() -> Array:
	var combined_targets = []
	combined_targets.append_array(targets_in_range) 
	for enemy in heard_enemies_timers.keys():
		if is_instance_valid(enemy) and not combined_targets.has(enemy):
			combined_targets.append(enemy)
			
	return combined_targets


func _on_upgrade_button_pressed() -> void:
	if get_tree().current_scene.playerMoney >= stats.BaseCost:
		get_tree().current_scene.playerMoney -= stats.sell_cost
		upgrade()
		range_circle.update_circle(stats.Zasieg)


func _on_destroy_button_pressed() -> void:
	print("Sprzedano wieżę")
	get_tree().current_scene.playerMoney += stats.sell_cost
	queue_free()

func upgrade():
	if stats.level <= stats.upgrades.add_cost.size():
		var upgrade_data = stats.upgrades
		stats.BaseCost += upgrade_data.add_cost[stats.level-1]
		stats.Attack_speed += upgrade_data.add_attack_speed[stats.level-1]
		stats.Damage += upgrade_data.add_damage[stats.level-1]
		stats.Zasieg += upgrade_data.add_range[stats.level-1]
		stats.sell_cost += floor(upgrade_data.add_cost[stats.level-1]/2)
		stats.level += 1
		print("Ulepszono na poziom: ", stats.level)
		if stats.level > stats.upgrades.add_cost.size():
			stats.BaseCost = 0
	else:
		print("Maksymalny poziom osiągnięty!")
