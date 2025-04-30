extends CanvasLayer

@onready var p1_image_container1 = $Control/MarginContainer/HBoxContainer/P1ImageContainer1
@onready var p1_image_container2 = $Control/MarginContainer/HBoxContainer/P1ImageContainer2
@onready var p1_image_container3 = $Control/MarginContainer/HBoxContainer/P1ImageContainer3
@onready var p1_image_container4 = $Control/MarginContainer/HBoxContainer/P1ImageContainer4
@onready var p1_frame_container = $Control/MarginContainer/HBoxContainer/P1FrameContainer

@onready var p2_image_container1 = $Control/MarginContainer2/HBoxContainer/P2ImageContainer1
@onready var p2_image_container2 = $Control/MarginContainer2/HBoxContainer/P2ImageContainer2
@onready var p2_image_container3 = $Control/MarginContainer2/HBoxContainer/P2ImageContainer3
@onready var p2_image_container4 = $Control/MarginContainer2/HBoxContainer/P2ImageContainer4
@onready var p2_frame_container = $Control/MarginContainer2/HBoxContainer/P2FrameContainer

@onready var p1_input_array = $"../Game/test1/Input"
@onready var p2_input_array = $"../Game/test2/Input"

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
@onready var neutral_arrow : Texture = preload("res://Sprites/display/neutral_arrow.png")

var displayArray
var current_display_index = 0
var p1_last_inputs : Array[String] = []
var p2_last_inputs : Array[String] = []

func _physics_process(delta: float) -> void:
	var new_p1_last_inputs : Array[String] = []
	var new_p2_last_inputs : Array[String] = []
	
	for x in range(p1_input_array.input_buffer_times.size()):
		if p1_input_array.input_buffer_times[x] == 1:
			update_input_display(true, x)
			new_p1_last_inputs.append(p1_input_array.inputs[x])
		else:
			break
	#for x in p2_input_array.input_buffer_times:
		#if x == 1:
			#update_input_display(false, x)
		#else:
			#break

func update_input_display(is_player1: bool, index: int):
	
	if is_player1 and p1_input_array.inputs.size() > 0: #if new input from player1
		input_ui(is_player1, p1_input_array.inputs[index])
	elif !is_player1 and p2_input_array.inputs.size() > 0: #if new input from player2
		input_ui(is_player1, p2_input_array.inputs[index])
	
	#if input_array.player == "player1":
		#for n in 20:
			#p1_image_container.get_child(n).texture = null
	#else:
		#for n in 20:
			#p2_image_container.get_child(n).texture = null

func input_ui(is_player1: bool, input_type : String):
	if is_player1: # is input the same as last frame?
		if p1_last_inputs.has(input_type):
			increase_frame_display(is_player1)
		else: # if not add new input
			add_new_image_display(is_player1, input_type) 
	else:
		if p2_last_inputs.has(input_type):
			increase_frame_display(is_player1)
		else:
			add_new_image_display(is_player1, input_type)
	
	

func add_new_image_display(is_player1: bool, input_type : String):
	move_down_input_display(is_player1)
	
	if is_player1:
		p1_image_container1.get_child(0).texture = choose_texture(input_type)
	else:
		p2_image_container1.get_child(0).texture = choose_texture(input_type)

func increase_frame_display(is_player1: bool):
	if is_player1:
		var frame_count = int(p1_frame_container.get_child(0).text)
		p1_frame_container.get_child(0).text = str(frame_count + 1)
	else:
		var frame_count = int(p2_frame_container.get_child(0).text)
		p2_frame_container.get_child(0).text = str(frame_count + 1)
	

func move_down_input_display(is_player1: bool):
	if is_player1:
		for n in range(19, -1, -1):
			var higher_image_container = p1_image_container1.get_child(n - 1)
			var higher_frame_container = p1_frame_container.get_child(n - 1)
			
			if higher_image_container.texture != null:
				p1_image_container1.get_child(n).texture = higher_image_container.texture
			p1_frame_container.get_child(n).text = higher_frame_container.text
	else:
		for n in range(19, -1, -1):
			var higher_image_container = p2_image_container1.get_child(n - 1)
			var higher_frame_container = p2_frame_container.get_child(n - 1)
			
			if higher_image_container.texture != null:
				p2_image_container1.get_child(n).texture = higher_image_container.texture
			p2_frame_container.get_child(n).text = higher_frame_container.text

func choose_texture(input_type : String):
	match input_type:
		"_":
			return neutral_arrow
		"A":
			return a_button
		"a":
			return a_button
		"B":
			return b_button
		"b":
			return b_button
		"C":
			return c_button
		"c":
			return c_button
		"8":
			return up_arrow
		"2":
			return down_arrow
		"4":
			return left_arrow
		"6":
			return right_arrow
		"7":
			return upleft_arrow
		"9":
			return upright_arrow
		"1":
			return downleft_arrow
		"3":
			return downright_arrow

#func choose_ui_display():
	#if input_array.player == "player1":
		#for n in 20:
			#if p1_image_container.get_child(n).texture == null:
				#return p1_image_container.get_child(n)
	#else:
		#for n in 20:
			#if p2_image_container.get_child(n).texture == null:
				#return p2_image_container.get_child(n)
