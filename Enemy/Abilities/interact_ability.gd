extends EnemyAbility
class_name InteractAbility

@export var interactRadius: float = 100
var interactArea: Area2D = null
var interactCollision: CollisionShape2D = null
var interactShape: CircleShape2D = null

func initialize_ability():
	print("INTERACT INIT")
	#interactArea = Area2D.new()
	#interactCollision = CollisionShape2D.new()
	#interactShape = CircleShape2D.new()
	#interactShape.radius = interactRadius
	#interactCollision.shape = interactShape
	#interactArea.collision_layer = 0
	#interactArea.collision_mask = 3
	#interactArea.add_child(interactCollision)
	
	print("INTERACT INIT END")

func interact(otherObj: Node2D):
	if otherObj.has_method("interact"):
		otherObj.interact()
