extends Node

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String
var I_medium : String
var I_heavy : String

#var inputValue = preload("res://Scenes/Tools/input_value.tscn")

var player = ""
var current_frame = 0

var input_frame := [] # holds arrays of strings
var input_buffer_times := [] # holds arrays of ints
#var input_frames : Array[int] = []

func _ready():
	if (get_parent().is_in_group("player1")):
		player = "player1"
	else:
		player = "player2"

func input_handler(character: SGCharacterBody2D, input: Dictionary):
	character.input_current_frame += 1
	if character.input_current_frame > current_frame:
		current_frame = character.input_current_frame
		
		var new_input_array = []
		handle_buttons(character, input, new_input_array)
		handle_directions(character, input, new_input_array)
		
		input_frame.push_front(new_input_array)
		input_buffer_times.push_front(0)
		
		add_time()

func handle_directions(_character: SGCharacterBody2D, input: Dictionary, new_input_array):
	var directions_pressed = false
	var directions_check := [
		Vector2i(-1,1), Vector2i(-1,-1), Vector2i(-1,0), Vector2i(1,1),
		Vector2i(1,-1), Vector2i(1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(0,0)
	]
	var input_strings := ["7", "1", "4", "9", "3", "6", "8", "2", "5"]
	
	for n in range(0, directions_check.size()):
		if input.get("input_vector", Vector2i.ZERO) == directions_check[n]:
			new_input_array.push_front(input_strings[n])
			return # can only have one direction input
			#input_buffer_times.push_front(0)

func handle_buttons(_character: SGCharacterBody2D, input: Dictionary, new_input_array):
	var button_pressed = false
	var input_checks = ["a", "A", "b", "B", "c", "C"]
	var inputs_pressed
	
	for n in range(0, 6, 2): # Checks inputs in pairs of 2 ("a", "A")
		if input.get(input_checks[n]) and (was_pressed(input_checks[n + 1], 1) || was_pressed(input_checks[n], 1)):
			new_input_array.push_front(input_checks[n])
			#input_buffer_times.push_front(0)
			button_pressed = true
		elif input.get(input_checks[n]):
			new_input_array.push_front(input_checks[n + 1])
			#input_buffer_times.push_front(0)
			button_pressed = true
	
	if !button_pressed:
		new_input_array.push_front("_")
		#input_buffer_times.push_front(0)

func was_pressed(input: String, buffer_time: int):
	for n in range(input_frame.size()):
		if input_buffer_times[n] > 0 and input_buffer_times[n] < buffer_time + 1:
			for input_array_input in input_frame[n]:
				if input == input_array_input:
					return true
		elif input_buffer_times[n] > 1:
			return false

func add_time():
	var index = 0
	while index < input_frame.size():
		input_buffer_times[index] += 1
		if input_buffer_times[index] >= 60:
			input_frame.pop_at(index)
			input_buffer_times.pop_at(index)
		else:
			index += 1
