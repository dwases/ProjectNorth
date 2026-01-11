extends Node2D

@onready var building_audio_player: AudioStreamPlayer2D = $BuildingAudioPlayer
@onready var combat_audio_stream_player: AudioStreamPlayer2D = $CombatAudioStreamPlayer

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
		playerMoney = 300
func _on_ui_request_wave():
	start_wave()
func _spawn_enemy(base_stats: EnemyStats) -> Enemy_Buffer:
	var e := enemyScene.instantiate() as Enemy_Buffer
	e.stats = base_stats.duplicate(true) as EnemyStats
	return e
func _process(delta):
	if enemyAlive<=0 && isWaveActive:
		wave_end()
func _spawn_wave(pattern: Array[EnemyStats],baseDelay: float = 0.5, randTo: float = 1.0) -> void:
	for stats in pattern:
		var e := _spawn_enemy(stats)
		timer_spawn.wait_time = baseDelay + randf_range(0.0, randTo)
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
				classicStats,
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
				classicStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true

		3:
			var pattern := [
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				classicStats,
				classicStats,
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true
			
		4: 
			var pattern := [
				classicStats,
				vandalStats,
				classicStats,
				classicStats,
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				vandalStats
			] as Array[EnemyStats]
			await _spawn_wave(pattern)
			isWaveActive = true
		5: 
			var pattern := [
				heavyStats,
				classicStats,
				classicStats,
				heavyStats,
				vandalStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				classicStats,
				vandalStats,
				vandalStats,
				classicStats,
				vandalStats
			] as Array[EnemyStats]
			await _spawn_wave(pattern,0.5,0.5)
			isWaveActive = true
			
		6:
			var pattern := [
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				vandalStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				classicStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				vandalStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				classicStats,
				heavyStats,
				heavyStats,
				heavyStats,
				majorStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				classicStats,
				vandalStats,
				majorStats
			] as Array[EnemyStats]
			await _spawn_wave(pattern,0.2,0.2)
			isWaveActive = true
			
		7:
			var pattern := [
				heavyStats,
				heavyStats,
				classicStats,
				classicStats,
				majorStats,
				heavyStats,
				majorStats,
				heavyStats,
				majorStats,
				heavyStats,
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				vandalStats,
				classicStats,
				vandalStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				vandalStats,
				majorStats,
				heavyStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				majorStats,
				heavyStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				classicStats,
				heavyStats,
				heavyStats,
				heavyStats,
				majorStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				classicStats,
				vandalStats,
				majorStats
			] as Array[EnemyStats]
			await _spawn_wave(pattern,0.1,0.3)
			isWaveActive = true
		
		8:
			var pattern := [
				majorStats,
				majorStats,
				majorStats,
				heavyStats,
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				majorStats,
				heavyStats,
				majorStats,
				heavyStats,
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				majorStats,
				heavyStats,
				classicStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				vandalStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				classicStats,
				classicStats,
				classicStats,
				classicStats,
				heavyStats,
				vandalStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				classicStats,
				vandalStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				classicStats,
				heavyStats,
				heavyStats,
				vandalStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				vandalStats,
				heavyStats,
				vandalStats,
				majorStats,
				heavyStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				classicStats,
				vandalStats,
				majorStats,
				heavyStats,
				vandalStats,
				vandalStats,
				classicStats,
				heavyStats,
				classicStats,
				heavyStats,
				heavyStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				heavyStats,
				majorStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				heavyStats,
				vandalStats,
				vandalStats,
				heavyStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				majorStats,
				classicStats,
				vandalStats,
				majorStats
			] as Array[EnemyStats]
			await _spawn_wave(pattern,0.01,0.15)
			isWaveActive = true
		_:
			wave-=1
			wave_end()
	print("Sprawdzam Await")

func wave_end():
	var wave_win_audio : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	wave_win_audio.stream = preload("res://Sounds/winning wave sound.wav")
	#wave_win_audio.volume_db = -10
	wave_win_audio.autoplay = true
	get_tree().current_scene.add_child(wave_win_audio)
	
	wave+=1
	game_ui.wave_end(wave)
	isWaveActive = false
	
	combat_audio_stream_player.stop()
	building_audio_player.stop()
	building_audio_player.play()
