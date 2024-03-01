extends CharacterBody2D

@export_category("Player character")

@export_group("Stats")
@export var max_hp: float = 100.0
@export var player_damage: float = 30
@export var atk_cooldown: float = 0.3
@export var projectile_speed: float = 600
@export var projectile_distance: float = 300
@export_group("Movement")
@export var player_speed: float = 120.0

var current_hp: float = max_hp

var knockback: Vector2 = Vector2(0, 0)
var can_move: bool = true
var atk_on_cooldown: bool = false
var input_direction: Vector2


@onready var Animation_Player := %AnimationPlayer
@onready var State_Chart: StateChart = %StateChart
@onready var Health_Bar: ProgressBar = %HealthBar

@onready var Cooldown: Timer = %Cooldown
@onready var Shooty_Origin: Marker2D = %ShootyOrigin
@onready var Shooty_Point: Marker2D = %ShootyPoint

@export_group("Dependencies")
@export var Game_Over_Shade: ColorRect

func _ready() -> void:
	Health_Bar.max_value = max_hp
	Health_Bar.value = max_hp

func _process(delta: float) -> void:
	check_game_over()
	update_health_bar()

func _physics_process(delta: float) -> void:
	player_movement()
	player_attack()

func player_attack() -> void:
	const PROJECTILE := preload("res://Characters/player/ice_projectile.tscn")
	Shooty_Origin.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("attack") and not atk_on_cooldown:
		var new_projectile = PROJECTILE.instantiate()
		
		new_projectile.set_speed(projectile_speed)
		new_projectile.damage = player_damage
		
		new_projectile.global_position = Shooty_Point.global_position
		new_projectile.global_rotation = Shooty_Point.global_rotation
		Shooty_Point.add_child(new_projectile)
		
		Cooldown.start(atk_cooldown)
		atk_on_cooldown = true
		#State_Chart.send_event("attack")

func player_movement():
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if can_move:
		velocity = input_direction * player_speed + knockback
	else:
		velocity = Vector2(0, 0)
	
	if signf(velocity.x) != 0:
		$Sprite2D.flip_h = velocity.x < 0
	
	move_and_slide()
	
	knockback = knockback.lerp(Vector2.ZERO, 0.1)

func take_damage(damage:float):
	current_hp -= damage
	print("HP: ", current_hp)

func update_health_bar() -> void:
	Health_Bar.value = current_hp

func check_game_over() -> void:
	if current_hp < 0:
		Game_Over_Shade.visible = true
		get_tree().paused = true

func _on_attack_state_entered() -> void:
	Animation_Player.play("take_damage")

func _on_idle_state_entered() -> void:
	can_move = true
	
func _on_idle_state_processing(delta: float) -> void:
	if input_direction:
		Animation_Player.play("run")
	else:
		Animation_Player.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	print(body.global_position)
	if body.is_in_group("enemy"):
		take_damage(body.contact_damage)
		
		var knockback_power = body.knockback
		knockback = -global_position.direction_to(body.global_position) * knockback_power
		


func _on_cooldown_timeout() -> void:
	atk_on_cooldown = false
