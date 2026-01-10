# tower_upgrade.gd
extends Resource
class_name TowerUpgrade

@export_group("Koszt i Info")
@export var add_cost: Array[int] = []

@export_group("Zmiany statystyk")
@export var add_damage: Array[float] = []
@export var add_range: Array[int] = []
@export var add_attack_speed: Array[float] = []

# Opcjonalnie: zmiana tekstury na juicing
# @export var new_texture: Texture2D
