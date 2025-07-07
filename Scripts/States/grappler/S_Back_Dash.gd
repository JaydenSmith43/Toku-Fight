extends State
class_name S_Back_Dash

@export var dash_frames := 0
@export var dash_velocity = 0
var current_velocity = 0
#var I_left : String
#var I_right : String
#var I_down : String

var otherPlayer : SGCharacterBody2D

func Enter():
	character.current_frame = 0
	character.velocity.x = 0
	
	if anim_player.is_playing():
		anim_player.stop()
	
	anim_player.play("forward_dash")
	
	if character.left_side:
		current_velocity = dash_velocity #back_dash
	else:
		current_velocity = -dash_velocity
	

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	character.velocity.x = current_velocity
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.current_frame == dash_frames:
		character.blockstun = 0
		Transitioned.emit(self, "idle")
