extends Node

func do_throw(character: SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "thrower")

func do_special(character: SGCharacterBody2D, _move_button: String, motion_string: String):
	###TODO move button determines type of move when unique strength specials added
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
	var list_of_motions
	
	if state == "ground":
		list_of_motions = character.ground_motions
	elif state == "jump":
		list_of_motions = character.jump_motions
	
	for motion in list_of_motions:
		if check_motion(character, input_array, string_to_int_array(motion), move_button, 20):
			do_special(character, move_button, motion)
			return
	
	if state == "ground":
		do_ground_attack(character, move_button)
		return
	elif state == "jump":
		do_jump_attack(character, move_button)
		return

func check_cancel(character: SGCharacterBody2D, input: Dictionary, input_array: Node, state: String):
	if character.buffered_move != "":
		return
	var cancel_array
	
	if character.get_groups()[0] == "player1" and StaticData.P1_move_data.has("cancel"):
		cancel_array = StaticData.P1_move_data["cancel"].split(",", false)
	elif StaticData.P2_move_data.has("cancel"):
		cancel_array = StaticData.P2_move_data["cancel"].split(",", false)
	
	if character.cancel and cancel_array != null:
		if state == "ground":
			ground_buffer(character, input, input_array, cancel_array)
		elif state == "jump":
			jump_buffer(character, input, input_array, cancel_array)

func ground_buffer(character: SGCharacterBody2D, input: Dictionary, input_array: Node, cancel_array):
	# Loop through and check for buffered normal cancels
	var input_check_sequence = ["A", "B", "C"]
	var cancel_check_sequence = ["5a", "2a", "5b", "2b", "5c", "2c"]
	var current_check_index = 0
	
	for input_check in input_check_sequence: # Checks for stand and crouch normal for input
		if input_array.was_pressed(input_check, 1) and input.get("input_vector", Vector2.ZERO).y == 0:
			for cancels in cancel_array:
				if cancels == cancel_check_sequence[current_check_index]:
					character.buffered_move = cancel_check_sequence[current_check_index]
					return
		if input_array.was_pressed(input_check, 1) and input.get("input_vector", Vector2.ZERO).y == -1:
			for cancels in cancel_array:
				if cancels == cancel_check_sequence[current_check_index + 1]:
					character.buffered_move = cancel_check_sequence[current_check_index + 1]
					return
		current_check_index += 2

func jump_buffer(character: SGCharacterBody2D, _input: Dictionary, input_array: Node, cancel_array):
	if input_array.was_pressed("C", 1):
		for cancels in cancel_array:
			if cancels == "jump_c":
				character.buffered_move = "jump_c"
				return
	if input_array.was_pressed("B", 1):
		for cancels in cancel_array:
			if cancels == "jump_b":
				character.buffered_move = "jump_b"
				return
	if input_array.was_pressed("A", 1):
		for cancels in cancel_array:
			if cancels == "jump_a":
				character.buffered_move = "jump_a"
				return

func check_motion(character: SGCharacterBody2D, input_array: Node, motion_array: Array[int], _move_button: String, input_window: int):
	if !character.left_side:
		motion_array = flip_motion(motion_array)
	
	input_window = 59 - input_window
	var motion_direction_index : int = 0
	
	# Iterate backwards from size (basically always 59) - window to 0 
	for n in range(input_array.input_frame.size() - input_window - 1, -1, -1):
		if input_array.input_frame[n][0] == str(motion_array[motion_direction_index]):
			if motion_direction_index == motion_array.size() - 1:
				return true
			motion_direction_index += 1
	
	return false

func string_to_int_array(motion_string: String):
	var int_array: Array[int]
	
	if motion_string[0] == "j":
		motion_string = motion_string.substr(1)
		pass
	for character in motion_string:
		int_array.append(int(character))
	return int_array

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
