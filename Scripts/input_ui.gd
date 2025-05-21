extends CanvasLayer

@onready var p1_image_containers = [
	$"Control/P1 Input Display/HBoxContainer/P1ImageContainer1",
	$"Control/P1 Input Display/HBoxContainer/P1ImageContainer2",
	$"Control/P1 Input Display/HBoxContainer/P1ImageContainer3",
	$"Control/P1 Input Display/HBoxContainer/P1ImageContainer4"
]
@onready var p2_image_containers = [
	$"Control/P2 Input Display/HBoxContainer/P2ImageContainer1",
	$"Control/P2 Input Display/HBoxContainer/P2ImageContainer2", 
	$"Control/P2 Input Display/HBoxContainer/P2ImageContainer3",
	$"Control/P2 Input Display/HBoxContainer/P2ImageContainer4"
]
@onready var p1_frame_container = $"Control/P1 Input Display/HBoxContainer/P1FrameContainer"
@onready var p2_frame_container = $"Control/P2 Input Display/HBoxContainer/P2FrameContainer"

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

#var displayArray
var current_display_index = 0
var p1_last_inputs : Array[String] = []
var p2_last_inputs : Array[String] = []

func _physics_process(delta: float) -> void:
	var p1_current_inputs : Array[String] = []
	var p2_current_inputs : Array[String] = []
	
	for x in range(p1_input_array.input_buffer_times.size()):
		if p1_input_array.input_buffer_times[x] == 1:
			p1_current_inputs.append(p1_input_array.inputs[x].to_lower())
		else:
			break
	for x in range(p2_input_array.input_buffer_times.size()):
		if p2_input_array.input_buffer_times[x] == 1:
			p2_current_inputs.append(p2_input_array.inputs[x].to_lower())
		else:
			break
	if p1_current_inputs.size() > 0:
		input_ui(p1_image_containers, p1_frame_container, p1_current_inputs)
	if p2_current_inputs.size() > 0:
		input_ui(p2_image_containers, p2_frame_container, p2_current_inputs)
	
	# the players current inputs will be used for the next frame
	p1_last_inputs = p1_current_inputs 
	p2_last_inputs = p2_current_inputs

func input_ui(image_containers, frame_container, current_inputs: Array[String]):
	var new_inputs: bool = false
	
	if current_inputs.size() < p1_last_inputs.size():
		add_new_image_display(image_containers, frame_container, current_inputs)
		new_inputs = true
	else:
		for input in current_inputs:
			if p1_last_inputs.has(input): # Are inputs the same as last frame?
				continue
			else: # if not add new input display
				add_new_image_display(image_containers, frame_container, current_inputs)
				new_inputs = true
				break
	if !new_inputs:
		increase_frame_display(frame_container)

func add_new_image_display(image_containers, frame_container, current_inputs: Array[String]):
	move_down_input_display(image_containers, frame_container)
	clear_top_input_display(image_containers, frame_container)
	
	var image_index: int = 0
	var find_order: Array[String] = ["a", "b", "c"]
	var find_order_index: int = 0
	
	for input in current_inputs: #find the direction input first
		var checkForDirection = choose_direction_texture(input)
		if checkForDirection:
			image_containers[image_index].get_child(0).texture = checkForDirection
			image_index += 1
			break
	for find_input in find_order:
		for input in current_inputs:
			if input == find_input:
				image_containers[image_index].get_child(0).texture = choose_button_texture(input)
				image_index += 1
				break

func increase_frame_display(frame_container):
	var frame_count = int(frame_container.get_child(0).text)
	frame_container.get_child(0).text = str(frame_count + 1)

func clear_top_input_display(image_containers, frame_container):
	for image_container in image_containers:
		image_container.get_child(0).texture = null
	frame_container.get_child(0).text = "1"

func move_down_input_display(image_containers, frame_container):
	for n in range(19, -1, -1):
		var higher_image_containers = [
			image_containers[0].get_child(n - 1), 
			image_containers[1].get_child(n - 1), 
			image_containers[2].get_child(n - 1),
			image_containers[3].get_child(n - 1)
		]
		var higher_frame_container = frame_container.get_child(n - 1)
		
		for x in range(0, 4):
			if higher_image_containers[x].texture != null:
				image_containers[x].get_child(n).texture = higher_image_containers[x].texture
			else:
				image_containers[x].get_child(n).texture = null
		frame_container.get_child(n).text = higher_frame_container.text

func choose_button_texture(input_type: String):
	match input_type:
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

func choose_direction_texture(input_type: String):
	match input_type:
		"_":
			return neutral_arrow
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
