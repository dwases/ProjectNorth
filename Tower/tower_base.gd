extends StaticBody2D
class_name Tower

@export var stats: TowerStats
var targets_in_range: Array[Node2D] = []

func get_best_target() -> Node2D:
	# ZMIANA: Pobieramy WSZYSTKICH (widzianych + słyszanych)
	var all_targets = get_all_targets()
	
	if all_targets.is_empty():
		return null
	
	# Sortowanie zgodnie z GDD: 1. Głośność, 2. Progres
	# [cite: 47] "na priorytet bierze wrogów najgłośniejszych... w przypadku remisu o większej progresji"
	all_targets.sort_custom(func(a, b):
		# Safety check: upewnij się, że obiekt ma zmienne (jeśli enemy nie jest w 100% gotowy)
		var a_loud = a.loudness if "loudness" in a else 0
		var b_loud = b.loudness if "loudness" in b else 0
		var a_prog = a.progress if "progress" in a else 0
		var b_prog = b.progress if "progress" in b else 0
		
		if a_loud != b_loud:
			return a_loud > b_loud
		return a_prog > b_prog
	)
	
	return all_targets[0]
var can_shoot = true



func shoot(target):
	can_shoot = false
	$ReloadTimer.wait_time = 1.0 / stats.Attack_speed 
	$ReloadTimer.start()
	get_best_target().take_damage(stats.Damage)

func _on_reload_timer_timeout():
	can_shoot = true

# Klucz: Enemy (Node2D), Wartość: Czas (msec), kiedy mamy przestać go pamiętać
var heard_enemies_timers: Dictionary = {} 

func hear_enemy(enemy: Node2D):
	# Ustawiamy czas wygaśnięcia na: Aktualny czas + 1000ms
	var expire_time = Time.get_ticks_msec() + 1000
	
	# Słownik automatycznie nadpisuje wartość, jeśli wróg już tam jest (resetuje timer)
	heard_enemies_timers[enemy] = expire_time

func _process(delta):
	# Sprawdzamy, czy ktoś nie powinien wylecieć z pamięci
	var current_time = Time.get_ticks_msec()
	var target = get_best_target()
	if target and can_shoot:
		shoot(target)
	# Iterujemy po kopii kluczy, żeby móc bezpiecznie usuwać elementy w trakcie pętli
	for enemy in heard_enemies_timers.keys():
		# Safety check: czy wróg nie umarł w międzyczasie
		if not is_instance_valid(enemy):
			heard_enemies_timers.erase(enemy)
			continue
			
		if current_time >= heard_enemies_timers[enemy]:
			heard_enemies_timers.erase(enemy)
			# print("Zapomniałem o przeciwniku:", enemy)

# Funkcja pomocnicza dla systemu celowania
func get_all_targets() -> Array:
	var combined_targets = []
	# Dodaj tych z Area2D (fizyczny zasięg)
	combined_targets.append_array(targets_in_range) 
	
	# Dodaj tych z pamięci słuchowej (jeśli jeszcze ich nie ma na liście)
	for enemy in heard_enemies_timers.keys():
		if is_instance_valid(enemy) and not combined_targets.has(enemy):
			combined_targets.append(enemy)
			
	return combined_targets
