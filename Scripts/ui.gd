extends CanvasLayer

@onready var input_display1 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay1
@onready var input_display2 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay2
@onready var input_display3 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay3
@onready var input_display4 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay4
@onready var input_display5 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay5
@onready var input_display6 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay6
@onready var input_display7 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay7
@onready var input_display8 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay8
@onready var input_display9 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay9
@onready var input_display10 = $Control/MarginContainer/HBoxContainer/VBoxContainer/inputDisplay10

#TODO make this^ an array parameter 

@onready var inputArray = $"../Input"

@onready var a_button : Texture = preload("res://Sprites/display/a_button.png")
@onready var b_button : Texture = preload("res://Sprites/display/b_button.png")
@onready var c_button : Texture = preload("res://Sprites/display/c_button.png")

@onready var up_arrow : Texture = preload("res://Sprites/display/up_arrow.png")
@onready var down_arrow : Texture = preload("res://Sprites/display/down_arrow.png")
@onready var left_arrow : Texture = preload("res://Sprites/display/left_arrow.png")
@onready var right_arrow : Texture = preload("res://Sprites/display/right_arrow.png")
@onready var upleft_arrow : Texture = preload("res://Sprites/display/upleft_arrow.png")
@onready var upright_arrow : Texture = preload("res://Sprites/display/upright_arrow.png")
@onready var downleft_arrow : Texture = preload("res://Sprites/display/downleft_arrow.png")
@onready var downright_arrow : Texture = preload("res://Sprites/display/downright_arrow.png")

var displayArray

func _ready():
	displayArray = {
		"display1": input_display1,
		"display2": input_display2,
		"display3": input_display3,
		"display4": input_display4,
		"display5": input_display5,
		"display6": input_display6,
		"display7": input_display7,
		"display8": input_display8,
		"display9": input_display9,
		"display10": input_display10,
	}

func _physics_process(delta):
	for n in 10:
		displayArray["display" + str(n + 1)].texture = null
	
	if(inputArray.inputs.size() != 0):
		for n in inputArray.inputs.size():
			input_ui(inputArray.inputs[n].type)

func input_ui(type : String):
	match type:
		"A":
			if choose_ui() != null:
				choose_ui().texture = a_button
		"B":
			if choose_ui() != null:
				choose_ui().texture = b_button
		"C":
			if choose_ui() != null:
				choose_ui().texture = c_button
		"up":
			if choose_ui() != null:
				choose_ui().texture = up_arrow
		"down":
			if choose_ui() != null:
				choose_ui().texture = down_arrow
		"left":
			if choose_ui() != null:
				choose_ui().texture = left_arrow
		"right":
			if choose_ui() != null:
				choose_ui().texture = right_arrow
		"up-l":
			if choose_ui() != null:
				choose_ui().texture = upleft_arrow
		"up-r":
			if choose_ui() != null:
				choose_ui().texture = upright_arrow
		"down-l":
			if choose_ui() != null:
				choose_ui().texture = downleft_arrow
		"down-r":
			if choose_ui() != null:
				choose_ui().texture = downright_arrow

func choose_ui():
	for n in 10:
		if(displayArray["display" + str(10 - n)].texture == null):
			return displayArray["display" + str(10 - n)]
