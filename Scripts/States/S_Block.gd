extends State
class_name S_Block

var current_frame := 0
var blockstun_frames := 10
var I_left : String
var I_right : String

var otherPlayer : CharacterBody3D

func Enter():
	current_frame = 0
	if !character.crouch:
		anim_player.play("StandBlock")
	else:
		anim_player.play("CrouchBlock")
	
	if (get_parent().get_parent().is_in_group("player1")):
		I_left = "P1_Left"
		I_right = "P1_Right"
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	#region Input
	if Input.is_action_pressed(I_left) and character.leftside == true:
		character.blocking = true
	elif Input.is_action_pressed(I_right) and character.leftside == false:
		character.blocking = true
	else:
		character.blocking = false
	
	
	if current_frame == blockstun_frames:
		Transitioned.emit(self, "idle")
