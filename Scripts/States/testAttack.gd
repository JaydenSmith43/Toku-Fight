extends State
class_name testAttack

var played : bool = false
var current_frame = 0
var test_end_frame = 16
var hitbox = preload("res://Scenes/Characters/hitbox3d.tscn")
#var new_hitbox := Hitbox3D.new()

#@export var animation_player : AnimationPlayer
#TODO SEND IN JSON DATA INTO THIS ATTACK STATE TO BE READ

func Enter():
	current_frame = 0
	played = false

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if (!played):
		#sprite.play("jab")
		
		var new_hitbox = hitbox.instantiate()
		new_hitbox.end_frame = 5
		new_hitbox.pos_y = 5
		new_hitbox.pos_x = 2
		new_hitbox.leftside = character.leftside
		
		if character.is_in_group("player1"):
			new_hitbox.player = "player1"
		else:
			new_hitbox.player = "player2"
		
		get_parent().get_parent().add_child(new_hitbox)
		
		played = true ###
	
	if current_frame >= test_end_frame:
		Transitioned.emit(self, "idle")
		#var data_to_send = ["a", "b", "c"]
		#var json_string = JSON.stringify(data_to_send)
