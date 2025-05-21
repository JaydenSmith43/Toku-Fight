extends State
class_name S_Back_Dash

var blockstun_frames := 0
var I_left : String
var I_right : String
var I_down : String

var otherPlayer : SGCharacterBody2D

func Enter():
	character.current_frame = 0
	blockstun_frames = character.blockstun
	character.velocity.x = 0
	
	if anim_player.is_playing():
		anim_player.stop()
	
	if !character.crouch:
		anim_player.play("stand_block")
	else:
		anim_player.play("crouch_block")
	
	if (get_parent().get_parent().is_in_group("player1")):
		I_left = "P1_Left"
		I_right = "P1_Right"
		I_down = "P1_Down"
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		I_down = "P2_Down"
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]
	
	if character.left_side:
		character.velocity.x = -10660 #stun_velocity
	else:
		character.velocity.x = 10660

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	character.velocity.x = lerp(character.velocity.x, 0, 0.1)
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	#region Input
	if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_down) and character.left_side == true:
		character.low_blocking = true
	elif Input.is_action_pressed(I_right) and Input.is_action_pressed(I_down) and character.left_side == false:
		character.low_blocking = true
	elif Input.is_action_pressed(I_left) and character.left_side == true:
		character.high_blocking = true
	elif Input.is_action_pressed(I_right) and character.left_side == false:
		character.high_blocking = true
	else:
		character.low_blocking = false
		character.high_blocking = false
	
	if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_right):
		character.low_blocking = false
		character.high_blocking = false
	
	if character.current_frame == blockstun_frames:
		character.blockstun = 0
		Transitioned.emit(self, "idle")
