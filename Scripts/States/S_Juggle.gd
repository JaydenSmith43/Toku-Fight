extends State
class_name S_Juggle

var x_velocity : int
var y_initial_velocity : int = 13653
var y_gravity : int = 568

func Enter():
	#anim_player.play("buster_thrown_pose")
	character.throw_invul = true
	
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	if anim_player.current_animation == "buster_taker":
		model.position.y = -SGFixed.to_float(character.fixed_position_y) - 4
	else:
		model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.left_side:
		x_velocity = -13000
	else:
		x_velocity = 13000
	character.velocity.x = x_velocity
	character.velocity.y = -y_initial_velocity
	character.set_collision_mask_bit(15, false)

func Exit():
	character.hittable = true
	character.set_collision_mask_bit(15, true)
	character.throw_invul = false

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	character.velocity.y += y_gravity
	character.velocity.x = x_velocity
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	
	if anim_player.current_animation == "buster_taker":
		model.position.y = -SGFixed.to_float(character.fixed_position_y) - 4
	else:
		model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.is_on_floor():
		if character.left_side and model.global_rotation_degrees.y == -180 and anim_player.current_animation == "buster_taker":
			model.rotate_y(deg_to_rad(-90))
		elif model.global_rotation_degrees.y <= 180 and anim_player.current_animation == "buster_taker":
			model.rotate_y(deg_to_rad(90))
	
		Transitioned.emit(self, "knockdown")
		return
