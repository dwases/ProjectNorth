extends Resource
class_name TowerStats

@export_group("Info")
@export var name: String
@export var description: String
@export var advanced_description: String

@export_group("Visuals")
@export var tower_texture: Texture2D
@export var projectile_visual: Texture2D

@export_group("Combat Stats")
@export var Zasieg: int = 300
@export var Attack_speed: float = 1.0
@export var Damage: float = 10.0

@export_group("Economy")
@export var BaseCost: int = 100
@export var upgrades: TowerUpgrade
var level = 1
var sell_cost = floor(BaseCost/2)

@export_group("Special Logic")
@export var tower_effect: TowerEffect = null
