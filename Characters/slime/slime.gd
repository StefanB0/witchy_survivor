extends CharacterBody2D

enum MOVE_DIRECTION {LEFT, RIGHT, UP, DOWN}

@export_category("Player")
@export var player: CharacterBody2D

@export_category("Slime Statistics")
@export var max_hp: float = 50
@export var speed = 60
@export var contact_damage: float = 30
@export var knockback: float = 300

var current_hp = max_hp
var can_move: bool = true

@onready var Animation_Player := %AnimationPlayer
@onready var Stun_Timer: Timer = %Stun
@onready var Health_Bar: ProgressBar = %HealthBar

func _ready() -> void:
	Health_Bar.max_value = max_hp
	Health_Bar.value = max_hp

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if can_move:
		velocity = direction * speed
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()

func _process(delta: float) -> void:
	Animation_Player.play("walk_down")
	update_health_bar()
	if current_hp <= 0:
		queue_free()

func update_health_bar() -> void:
	Health_Bar.value = current_hp
	
func deal_damage(damage: float) -> void:
	current_hp -= damage
