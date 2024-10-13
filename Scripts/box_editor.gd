extends Node3D

@export var animation_option_button : OptionButton
@export var character_option_button : OptionButton
@export var line_edit : LineEdit
@export var total_frame_label : Label
var grappler_model = preload("res://Scenes/Characters/grappler/grappler_model.tscn")
var hitbox = preload("res://Scenes/Characters/hitbox3d_editor.tscn")

var current_model
var current_anim_player : AnimationPlayer
var current_frame = 1
var animations = []
var current_boxes = []
#var current_frame : int = 1

func _ready() -> void:
	load_character_data()

func _physics_process(_delta):
	#if current_anim_player.is_playing():
		#current_anim_player.pause()
	pass

func load_character_data():
	if current_model:
		current_model.queue_free()
	
	animation_option_button.clear()
	
	current_model = grappler_model.instantiate()
	add_child(current_model)
	
	current_anim_player = current_model.get_node("AnimationPlayer")
	
	var animsss = current_anim_player.get_animation_list()
	for anim_name in animsss:
		animation_option_button.add_item(anim_name)
	load_animation()

func load_animation():
	current_anim_player.play(animation_option_button.get_item_text(animation_option_button.get_selected_id()))
	_on_line_edit_text_changed(str(int(line_edit.text)))
	total_frame_label.text = "Total Frames: " + str(int(current_anim_player.current_animation_length * 60))
	check_for_file()
 
func load_anim_frame(frame : float):
	current_frame = frame
	current_anim_player.play()
	current_anim_player.seek(frame/60, true)
	current_anim_player.speed_scale = 0
	load_frame_data()

func check_for_file():
	var charactername = character_option_button.get_item_text(character_option_button.get_selected_id())
	var movename = animation_option_button.get_item_text(animation_option_button.get_selected_id())
	StaticData.load_json_file(charactername + "_" + movename, "player1")
	load_frame_data()

func load_frame_data():
	for box in current_boxes:
		if box == null:
			pass
		else:
			box.queue_free()
	
	load_previous_active_frames()
	
	if StaticData.P1_move_data.has("frames"):
		for data in StaticData.P1_move_data["frames"]:
			if current_frame == data["frame"]:
				load_hitbox_data(data)

func load_previous_active_frames():
	if StaticData.P1_move_data.has("frames"):
		for prev_frame in range(1, current_frame):
			for data in StaticData.P1_move_data["frames"]:
				if prev_frame == data["frame"]:
					load_prev_hitbox_data(prev_frame, data)

func load_prev_hitbox_data(prev_frame: int, data):
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	while data.has(hitbox_input):
		if(prev_frame + data[hitbox_input]["end_frame"] -  1 >= current_frame):
			create_hitbox(data[hitbox_input], hitbox_input)
			hitbox_index += 1
			hitbox_input = hitbox_string + str(hitbox_index)
		else:
			break

func load_hitbox_data(data):
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	while data.has(hitbox_input):
		create_hitbox(data[hitbox_input], hitbox_input)
		hitbox_index += 1
		hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox(data, name : String):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.damage = data["damage"]
	new_hitbox.end_frame = data["end_frame"]
	new_hitbox.pos_y = data["pos_y"]
	new_hitbox.pos_x = data["pos_x"]
	new_hitbox.scale_x = data["scale_x"]
	new_hitbox.scale_y = data["scale_y"]
	new_hitbox.leftside = true
	new_hitbox.player = "player1"
	new_hitbox.label.text = name
	current_boxes.append(new_hitbox)
	add_child(new_hitbox)

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			load_character_data()
		1:
			load_character_data()
		2:
			load_character_data()

func _on_animation_option_button_item_selected(_index: int) -> void:
	load_animation()

func _on_right_button_pressed() -> void:
	line_edit.text = str(int(line_edit.text) + 1)
	_on_line_edit_text_changed(str(int(line_edit.text)))

func _on_left_button_pressed() -> void:
	line_edit.text = str(int(line_edit.text) - 1)
	_on_line_edit_text_changed(str(int(line_edit.text)))

func _on_line_edit_text_changed(new_text: String) -> void:
	if int(new_text) is int and int(new_text) > 0:
		load_anim_frame(int(new_text))
