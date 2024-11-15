extends Node

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String
var I_medium : String
var I_heavy : String

var inputValue = preload("res://Scenes/Tools/input_value.tscn")
var current_frame : int = 0

var player = ""

var inputs = []

func _ready():
	if (get_parent().is_in_group("player1")):
		player = "player1"
	else:
		player = "player2"

#func _input(event):
	#if event is InputEventKey:
		#input_handler(event)

#func _physics_process(_delta):
	#current_frame += 1
	#add_time(1/60)

func input_handler(input: Dictionary):
	handle_directions(input)
	handle_buttons(input)
	add_time()

func handle_directions(input: Dictionary):
	if input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,1):
		var instance = inputValue.instantiate()
		instance.type = "7"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,-1):
		var instance = inputValue.instantiate()
		instance.type = "1"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(-1,0):
		var instance = inputValue.instantiate()
		instance.type = "4"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,1):
		var instance = inputValue.instantiate()
		instance.type = "9"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,-1):
		var instance = inputValue.instantiate()
		instance.type = "3"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(1,0):
		var instance = inputValue.instantiate()
		instance.type = "6"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,1):
		var instance = inputValue.instantiate()
		instance.type = "8"
		inputs.push_back(instance)
	elif input.get("input_vector", Vector2i.ZERO) == Vector2i(0,-1):
		var instance = inputValue.instantiate()
		instance.type = "2"
		inputs.push_back(instance)

func handle_buttons(input: Dictionary):
	if input.get("a"):
		var instance = inputValue.instantiate()
		instance.type = "A"
		inputs.push_back(instance)
	if input.get("b"):
		var instance = inputValue.instantiate()
		instance.type = "B"
		inputs.push_back(instance)
	if input.get("c"):
		var instance = inputValue.instantiate()
		instance.type = "C"
		inputs.push_back(instance)

func add_time():
	var offset = 0
	for n in inputs.size():
		inputs[n - offset].buffer_time += 1
		if inputs[n - offset].buffer_time >= 60:
			inputs.pop_at(n)
			offset += 1
