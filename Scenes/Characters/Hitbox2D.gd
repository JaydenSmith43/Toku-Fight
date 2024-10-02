class_name Hitbox2D
extends Area2D

var collision : CollisionShape2D

var damage := 0
var size_x := 130
var size_y := -128
var end_frame := 0

func _init() -> void:
	#collision = get_child(1).shape
	#collision.shape
	transform.x = Vector2(size_x, size_y)
	collision_layer = 2
	collision_mask = 0
	pass

func _physics_process(delta):
	pass
