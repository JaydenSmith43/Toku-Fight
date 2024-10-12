extends Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= Vector3(event.relative.x / 180, -event.relative.y / 180, 0)
			position.x = clamp(-5, position.x, 5)
			position.y = clamp(-5, position.y, 5)
	
	if event is InputEventMouse:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
			size -= 0.5
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
			size += 0.5
	
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_R):
			position = Vector3(0,3,4)
			size = 8
