extends CollisionShape3D

func _on_hitbox_tell_script(leftside, pos_x, pos_y, scale_x, scale_y) -> void:
	scale.x = scale_x
	scale.y = scale_y
	position.y = pos_y
	
	if leftside == true:
		position.x = pos_x
	else:
		position.x = -pos_x
	
	disabled = false
