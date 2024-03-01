extends Node2D

var cursor = preload("res://Art/ui/crosshair_red.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(8, 8))
