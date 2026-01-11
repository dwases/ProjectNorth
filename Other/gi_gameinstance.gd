extends Node
class_name GI_GameInstace
signal player_hp_changed(new_value: int)
var playerHP: int = 10:
	set(value):
		playerHP = value
		player_hp_changed.emit(playerHP)
var is_placing_mode: bool = false

var full_screen: Main_UI

var is_placing_mode: bool:
	set(value):
		if value:
			full_screen.HideUI()
		else:
			full_screen.ShowUI()

var main_camera: Camera2D
var cameraShakeNoise: FastNoiseLite

func _ready() -> void:
	cameraShakeNoise = FastNoiseLite.new()
	main_camera = get_node("/root/MainMap1/Camera2D")
	playerHP=10

func damage_player(value: int) -> void:
	playerHP -= value

	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(StartShakingCamera, 5.0, 1.0, 1.0)
	if playerHP <= 0:
		print("Gracz nie zyje")
		var losing_audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		losing_audio.stream = preload("res://Sounds/losing sound.wav")
		#wave_win_audio.volume_db = -10
		losing_audio.autoplay = true
		get_tree().current_scene.add_child(losing_audio)

func StartShakingCamera(intensity: float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	main_camera.offset.x = cameraOffset * randf_range(0.9,3.5)
	main_camera.offset.y = cameraOffset * randf_range(0.9,3.5)
