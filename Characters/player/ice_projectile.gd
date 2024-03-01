extends Area2D

var base_speed: float = 1000
var current_speed: float = base_speed
var damage: float = 1
var distance: float = base_speed

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	current_speed = lerp(current_speed, base_speed/5, 0.075)
	position += direction * current_speed * delta
	distance -= current_speed * delta
	if distance <= 0:
		queue_free()

func set_speed(new_speed: float) -> void:
	base_speed = new_speed
	current_speed = new_speed
	distance = new_speed * 0.3
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy: CharacterBody2D = area.get_entity()
		enemy.deal_damage(damage)
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	queue_free()
