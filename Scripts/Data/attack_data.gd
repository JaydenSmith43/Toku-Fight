extends Node

func do_throw(character: SGCharacterBody2D):
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "thrower")

func do_fireball(character: SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "hadou")

func do_attack_normal(character: SGCharacterBody2D, move_button: String):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = character.character_name + "_" + move_button
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "attack")

func check_motions_available(character: SGCharacterBody2D, input_array: Node, move_button: String):
	if character.motion236:
		if check_motion(character, input_array, [2,3,6], move_button):
			do_fireball(character)
	elif character.motion41236:
		if check_motion(character, input_array, [4,1,2,3,6], move_button):
			do_fireball(character)

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
			continue
		n += 1
	return false

func flip_motion(motion_array: Array[int]):
	pass
