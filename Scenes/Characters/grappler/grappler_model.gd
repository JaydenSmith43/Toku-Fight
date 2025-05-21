extends Node3D

@export var mesh1 : MeshInstance3D
@export var mesh2 : MeshInstance3D

var mat1 = preload("res://Materials/grappler_1_mat.tres")
var mat2 = preload("res://Materials/grappler_2_mat.tres")

func swap_color(color_id: int):
	match color_id:
		1:
			mesh1.set_surface_override_material(0, mat1)
			mesh2.set_surface_override_material(0, mat1)
		2:
			mesh1.set_surface_override_material(0, mat2)
			mesh2.set_surface_override_material(0, mat2)
