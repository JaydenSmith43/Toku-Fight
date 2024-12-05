extends Node2D

#confirm sound const preload var
@onready var anim_player : AnimationPlayer = $AnimationPlayer

@onready var select_sound : AudioStreamPlayer = $SelectSound

func _unhandled_input(event: InputEvent) -> void:
	if anim_player.is_playing():
		return
	if event.is_pressed():
		select_sound.play()
		anim_player.play("new_animation")

#func _physics_process(delta: float) -> void:
#	pass

func load_next_scene():
	get_tree().change_scene_to_file("res://Scenes/Main/main_menu.tscn")
