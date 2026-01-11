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
var playerMoney: int = 0:
	set(value):
		playerMoney = value
		game_ui.MoneyLabel.text = str(playerMoney) + "$"

@onready var timer_spawn: Timer = $TimerSpawn

func _ready() -> void:
	if game_ui:
		game_ui.start_wave_requested.connect(_on_ui_request_wave)
		playerMoney = 100
func _on_ui_request_wave():
	start_wave()
func _spawn_enemy(base_stats: EnemyStats) -> Enemy_Buffer:
	var e := enemyScene.instantiate() as Enemy_Buffer
	e.stats = base_stats.duplicate(true) as EnemyStats
	return e
func _process(delta):
	if enemyAlive<=0 && isWaveActive:
		wave_end()
func _spawn_wave(pattern: Array[EnemyStats]) -> void:
	for stats in pattern:
		var e := _spawn_enemy(stats)
		timer_spawn.wait_time = 0.5 + randf_range(0.0, 1.2)
		timer_spawn.start()
		await timer_spawn.timeout
		path_2d.add_child(e)
		enemyAlive += 1

func start_wave() -> void:
	match wave:
		1:
			var pattern := [
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true

		2:
			var pattern := [
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true

		3:
			var pattern := [
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true
		_:
			wave-=1
			wave_end()
	print("Sprawdzam Await")

func wave_end():
	wave+=1
	game_ui.wave_end()
	isWaveActive = false
