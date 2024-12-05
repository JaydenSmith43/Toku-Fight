extends Node2D

var credits_fade : bool = false

@onready var anim_player : AnimationPlayer = $AnimationPlayer

@onready var select_sound : AudioStreamPlayer = $SelectSound
@onready var focus_sound : AudioStreamPlayer = $FocusSound

func load_versus():
	get_tree().change_scene_to_file("res://Scenes/Main/vs_mode.tscn")

func _on_versus_button_button_down() -> void:
	anim_player.play("fade_out")
	select_sound.play()

func _on_credits_button_down() -> void:
	if anim_player.is_playing():
		return
	
	if !credits_fade:
		anim_player.play("credits_fade_in")
		credits_fade = true
	elif credits_fade:
		anim_player.play("credits_fade_out")
		credits_fade = false

func _on_versus_button_focus_exited() -> void:
	if focus_sound != null:
		focus_sound.play()

func _on_credits_focus_exited() -> void:
	if focus_sound != null:
		focus_sound.play()
