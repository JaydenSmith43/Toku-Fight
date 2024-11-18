extends State
class_name S_CommandThrown

var end_frame

var I_light : String
var I_medium : String

var other_player : SGCharacterBody2D

var jump_velocity = 46811
var jump_gravity = 1000
var fall_gravity = 674

func Enter():
	character.being_thrown = true
	anim_player.play("buster_taker")
	character.current_frame = 0
	character.throw_state_frame = 0
	character.teching = false
	character.velocity.x = 0
	
	if character.left_side:
		model.rotate_y(deg_to_rad(90))
	else:
		model.rotate_y(deg_to_rad(-90))

func Exit():
	character.being_thrown = false
	character.teching = false

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == 60:
		character.velocity.y = -46811
		
	if character.current_frame >= 60:
		character.velocity.y += get_gravity()
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.current_frame == 170: #TODO SEND THEM TO KNOCKDOWN STATE FOR CERTAIN AMOUNT OF FRAMES
		character.take_damage(18)
	if character.current_frame == 280:
		if character.left_side:
			model.rotate_y(deg_to_rad(-90))
		else:
			model.rotate_y(deg_to_rad(90))
		Transitioned.emit(self, "idle")

func get_gravity() -> float:
	return jump_gravity if character.velocity.y < 0.0 else fall_gravity
