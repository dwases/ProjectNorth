extends Node2D


@onready var path_2d: Path2D = $Path2D
@onready var game_ui = $CanvasLayer/FullScreen
var isWaveActive: bool = false
#wyłącza UI włączonych menu towerów jeżeli nie klikniesz w nic użytecznego
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().call_group("selected_towers", "toggle_menu")

var wave: int = 1
var enemyScene = preload("res://Other/enemy_buffer.tscn")
var beaconStats = preload("res://Enemy/Resources/beacon_enemy_stats.tres")
var classicStats = preload("res://Enemy/Resources/classic_enemy_stats.tres")
var heavyStats = preload("res://Enemy/Resources/heavy_enemy_stats.tres")
var majorStats = preload("res://Enemy/Resources/major_enemy_stats.tres")
var vandalStats = preload("res://Enemy/Resources/vandal_enemy_stats.tres")
var enemyAlive: int = 0
var playerMoney: int = 100

@onready var timer_spawn: Timer = $TimerSpawn

func _ready() -> void:
	if game_ui:
		game_ui.start_wave_requested.connect(_on_ui_request_wave)
func _on_ui_request_wave():
	# Zabezpieczenie: nie startuj nowej fali, jak stara trwa
	if isWaveActive:
		return
	start_wave(wave)
func _spawn_enemy(base_stats: EnemyStats) -> Enemy_Buffer:
	var e := enemyScene.instantiate() as Enemy_Buffer
	e.stats = base_stats.duplicate(true) as EnemyStats
	return e

func _spawn_wave(pattern: Array[EnemyStats]) -> void:
	for stats in pattern:
		var e := _spawn_enemy(stats)
		timer_spawn.wait_time = 0.5 + randf_range(0.0, 1.2)
		timer_spawn.start()
		await timer_spawn.timeout
		path_2d.add_child(e)
		enemyAlive += 1

func start_wave(_wave: int) -> void:
	wave += 1
	match _wave:
		1:
			var pattern := [
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)

		2:
			var pattern := [
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)

		3:
			var pattern := [
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)

		_:
			pass
	print("Sprawdzam Await")

func wave_end():
	game_ui.wave_end()
