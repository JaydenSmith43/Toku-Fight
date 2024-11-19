extends Node

func do_throw(character: SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "thrower")

func do_special(character: SGCharacterBody2D, move_button: String, motion_string: String):
	character.low_blocking = false
	character.high_blocking = false
	var state_name = character.character_name + motion_string
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, state_name)

func do_ground_attack(character: SGCharacterBody2D, move_button: String):
	character.low_blocking = false
	character.high_blocking = false
	character.move_name = character.character_name + "_" + move_button
	character.buffered_move = ""
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "groundattack")
	
func do_jump_attack(character: SGCharacterBody2D, move_button: String):
	character.low_blocking = false
	character.high_blocking = false
	character.move_name = character.character_name + "_" + move_button
	character.buffered_move = ""
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "jumpattack")

func check_motions_available(character: SGCharacterBody2D, input_array: Node, move_button: String, state: String):
	if character.motions.has("63214") and state == "ground":
		if check_motion(character, input_array, [6,3,2,1,4], move_button):
			do_special(character, move_button, "63214")
			return
	if character.motions.has("j236") and state == "jump":
		if check_motion(character, input_array, [2,3,6], move_button):
			do_special(character, move_button, "j236")
			return
	
	if state == "ground":
		do_ground_attack(character, move_button)
		return
	elif state == "jump":
		do_jump_attack(character, move_button)
		return

func check_cancel(character: SGCharacterBody2D, input: Dictionary, state: String):
	if character.buffered_move != "":
		return
	
	var cancel_array
	if character.get_groups()[0] == "player1" and StaticData.P1_move_data.has("cancel"):
		cancel_array = StaticData.P1_move_data["cancel"].split(",", false)
	elif StaticData.P2_move_data.has("cancel"):
		cancel_array = StaticData.P2_move_data["cancel"].split(",", false)
	
	if character.cancel and cancel_array != null:
		if state == "ground":
			ground_buffer(character, input, cancel_array)
		if state == "jump":
			jump_buffer(character, input, cancel_array)

func ground_buffer(character: SGCharacterBody2D, input: Dictionary, cancel_array):
	if input.get("a") and input.get("input_vector", Vector2.ZERO).y == 0:
		for cancels in cancel_array:
			if cancels == "5a":
				character.buffered_move = "5a"
				return
	if input.get("a") and input.get("input_vector", Vector2.ZERO).y == -1:
		for cancels in cancel_array:
			if cancels == "2a":
				character.buffered_move = "2a"
				return
	if input.get("b") and input.get("input_vector", Vector2.ZERO).y == 0:
		for cancels in cancel_array:
			if cancels == "5b":
				character.buffered_move = "5b"
				return
	if input.get("b") and input.get("input_vector", Vector2.ZERO).y == -1:
		for cancels in cancel_array:
			if cancels == "2b":
				character.buffered_move = "2b"
				return
	if input.get("c") and input.get("input_vector", Vector2.ZERO).y == 0:
		for cancels in cancel_array:
			if cancels == "5c":
				character.buffered_move = "5c"
				return
	if input.get("c") and input.get("input_vector", Vector2.ZERO).y == -1:
		for cancels in cancel_array:
			if cancels == "2c":
				character.buffered_move = "2c"
				return

func jump_buffer(character: SGCharacterBody2D, input: Dictionary, cancel_array):
	if input.get("c"):
		for cancels in cancel_array:
			if cancels == "jump_c":
				character.buffered_move = "jump_c"
				return
	if input.get("b"):
		for cancels in cancel_array:
			if cancels == "jump_b":
				character.buffered_move = "jump_b"
				return
	if input.get("a"):
		for cancels in cancel_array:
			if cancels == "jump_a":
				character.buffered_move = "jump_a"
				return


func check_motion(character: SGCharacterBody2D, input_array: Node, motion_array: Array[int], move_button: String):
	if !character.left_side:
		motion_array = flip_motion(motion_array)
	
	var n : int = 0
	var current_motion_direction : int = 0
	
	while n < input_array.inputs.size():
		if input_array.inputs[n] == str(motion_array[current_motion_direction]):
			if current_motion_direction == motion_array.size() - 1:
				return true
			current_motion_direction += 1
		n += 1
	return false

func flip_motion(motion_array: Array[int]):
	var new_motion_array : Array[int]
	
	for n in motion_array:
		match n:
			1:
				new_motion_array.append(3)
			2:
				new_motion_array.append(2)
			3:
				new_motion_array.append(1)
			4:
				new_motion_array.append(6)
			5:
				new_motion_array.append(5)
			6:
				new_motion_array.append(4)
			7:
				new_motion_array.append(9)
			8:
				new_motion_array.append(8)
			9:
				new_motion_array.append(7)
	return new_motion_array
