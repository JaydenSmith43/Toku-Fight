class_name Hitbox3DEditor
extends Area3D

signal tell_script(facing, pos_x, pos_y, scale_x, scale_y, scale_z)
@export var mesh : MeshInstance3D

var shape : BoxShape3D
var damage := 10
var leftside := true
var player := ""
var scale_x := 0.0
var scale_y := 0.0
var pos_x := 0.0
var pos_y := 0.0
var end_frame := 0

func _ready() -> void:
	mesh.scale.x = scale_x
	mesh.scale.y = scale_y
	mesh.scale.z = 5
	tell_script.emit(leftside, pos_x, pos_y, scale_x, scale_y, 5)

func destroy():
	queue_free()
