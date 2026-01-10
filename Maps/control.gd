extends Control

@export var resources_path: String = "res://Tower/Resources/"
signal start_wave_requested
@onready var button_container: Container = $ShopWrapper/VBoxContainer
@onready var shop_wrapper: Control = $ShopWrapper
@onready var toggle_btn: Button = $ShopWrapper/ToggleButton
@onready var StartWave_btn: Button = $StartWaveButton

@onready var towerClass = preload("res://Tower/tower_base.tscn")

func _ready():
	generate_shop_buttons()
	StartWave_btn.pressed.connect(_on_start_wave_pressed)

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
	btn.tooltip_text = "Damage: %s\nRange: %s" % [stats.Damage, stats.Zasieg]
	
	if stats.tower_texture:
		btn.icon = stats.tower_texture
		btn.expand_icon = true
	btn.custom_minimum_size = Vector2(64, 64)
	btn.pressed.connect(func(): _on_shop_button_pressed(stats))
	button_container.add_child(btn)

func _on_shop_button_pressed(stats: TowerStats):
	print("Wybrano wieżę z kosztem: ", stats.BaseCost)
	#warunek if, wykonac tylko wtedy, kiedy ma sie hajs
	var tower_spawn = towerClass.instantiate()
	tower_spawn.stats = stats.duplicate()
	get_tree().current_scene.add_child(tower_spawn)
	
func wave_end():
	ShowUI()


func ShowUI():
	StartWave_btn.disabled = false
	

func HideUI():
	StartWave_btn.disabled = true
	

func _on_start_wave_pressed() -> void:
	start_wave_requested.emit()
	HideUI()
	
