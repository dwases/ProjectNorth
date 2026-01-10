extends Node2D

var radius: float = 0.0
var circle_color: Color = Color(0.2, 0.6, 1.0, 0.3)
var level: int = 0
var upgrade_cost: int = 0
var refund: int = 0
func update_circle(new_radius: float):
	radius = new_radius
	queue_redraw()

func _draw():
	if radius > 0:
		draw_circle(Vector2.ZERO, radius, circle_color)
		draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color.WHITE, 2.0)
	level = $"../..".stats.level
	upgrade_cost = $"../..".stats.BaseCost
	refund = $"../..".stats.sell_cost
	$VBoxContainer/LevelLabel.text = str(level)
	if upgrade_cost==0:
		$VBoxContainer/CostLabel.text = "MAX"
	else:
		$VBoxContainer/CostLabel.text = str(upgrade_cost)
	$VBoxContainer2/Label2.text = str(refund)
