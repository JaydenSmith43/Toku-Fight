extends Node3D

@export var mesh1 : MeshInstance3D
@export var mesh2 : MeshInstance3D
@export var model : Node3D

var mat1 = preload("res://Materials/grappler_1_mat.tres")
var mat2 = preload("res://Materials/grappler_2_mat.tres")

var hitstop_active = false
var ground_hitstun_pattern = [-0.05,0]
var pattern_index = 0

func swap_color(color_id: int):
	match color_id:
		1:
			mesh1.set_surface_override_material(0, mat1)
			mesh2.set_surface_override_material(0, mat1)
		2:
			mesh1.set_surface_override_material(0, mat2)
			mesh2.set_surface_override_material(0, mat2)

func _physics_process(_delta: float) -> void:
	if hitstop_active:
		pattern_index += 1
		if pattern_index > ground_hitstun_pattern.size() - 1:
			pattern_index = 0
		
		model.position.z = ground_hitstun_pattern[pattern_index]
	else:
		pattern_index = 0
