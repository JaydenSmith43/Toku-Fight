extends State
class_name S_Attack

var played : bool = false
var current_frame = 0
var move_end_frame = 10
var hitbox = preload("res://Scenes/Characters/hitbox3d.tscn")
var anim_name := "5a"
#var new_hitbox := Hitbox3D.new()

#@export var animation_player : AnimationPlayer
#TODO SEND IN JSON DATA INTO THIS ATTACK STATE TO BE READ

func Enter():
	current_frame = 0
	anim_player.play(anim_name)
	#played = false

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if (!played):
		
		#if current_frame == start_frame:
		
		#var new_hitbox = hitbox.instantiate()
		#new_hitbox.start_frame = 10
		#new_hitbox.end_frame = 13
		#new_hitbox.pos_y = 5
		#new_hitbox.pos_x = 2
		#new_hitbox.leftside = character.leftside
		
		#if character.is_in_group("player1"):
			#new_hitbox.player = "player1"
		#else:
			#new_hitbox.player = "player2"
		
		#get_parent().get_parent().add_child(new_hitbox)
		
		played = true ###
	
	if current_frame >= move_end_frame:
		Transitioned.emit(self, "idle")
