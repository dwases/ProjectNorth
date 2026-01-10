extends Control

@export var resources_path: String = "res://Tower/Resources/"
signal start_wave_requested
@onready var button_container: Container = $ShopWrapper/VBoxContainer
@onready var shop_wrapper: Control = $ShopWrapper
@onready var toggle_btn: Button = $ShopWrapper/ToggleButton
@onready var StartWave_btn: Button = $StartWaveButton

var is_shop_open: bool = true
var open_pos_x: float   # Pozycja X, gdy sklep jest widoczny
var closed_pos_x: float # Pozycja X, gdy sklep jest schowany

func _ready():
	generate_shop_buttons()
	StartWave_btn.pressed.connect(_on_start_wave_pressed)
	toggle_btn.pressed.connect(toggle_shop)
	call_deferred("setup_animation_positions")

func setup_animation_positions():
	open_pos_x = shop_wrapper.position.x
	closed_pos_x = open_pos_x + shop_wrapper.size.x - toggle_btn.size.x
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
	btn.tooltip_text = "Damage: %s\nRange: %s" % [stats.Damage, stats.Zasieg]
	
	if stats.tower_texture:
		btn.icon = stats.tower_texture
		btn.expand_icon = true
	btn.custom_minimum_size = Vector2(64, 64)
	btn.pressed.connect(func(): _on_shop_button_pressed(stats))
	button_container.add_child(btn)

func _on_shop_button_pressed(stats: TowerStats):
	print("Wybrano wieżę z kosztem: ", stats.BaseCost)
	
func wave_end():
	ShowUI()


func ShowUI():
	StartWave_btn.disabled = false
	

func HideUI():
	StartWave_btn.disabled = true
	

func _on_start_wave_pressed() -> void:
	HideUI()
	start_wave_requested.emit()
	
	
