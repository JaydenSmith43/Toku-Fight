extends CollisionShape3D

func _on_hitbox_tell_script(leftside, pos_x, pos_y, scale_x, scale_y, scale_z) -> void:
	var new_shape = BoxShape3D.new()
	new_shape.size = Vector3(scale_x, scale_y, scale_z)
	shape = new_shape
	
	position.y = pos_y
	
	if leftside == true:
		position.x = pos_x
	else:
		position.x = -pos_x
	
	disabled = false
