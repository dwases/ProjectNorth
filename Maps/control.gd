extends Control
class_name Main_UI

@export var resources_path: String = "res://Tower/Resources/"
signal start_wave_requested
@onready var button_container: Container = $ShopWrapper/TextureRect/ScrollContainer/VBoxContainer
@onready var shop_wrapper: Control = $ShopWrapper
@onready var toggle_btn: Button = $ShopWrapper/ToggleButton
@onready var StartWave_btn: Button = $StartWaveButton
@onready var MoneyLabel: Label = $StatsWrapper/HBoxContainer/MoneyBox/MoneyAmount
@onready var HPLabel: Label = $StatsWrapper/HBoxContainer/HPBox/HPHBox/HPAmount
@onready var WaveLabel: Label = $StatsWrapper/HBoxContainer/WaveBox/WaveHBox/WaveCount

var is_shop_open: bool = true
var open_pos_x: float   # Pozycja X, gdy sklep jest widoczny
var closed_pos_x: float # Pozycja X, gdy sklep jest schowany
@onready var towerClass = preload("res://Tower/tower_base.tscn")

func _ready():
	GameInstance.full_screen = self
	generate_shop_buttons()
	StartWave_btn.pressed.connect(_on_start_wave_pressed)
	toggle_btn.pressed.connect(toggle_shop)
	call_deferred("setup_animation_positions")
	HPLabel.text = str(GameInstance.playerHP)
	GameInstance.player_hp_changed.connect(_on_hp_changed)

func setup_animation_positions():
	open_pos_x = shop_wrapper.position.x
	closed_pos_x = open_pos_x + shop_wrapper.size.x #- toggle_btn.size.x
	toggle_btn.text = ">"
func toggle_shop():
	if is_shop_open:
		# Jeśli otwarty -> zamykamy (jedziemy na closed_pos_x)
		animate_shop(closed_pos_x)
		toggle_btn.text = "<" # Strzałka w lewo (żeby otworzyć)
		is_shop_open = false
	else:
		# Jeśli zamknięty -> otwieramy (wracamy na open_pos_x)
		animate_shop(open_pos_x)
		toggle_btn.text = ">" # Strzałka w prawo (żeby zamknąć)
		is_shop_open = true
func animate_shop(target_x: float):
	# Tworzymy Tweena (animator)
	var tween = create_tween()
	
	# Ustawiamy styl animacji (Cubic + EaseOut daje efekt "hamowania")
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Animujemy właściwość position:x w czasie 0.4 sekundy
	tween.tween_property(shop_wrapper, "position:x", target_x, 0.4)
func generate_shop_buttons():
	var dir = DirAccess.open(resources_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var full_path = resources_path + file_name
				var tower_stats = load(full_path) as TowerStats
				if tower_stats:
					create_button(tower_stats)
			file_name = dir.get_next()
	else:
		print("Błąd: Nie znaleziono ścieżki: " + resources_path)

func create_button(stats: TowerStats):
	var btn = Button.new()
	btn.text = str(stats.BaseCost) + "$"
	btn.tooltip_text = "Name: %s\nDescription: %s\nDamage: %s\nAttack Speed: %s\nRange: %s" % [stats.name,stats.description,stats.Damage,stats.Attack_speed, stats.Zasieg]
	
	if stats.tower_texture:
		btn.icon = stats.tower_texture
		btn.expand_icon = true
	btn.custom_minimum_size = Vector2(128, 128)
	btn.pressed.connect(func(): _on_shop_button_pressed(stats))
	button_container.add_child(btn)

func _on_shop_button_pressed(stats: TowerStats):
	print("Wybrano wieżę z kosztem: ", stats.BaseCost)
	if get_tree().current_scene.playerMoney >= stats.BaseCost:
		get_tree().current_scene.playerMoney -= stats.BaseCost 
		var tower_spawn = towerClass.instantiate()
		tower_spawn.stats = stats.duplicate()
		GameInstance.is_placing_mode = true
		GameInstance.temp_cost = stats.BaseCost
		get_tree().current_scene.add_child(tower_spawn)
		tower_spawn.toggle_menu()
	
func wave_end(wave_count):
	ShowUI()
	WaveLabel.text = str(wave_count)

func ShowUI():
	StartWave_btn.disabled = false
	var _buttons = button_container.get_children() as Array[Button]
	for btn in _buttons:
		btn.disabled = false
	

func HideUI():
	StartWave_btn.disabled = true
	var _buttons = button_container.get_children() as Array[Button]
	for btn in _buttons:
		btn.disabled = true

func _on_start_wave_pressed() -> void:
	HideUI()
	start_wave_requested.emit()
	get_tree().current_scene.building_audio_player.stop()
	get_tree().current_scene.combat_audio_stream_player.stop()
	get_tree().current_scene.combat_audio_stream_player.play()
	
func _on_hp_changed(new_value: int):
	HPLabel.text = str(new_value)
