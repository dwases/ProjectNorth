extends Resource
class_name EnemyStats

@export_group("Visuals")
@export var enemyTexture: Texture2D
@export var footstepID: int = 0

@export_group("Stats")
@export var HP: float = 100
@export var loudness: int = 10
@export var speed: float = 500
@export var stepDistance: float = 250

@export_group("Special abilities")
@export var ability: EnemyAbility = null

@export_group("Description")
@export var description: String = "DOOM IS UPON US"
