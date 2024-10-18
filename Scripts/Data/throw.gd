class_name Throw
extends Area3D

signal tell_script(facing, pos_x, pos_y, scale_x, scale_y, scale_z)

var shape : BoxShape3D
var leftside := true
var player := ""
var scale_x := 0.0
var scale_y := 0.0
var pos_x := 0.0
var pos_y := 0.0
var end_frame := 5
var current_frame := 0

func _ready() -> void:
	if player == "player2":
		set_collision_layer_value(8, false)
		set_collision_mask_value(7, false)
		set_collision_layer_value(9, true)
		set_collision_mask_value(6, true)
	tell_script.emit(leftside, pos_x, pos_y, scale_x, scale_y, 1)

func _physics_process(_delta):
	current_frame += 1
	
	if current_frame >= end_frame:
		queue_free()
