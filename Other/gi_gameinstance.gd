extends Node
class_name GI_GameInstace

var playerHP: int = 10

func damage_player(value: int) -> void:
	playerHP -= value
	if playerHP <= 0:
		print("Gracz nie zyje")
