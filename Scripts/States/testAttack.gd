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

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if (!played): #TODO TODO TODO TODO TODO TODO
		#sprite.play("jab")
		
		#new_hitbox.damage
		#new_hitbox.end_frame
		#new_hitbox.size_x
		#new_hitbox.size_y
		
		var new_hitbox = hitbox.instantiate()
		new_hitbox.end_frame = 6
		get_parent().get_parent().add_child(new_hitbox)
		
		played = true ###
	
	if current_frame >= test_end_frame:
		Transitioned.emit(self, "idle")
		#var data_to_send = ["a", "b", "c"]
		#var json_string = JSON.stringify(data_to_send)
