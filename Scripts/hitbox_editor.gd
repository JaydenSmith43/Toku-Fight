extends Node3D

@export var animation_option_button : OptionButton
@export var line_edit : LineEdit
@export var total_frame_label : Label
var grappler_model = preload("res://Scenes/Characters/grappler/grappler_model.tscn")

var current_model
var current_anim_player : AnimationPlayer
var animations = []
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

func load_anim_frame(frame : float):
	current_anim_player.play()
	current_anim_player.seek(frame/60, true)
	current_anim_player.speed_scale = 0

func create_hitbox(type: int):
	match type:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			load_character_data()
		1:
			load_character_data()
		2:
			load_character_data()

func _on_animation_option_button_item_selected(index: int) -> void:
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
