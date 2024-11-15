extends Node

func do_throw(character: SGCharacterBody2D):
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "thrower")

func do_fireball(character: SGCharacterBody2D, move_button: String):
	character.low_blocking = false
	character.high_blocking = false
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "hadou")

func do_attack_normal(character: SGCharacterBody2D, move_button: String):
	character.low_blocking = false
	character.high_blocking = false
	character.move_name = character.character_name + "_" + move_button
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "attack")

func check_motions_available(character: SGCharacterBody2D, input_array: Node, move_button: String):
	if character.motion41236:
		if check_motion(character, input_array, [4,1,2,3,6], move_button):
			do_fireball(character, move_button)
			return
	if character.motion236:
		if check_motion(character, input_array, [2,3,6], move_button):
			do_fireball(character, move_button)
			return
	
	do_attack_normal(character, move_button)

func check_motion(character: SGCharacterBody2D, input_array: Node, motion_array: Array[int], move_button: String):
	if !character.left_side:
		motion_array = flip_motion(motion_array)
	
	var n : int = 0
	var current_motion_direction : int = 0
	
	while n < input_array.inputs.size():
		if input_array.inputs[n].type == str(motion_array[current_motion_direction]):
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
