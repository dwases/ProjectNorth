# tower_upgrade.gd
extends Resource
class_name TowerUpgrade

@export_group("Koszt i Info")
@export var add_cost: int = 0

@export_group("Zmiany statystyk")
@export var add_damage: float = 0.0
@export var add_range: int = 0
@export var add_attack_speed: float = 0.0

# Opcjonalnie: zmiana tekstury na juicing
# @export var new_texture: Texture2D
