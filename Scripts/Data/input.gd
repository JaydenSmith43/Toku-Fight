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

var inputs : Array[String] = []
var input_buffer_times : Array[int] = []
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
		var directions_pressed = handle_directions(character, input)
		handle_buttons(character, input, directions_pressed)
		add_time()

func handle_directions(character: SGCharacterBody2D, input: Dictionary):
	if input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,1):
		inputs.push_front("7")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,-1):
		inputs.push_front("1")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,0):
		inputs.push_front("4")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,1):
		inputs.push_front("9")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,-1):
		inputs.push_front("3")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,0):
		inputs.push_front("6")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,1):
		inputs.push_front("8")
		input_buffer_times.push_front(0)
		return true
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,-1):
		inputs.push_front("2")
		input_buffer_times.push_front(0)
		return true
	return false

func handle_buttons(character: SGCharacterBody2D, input: Dictionary, directions_pressed: bool):
	var button_pressed = false
	
	if input.get("a") and (inputs.front() == "A" || inputs.front() == "a"):
		inputs.push_front("a")
		input_buffer_times.push_front(0)
		button_pressed = true
	elif input.get("a"):
		inputs.push_front("A")
		input_buffer_times.push_front(0)
		button_pressed = true
	
	if input.get("b") and (inputs.front() == "B" || inputs.front() == "b"):
		inputs.push_front("b")
		input_buffer_times.push_front(0)
		button_pressed = true
	elif input.get("b"):
		inputs.push_front("B")
		input_buffer_times.push_front(0)
		button_pressed = true
	
	if input.get("c") and (inputs.front() == "C" || inputs.front() == "c"):
		inputs.push_front("c")
		input_buffer_times.push_front(0)
		button_pressed = true
	elif input.get("c"):
		inputs.push_front("C")
		input_buffer_times.push_front(0)
		button_pressed = true
	
	if !button_pressed and !directions_pressed:
		inputs.push_front("_")
		input_buffer_times.push_front(0)

func add_time():
	var index = 0
	while index < inputs.size():
		input_buffer_times[index] += 1
		if input_buffer_times[index] >= 60:
			inputs.pop_at(index)
			input_buffer_times.pop_at(index)
		else:
			index += 1

func was_pressed(input: String):
	for n in range(inputs.size()):
		if input_buffer_times[n] > -1 and input_buffer_times[n] < 4 and input == inputs[n]:
			return true
		elif input_buffer_times[n] > 3:
			return false
	pass
