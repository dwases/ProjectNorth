extends Node2D

#wyłącza UI włączonych menu towerów jeżeli nie klikniesz w nic użytecznego
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().call_group("selected_towers", "toggle_menu")
