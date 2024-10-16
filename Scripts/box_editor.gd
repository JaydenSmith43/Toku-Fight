extends Node3D

@export var animation_option_button : OptionButton
@export var character_option_button : OptionButton
@export var hitbox_option_button : OptionButton
@export var current_frame_edit : LineEdit
@export var end_frame_edit : LineEdit
@export var total_frame_label : Label

@export var var_frame_edit : LineEdit
@export var var_blockstun_edit: LineEdit
@export var var_hitstun_edit : LineEdit
@export var var_damage_edit : LineEdit
@export var var_position_x_edit : LineEdit
@export var var_position_y_edit : LineEdit
@export var var_scale_x_edit : LineEdit
@export var var_scale_y_edit : LineEdit
@export var var_end_frame_edit : LineEdit

var grappler_model = preload("res://Scenes/Characters/grappler/grappler_model.tscn")
var hitbox = preload("res://Scenes/Characters/hitbox3d_editor.tscn")

var current_model
var current_anim_player : AnimationPlayer
var current_frame = 1
var animations = [] ###
var current_boxes = []
var move_data = {}

func _ready() -> void:
	load_character_data(0)

func load_character_data(index : int):
	if current_model:
		current_model.queue_free()
	
	animation_option_button.clear()
	
	match index:
		0:
			current_model = grappler_model.instantiate()
		1:
			current_model = grappler_model.instantiate()
		2:
			current_model = grappler_model.instantiate()
	add_child(current_model)
	
	current_anim_player = current_model.get_node("AnimationPlayer")
	
	var animsss = current_anim_player.get_animation_list()
	for anim_name in animsss:
		animation_option_button.add_item(anim_name)
	load_animation()

func load_animation():
	current_anim_player.play(animation_option_button.get_item_text(animation_option_button.get_selected_id()))
	_on_current_frame_edit_text_changed(str(int(current_frame_edit.text)))
	total_frame_label.text = "Total Anim Frames: " + str(int(current_anim_player.current_animation_length * 60))
	check_for_file()
	
	end_frame_edit.text = str(move_data["move_end_frame"])
	load_box_items()
	load_box_variables(0)

func load_box_items():
	hitbox_option_button.clear()
	
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	for data in move_data["frames"]:
		var frame = data["frame"]
		
		while data.has(hitbox_input):
			hitbox_option_button.add_item(str(frame) + ": " + hitbox_input)
			hitbox_index += 1
			hitbox_input = hitbox_string + str(hitbox_index)
		hitbox_index = 1
		hitbox_input = hitbox_string + str(hitbox_index)

func load_box_variables(index : int):
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	for data in move_data["frames"]:
		if data["frame"] == float(hitbox_string[0]):
			var_frame_edit.text = str(data["frame"])
			if data.has("blockstun"):
				var_blockstun_edit.text = str(data["blockstun"])
			if data.has("hitstun"):
				var_hitstun_edit.text = str(data["hitstun"])
			if data.has(str(hitbox_string[1])):
				load_hitbox_variables(data[hitbox_string[1]])

func load_hitbox_variables(data):
	var_damage_edit.text = str(data["damage"])
	var_position_x_edit.text = str(data["pos_x"])
	var_position_y_edit.text = str(data["pos_y"])
	var_scale_x_edit.text = str(data["scale_x"])
	var_scale_y_edit.text = str(data["scale_y"])
	var_end_frame_edit.text = str(data["end_frame"])

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
	load_array_data()
	load_frame_data()

func load_frame_data():
	for box in current_boxes:
		if box == null:
			pass
		else:
			box.queue_free()
	
	load_previous_active_frames()
	
	if move_data.has("frames"):
		for data in move_data["frames"]:
			if current_frame == data["frame"]:
				load_hitbox_data(data)

func load_array_data():
	move_data.clear()
	move_data = StaticData.P1_move_data

func load_previous_active_frames():
	if move_data.has("frames"):
		for prev_frame in range(1, current_frame):
			for data in move_data["frames"]:
				if prev_frame == data["frame"]:
					load_prev_hitbox_data(prev_frame, data)

