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

var inputs = []

func _ready():
	if (get_parent().is_in_group("player1")):
		I_left = "P1_Left"
		I_right = "P1_Right"
		I_up = "P1_Up"
		I_down = "P1_Down"
		I_light = "P1_Light"
		I_medium = "P1_Medium"
		I_heavy = "P1_Heavy"
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		I_up = "P2_Up"
		I_down = "P2_Down"
		I_light = "P2_Light"
		I_medium = "P2_Medium"
		I_heavy = "P2_Heavy"

func _input(event):
	if event is InputEventKey:
		input_handler(event)

func _physics_process(delta):
	current_frame += 1
	add_time(delta)

func input_handler(event):
	#region 8-way directions
	if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_right):
		pass
	elif Input.is_action_pressed(I_up) and Input.is_action_pressed(I_down):
		pass
	if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_up):
		var instance = inputValue.instantiate()
		instance.type = "7"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_left) and Input.is_action_pressed(I_down):
		var instance = inputValue.instantiate()
		instance.type = "1"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_left) and !Input.is_action_pressed(I_right):
		var instance = inputValue.instantiate()
		instance.type = "4"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_right) and Input.is_action_pressed(I_up):
		var instance = inputValue.instantiate()
		instance.type = "9"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_right) and Input.is_action_pressed(I_down):
		var instance = inputValue.instantiate()
		instance.type = "3"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_right) and !Input.is_action_pressed(I_left):
		var instance = inputValue.instantiate()
		instance.type = "6"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_up):
		var instance = inputValue.instantiate()
		instance.type = "8"
		inputs.push_back(instance)
	elif Input.is_action_pressed(I_down):
		var instance = inputValue.instantiate()
		instance.type = "2"
		inputs.push_back(instance)
	#endregion
	
	#region buttons
	if Input.is_action_just_pressed(I_light):
		var instance = inputValue.instantiate()
		instance.type = "A"
		inputs.push_back(instance)
	if Input.is_action_just_pressed(I_medium):
		var instance = inputValue.instantiate()
		instance.type = "B"
		inputs.push_back(instance)
	if Input.is_action_just_pressed(I_heavy):
		var instance = inputValue.instantiate()
		instance.type = "C"
		inputs.push_back(instance)
	#endregion

func add_time(delta):
	var offset = 0
	for n in inputs.size():
		inputs[n - offset].buffer_time += delta
		if inputs[n - offset].buffer_time >= 1:
			inputs.pop_at(n)
			offset += 1
