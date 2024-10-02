class_name Hitbox3D
extends Area3D

signal tell_script

var damage := 10
var size_x := 130
var size_y := -128
var end_frame := 0
var current_frame := 0

func _init() -> void:
	#collision = get_child(1).shape
	#collision.shape
	#transform = Vector3(size_x, size_y, 50)
	#collision_layer = 3
	#collision_mask = 2
	pass

func _physics_process(delta):
	if current_frame == 0:
		tell_script.emit()
	
	current_frame += 1
	
	if current_frame >= end_frame:
		queue_free()