func load_prev_hitbox_data(prev_frame: int, data):
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	while data.has(hitbox_input):
		if(prev_frame + data[hitbox_input]["end_frame"] -  1 >= current_frame):
			create_hitbox_from_data(data[hitbox_input], hitbox_input)
			
		hitbox_index += 1
		hitbox_input = hitbox_string + str(hitbox_index)

func load_hitbox_data(data):
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	while data.has(hitbox_input):
		create_hitbox_from_data(data[hitbox_input], hitbox_input)
		hitbox_index += 1
		hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox_from_data(data, name : String):
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

func create_new_hitbox(name : String):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.damage = 1
	new_hitbox.end_frame = 1
	new_hitbox.pos_y = 0
	new_hitbox.pos_x = 0
	new_hitbox.scale_x = 1
	new_hitbox.scale_y = 1
	new_hitbox.leftside = true
	new_hitbox.player = "player1"
	new_hitbox.label.text = name
	current_boxes.append(new_hitbox)
	add_child(new_hitbox)
	
	var same_frame = false
	var new_data = {
		frame = current_frame,
		blockstun = 1,
		hitstun = 1
	}
	
	new_data[name] = {
		damage = 1,
		pos_x = 0,
		pos_y = 0,
		scale_x = 1,
		scale_y = 1,
		end_frame = 1
	}
	
	for data in move_data["frames"]:
		if data["frame"] == current_frame:
			data[name] = new_data[name]
			same_frame = true
	
	if same_frame == false:
		move_data["frames"].append(new_data)
	
	load_box_items()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			load_character_data(0)
		1:
			load_character_data(1)
		2:
			load_character_data(2)

func _on_animation_option_button_item_selected(_index: int) -> void:
	load_animation()

func _on_hitbox_option_button_item_selected(index: int) -> void:
	load_box_variables(index)

func _on_right_button_pressed() -> void:
	current_frame_edit.text = str(int(current_frame_edit.text) + 1)
	_on_current_frame_edit_text_changed(str(int(current_frame_edit.text)))

func _on_left_button_pressed() -> void:
	current_frame_edit.text = str(int(current_frame_edit.text) - 1)
	_on_current_frame_edit_text_changed(str(int(current_frame_edit.text)))

func _on_end_frame_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		move_data["move_end_frame"] = int(new_text)

func _on_current_frame_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float() and int(new_text) > 0:
		load_anim_frame(int(new_text))

func _on_hitbox_button_button_down() -> void:
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	for data in move_data["frames"]:
		if data["frame"] == current_frame:
			while data.has(hitbox_input):
				hitbox_index += 1
				hitbox_input = hitbox_string + str(hitbox_index)
	create_new_hitbox(hitbox_input)
	pass

#region variables
func _on_var_frame_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data["frame"] = float(new_text)
				hitbox_option_button.set_item_text(index, new_text + ": " + hitbox_string[1])
				load_frame_data()

func _on_var_blockstun_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data["blockstun"] = float(new_text)
				load_frame_data()

func _on_var_hitstun_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data["hitstun"] = float(new_text)
				load_frame_data()

func _on_var_damage_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["damage"] = float(new_text)
				load_frame_data()

func _on_var_position_x_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["pos_x"] = float(new_text)
				load_frame_data()

func _on_var_position_y_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["pos_y"] = float(new_text)
				load_frame_data()

func _on_var_scale_x_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["scale_x"] = float(new_text)
				load_frame_data()

func _on_var_scale_y_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["scale_y"] = float(new_text)
				load_frame_data()

func _on_var_end_frame_edit_text_submitted(new_text: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]]["end_frame"] = float(new_text)
				load_frame_data()
#endregion


func _on_save_button_button_down() -> void:
	var name = character_option_button.get_item_text(character_option_button.get_selected_id())
	var move = animation_option_button.get_item_text(animation_option_button.get_selected_id())
	var path = "res://Scripts/MoveData/" + name + "_" + move + ".json"
	
	var json_string = JSON.stringify(move_data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	#if FileAccess.file_exists(path):
		#DirAccess.remove_absolute(path)
	file.store_string(json_string)
