extends Node3D

@export var animation_option_button : OptionButton
@export var character_option_button : OptionButton
@export var hitbox_option_button : OptionButton
@export var current_frame_edit : LineEdit
@export var end_frame_edit : LineEdit
@export var total_frame_label : Label
@export var log_label : Label
@export var var_line_edits : Array[LineEdit]

var var_edits_dict : Dictionary[String, LineEdit] = {}

var grappler_model = preload("res://Scenes/Characters/grappler/grappler_model.tscn")
var hitbox = preload("res://Scenes/Characters/editor_hitbox3d.tscn")
var box_check_order = ["sfx"]
var load_check_order = ["damage","pos_x","pos_y","scale_x","scale_y","end_frame","height", "blockstun","hitstun","hitstop","pushback","pushtime"]

var current_model
var current_anim_player : AnimationPlayer
var current_frame = 1
var animations = [] ###
var current_boxes = []
var move_data = {}

var saved_frame = true
var saved_end_frame = true
var saved_pos_x = true
var saved_pos_y = true
var saved_scale_x = true
var saved_scale_y = true
var saved_damage = true
var hitstop = true
var blockstun = true
var hitstun = true

func _ready() -> void:
	set_var_edit_dict()
	load_character_data(0)

func set_var_edit_dict():
	for x in var_line_edits.size():
		var_edits_dict[var_line_edits[x].key] = var_line_edits[x]

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
	
	var anims = current_anim_player.get_animation_list()
	for anim_name in anims:
		animation_option_button.add_item(anim_name)
	load_animation()

func load_animation():
	log_label.text = ""
	log_label.self_modulate.a = 0
	current_anim_player.play(animation_option_button.get_item_text(animation_option_button.get_selected_id()))
	_on_current_frame_edit_text_changed(str(int(current_frame_edit.text)))
	total_frame_label.text = "Total Anim Frames: " + str(int(current_anim_player.current_animation_length * 60))
	check_for_file()
	
	if move_data.has("move_end_frame"):
		end_frame_edit.text = str(move_data["move_end_frame"])
	
	if move_data.has("cancel"):
		var_edits_dict["cancel"].text = str(move_data["cancel"])
	else:
		var_edits_dict["cancel"].text = ""
	
	if move_data.has("cancel_frame"):
		var_edits_dict["cancel_frame"].text = str(move_data["cancel_frame"])
	else:
		var_edits_dict["cancel_frame"].text = ""
	
	load_box_items()
	load_box_variables(0)

func load_box_items():
	hitbox_option_button.clear()
	
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	if move_data.has("frames"):
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
	if hitbox_string.size() > 0:
		hitbox_string[1] = hitbox_string[1].strip_edges()
	if move_data.has("frames"):
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				var_edits_dict["frame"].text = str(data["frame"])
				
				for check in box_check_order:
					if data.has(check):
						var_edits_dict[check].text = str(data[check])
					else:
						var_edits_dict[check].text = ""
				if data.has(str(hitbox_string[1])):
					load_hitbox_variables(data[hitbox_string[1]])

func load_hitbox_variables(data):
	for check in load_check_order:
		var_edits_dict[check].text = str(data[check])

func load_anim_frame(frame : float):
	current_frame = frame
	current_anim_player.play()
	current_anim_player.seek(frame/60, true)
	current_anim_player.speed_scale = 0
	load_frame_data()

func check_for_file():
	var charactername = character_option_button.get_item_text(character_option_button.get_selected_id())
	var movename = animation_option_button.get_item_text(animation_option_button.get_selected_id())
	
	StaticData.load_json_file(charactername, charactername + "_" + movename, "player1")
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
				load_hitbox_to_display(data)
		if move_data["frames"].size() == 0:
			no_data()

func no_data():
	for edit in var_line_edits:
		edit.text = ""
	
	hitbox_option_button.remove_item(0)

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

func load_hitbox_to_display(data):
	var hitbox_string = "hitbox"
	var hitbox_index = 1
	var hitbox_input = hitbox_string + str(hitbox_index)
	
	while data.has(hitbox_input):
		create_hitbox_from_data(data[hitbox_input], hitbox_input)
		hitbox_index += 1
		hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox_from_data(data, move_name : String):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.pos_y = data["pos_y"]
	new_hitbox.pos_x = data["pos_x"]
	new_hitbox.scale_x = data["scale_x"]
	new_hitbox.scale_y = data["scale_y"]
	new_hitbox.leftside = true
	new_hitbox.player = "player1"
	new_hitbox.label.text = move_name
	current_boxes.append(new_hitbox)
	add_child(new_hitbox)

func create_new_hitbox(move_name : String):
	var same_frame = false
	var new_data = {
		frame = current_frame,
		blockstun = 1,
		hitstun = 1
	}
	
	new_data[move_name] = {
		damage = 1,
		pos_x = 0,
		pos_y = 0,
		scale_x = 1,
		scale_y = 1,
		end_frame = 1,
		height = "mid",
		sfx = "light",
	}
	
	for data in move_data["frames"]:
		if data["frame"] == current_frame:
			data[name] = new_data[name]
			same_frame = true
	
	if same_frame == false:
		move_data["frames"].append(new_data)
	
	load_box_items()
	load_frame_data()

