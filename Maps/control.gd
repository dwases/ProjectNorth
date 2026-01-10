extends Control

# Ścieżka do folderu z zasobami wież
@export var resources_path: String = "res://Tower/Resources/"
# Kontener w UI, gdzie mają pojawić się przyciski
@onready var button_container: Container = $ShopWrapper/VBoxContainer
@onready var shop_wrapper: Control = $ShopWrapper
@onready var toggle_btn: Button = $ShopWrapper/ToggleButton
@onready var StartWave_btn: Button = $StartWaveButton

func _ready():
	generate_shop_buttons()

func generate_shop_buttons():
	# 1. Otwieramy katalog
	var dir = DirAccess.open(resources_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# 2. Iterujemy tylko po plikach .tres (ignorujemy .import i foldery)
			# Ważne: W wyeksportowanej grze pliki mogą mieć końcówkę .remap, trzeba to obsłużyć
			if (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				
				# Ładujemy zasób z dysku
				var full_path = resources_path + file_name
				var tower_stats = load(full_path) as TowerStats
				
				# Safety Check: Czy to faktycznie TowerStats?
				if tower_stats:
					create_button(tower_stats)
			
			file_name = dir.get_next()
	else:
		print("Błąd: Nie znaleziono ścieżki: " + resources_path)

func create_button(stats: TowerStats):
	var btn = Button.new()
	
	# 3. Konfigurujemy wygląd przycisku na podstawie danych z zasobu
	btn.text = str(stats.BaseCost) + "$"
	btn.tooltip_text = "Damage: %s\nRange: %s" % [stats.Damage, stats.Zasieg]
	
	if stats.tower_texture: # Zakładając, że dodałeś pole icon do TowerStats
		btn.icon = stats.tower_texture
		btn.expand_icon = true
		
	# Ustawiamy minimalny rozmiar, żeby w Gridzie wyglądało dobrze
	btn.custom_minimum_size = Vector2(64, 64)
	
	# 4. Kluczowy moment: Podpinamy sygnał z parametrem (Lambda)
	# Dzięki temu przycisk "wie", jaki Resource przekazać dalej
	btn.pressed.connect(func(): _on_shop_button_pressed(stats))
	
	# Dodajemy przycisk do drzewa sceny
	button_container.add_child(btn)

# Ta funkcja wywoła się po kliknięciu
func _on_shop_button_pressed(stats: TowerStats):
	print("Wybrano wieżę z kosztem: ", stats.BaseCost)
	
	# Tutaj wywołujesz logikę z poprzednich rozmów:
	# GameManager.start_placing_tower(stats)
	# lub
	# create_ghost_tower(stats)
