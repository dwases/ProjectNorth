extends Resource
class_name TowerStats

@export_group("Visuals")
@export var tower_texture: Texture2D
@export var projectile_visual: PackedScene

@export_group("Combat Stats")
@export var Zasieg: int = 300
@export var Attack_speed: float = 1.0
@export var Damage: float = 10.0

@export_group("Economy")
@export var BaseCost: int = 100
@export var upgrades: Array[TowerUpgrade]

@export_group("Special Logic")
@export var tower_effect: TowerEffect = null
