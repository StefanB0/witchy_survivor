extends PathFollow2D

@export var Spawn_Timer: Timer

var time_elapsed: float = 0
var difficulty_level := 0

@onready var player = %Player

func _ready() -> void:
	Spawn_Timer.wait_time = 1/2

func _process(delta: float) -> void:
	time_elapsed += delta
	progress_difficulty()

func progress_difficulty() -> void:
	if time_elapsed > 30 and difficulty_level == 0:
		difficulty_level = 1
		Spawn_Timer.wait_time = 1/2
	if time_elapsed > 60 and difficulty_level == 1:
		difficulty_level = 2
		Spawn_Timer.wait_time = 1/4
	if time_elapsed > 90 and difficulty_level == 2:
		difficulty_level = 3
		Spawn_Timer.wait_time = 1/8

func spawn_slime() -> void:
	const SLIME = preload("res://Characters/slime/slime.tscn")
	var new_slime = SLIME.instantiate()
	progress_ratio = randf()
	
	new_slime.player = player
	new_slime.global_position = global_position
	add_child(new_slime)


func _on_spawn_timer_timeout() -> void:
	for _i in range(difficulty_level*difficulty_level*difficulty_level+1):
		spawn_slime()
