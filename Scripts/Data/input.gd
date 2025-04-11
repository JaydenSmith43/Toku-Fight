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
		handle_directions(character, input)
		handle_buttons(character, input)
		add_time()

func handle_directions(character: SGCharacterBody2D, input: Dictionary):
	if input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,1):
		inputs.push_back("7")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,-1):
		inputs.push_back("1")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,0):
		inputs.push_back("4")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,1):
		inputs.push_back("9")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,-1):
		inputs.push_back("3")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,0):
		inputs.push_back("6")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,1):
		inputs.push_back("8")
		input_buffer_times.push_back(0)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,-1):
		inputs.push_back("2")
		input_buffer_times.push_back(0)

func handle_buttons(character: SGCharacterBody2D, input: Dictionary):
	if input.get("a"):
		inputs.push_back("A")
		input_buffer_times.push_back(0)
	if input.get("b"):
		inputs.push_back("B")
		input_buffer_times.push_back(0)
	if input.get("c"):
		inputs.push_back("C")
		input_buffer_times.push_back(0)

func add_time():
	var index = 0
	while index < inputs.size():
		input_buffer_times[index] += 1
		if input_buffer_times[index] >= 60:
			inputs.pop_at(index)
			input_buffer_times.pop_at(index)
		else:
			index += 1
