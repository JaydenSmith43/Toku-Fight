extends SGCollisionShape2D

func _on_hitbox_tell_script(left_side, fixed_pos_x, fixed_pos_y, extents_x, extents_y) -> void:
	var new_shape = SGRectangleShape2D.new()
	new_shape.extents_x = extents_x
	new_shape.extents_y = extents_y
	shape = new_shape
	
	fixed_position_y = fixed_pos_y
	
	if left_side == true:
		fixed_position_x = fixed_pos_x
	else:
		fixed_position_x = -fixed_pos_x
	
	disabled = false