func _on_option_button_item_selected(index: int) -> void:
	load_character_data(index)

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
	
	if !move_data.has("frames"):
		move_data["frames"] = []
	for data in move_data["frames"]:
		if data["frame"] == current_frame:
			while data.has(hitbox_input):
				hitbox_index += 1
				hitbox_input = hitbox_string + str(hitbox_index)
	create_new_hitbox(hitbox_input)

func _on_hurtbox_button_button_down() -> void:
	pass # Replace with function body.

func _on_save_button_button_down() -> void:
	check_empty_vars()
	
	var character_name = character_option_button.get_item_text(character_option_button.get_selected_id())
	var move = animation_option_button.get_item_text(animation_option_button.get_selected_id())
	var path = "res://MoveData/" + character_name + "/" + character_name + "_" + move + ".json"
	var json_string = JSON.stringify(move_data, "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json_string)
	if log_label.new_text == false:
		log_label.text = "Log: saved!"
		log_label.self_modulate.a = 2
	
	load_box_items()
	load_box_variables(0)
	log_label.new_text = false

func check_empty_vars():
	var filled_empty_vars = false
	
	for edit in var_line_edits:
		if edit.text == "":
			filled_empty_vars = true
			_on_var_edit("", edit.key)
	if filled_empty_vars:
		log_label.text = "Log: placeholder data inserted into empty vars!"
		log_label.self_modulate.a = 2
		log_label.new_text = true
		#play anim
		return

func _on_delete_button_button_down() -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	for data in move_data["frames"]:
		if data["frame"] == float(hitbox_string[0]):
			move_data["frames"].erase(data)
			#data.erase(hitbox_string[1])
			load_frame_data()

#region variables
var check_edit = {
	"frame":"frame",
	"blockstun":"float","hitstun":"float","hitstop":"float","pushback":"float","pushtime":"float",
	"sfx":"string",
	"damage":"hitbox_float","pos_x":"hitbox_float","pos_y":"hitbox_float","scale_x":"hitbox_float",
	"scale_y":"hitbox_float","end_frame":"hitbox_float",
	"height":"hitbox_string",
	"cancel":"cancel",
	"cancel_frame":"cancel_frame"
}

func _on_var_edit(new_text: String, key: String) -> void:
	var index = hitbox_option_button.get_selected_id()
	var hitbox_string = hitbox_option_button.get_item_text(index).split(":", false, 1)
	hitbox_string[1] = hitbox_string[1].strip_edges()
	
	match check_edit[key]:
		"frame":
			var_edit_frame(new_text, hitbox_string, index)
		"float":
			var_edit_float(new_text, key, hitbox_string)
		"string":
			var_edit_string(new_text, key, hitbox_string)
		"hitbox_float":
			var_edit_hitbox_float(new_text, key, hitbox_string)
		"hitbox_string":
			var_edit_hitbox_string(new_text, key, hitbox_string)
		"cancel":
			var_cancel_edit(new_text)
		"cancel_frame":
			var_cancel_frame_edit(new_text)

func var_edit_frame(new_text: String, hitbox_string: PackedStringArray, index: int) -> void:
	if new_text == "":
		new_text = "1"
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data["frame"] = float(new_text)
				hitbox_option_button.set_item_text(index, new_text + ": " + hitbox_string[1])
				load_frame_data()

func var_edit_float(new_text: String, key: String, hitbox_string: PackedStringArray) -> void:
	if new_text == "":
		new_text = "1"
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[key] = float(new_text)
				load_frame_data()

func var_edit_string(new_text: String, key: String, hitbox_string: PackedStringArray) -> void:
	if new_text == "":
		new_text = "placeholder"
	for data in move_data["frames"]:
		if data["frame"] == float(hitbox_string[0]):
			data[key] = new_text
			load_frame_data()

func var_edit_hitbox_float(new_text: String, key: String, hitbox_string: PackedStringArray) -> void:
	if new_text == "":
		new_text = "1"
	if new_text.is_valid_float():
		for data in move_data["frames"]:
			if data["frame"] == float(hitbox_string[0]):
				data[hitbox_string[1]][key] = float(new_text)
				load_frame_data()

func var_edit_hitbox_string(new_text: String, key: String, hitbox_string: PackedStringArray) -> void:
	if new_text == "":
		new_text = "placeholder"
	for data in move_data["frames"]:
		if data["frame"] == float(hitbox_string[0]):
			data[hitbox_string[1]][key] = new_text
			load_frame_data()

func var_cancel_edit(new_text: String) -> void:
	if new_text == "":
		new_text = "placeholder"
	move_data["cancel"] = new_text
	load_frame_data()

func var_cancel_frame_edit(new_text: String) -> void:
	if new_text == "":
		new_text = "1"
	if new_text.is_valid_float():
		move_data["cancel_frame"] = float(new_text)
		load_frame_data()

#endregion
