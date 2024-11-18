extends CanvasLayer

@onready var p1_image_container = $Control/MarginContainer/HBoxContainer/P1ImageContainer
@onready var p2_image_container = $Control/MarginContainer2/HBoxContainer/P2ImageContainer

@onready var input_array = $"../Input"

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
var last_input

func update_input_display():
	if input_array.player == "player1":
		for n in 20:
			p1_image_container.get_child(n).texture = null
	else:
		for n in 20:
			p2_image_container.get_child(n).texture = null
	
	if input_array.inputs.size() != 0:
		for n in input_array.inputs.size():
			input_ui(input_array.inputs[n])

func input_ui(type : String):
	if choose_ui() != null:
		match type:
			"A":
				choose_ui().texture = a_button
			"B":
				choose_ui().texture = b_button
			"C":
				choose_ui().texture = c_button
			"8":
				choose_ui().texture = up_arrow
			"2":
				choose_ui().texture = down_arrow
			"4":
				choose_ui().texture = left_arrow
			"6":
				choose_ui().texture = right_arrow
			"7":
				choose_ui().texture = upleft_arrow
			"9":
				choose_ui().texture = upright_arrow
			"1":
				choose_ui().texture = downleft_arrow
			"3":
				choose_ui().texture = downright_arrow

func choose_ui():
	if input_array.player == "player1":
		for n in 20:
			if p1_image_container.get_child(n).texture == null:
				return p1_image_container.get_child(n)
	else:
		for n in 20:
			if p2_image_container.get_child(n).texture == null:
				return p2_image_container.get_child(n)
