extends State
class_name S_Hitstun

var hitstun_frames := 0

func Enter():
	character.current_frame = 0
	hitstun_frames = character.hitstun
	character.velocity.x = 0
	character.velocity.y = 0
	
	if anim_player.is_playing():
		anim_player.stop()
	
	if character.crouch:
		anim_player.play("hit_crouch")
	elif character.height_hit == "high":
		anim_player.play("hit_high")
	elif character.height_hit == "mid":
		anim_player.play("hit_mid")
	elif character.height_hit == "low":
		anim_player.play("hit_low")
	
	if character.left_side:
		character.velocity.x = -10660 #stun_velocity
	else:
		character.velocity.x = 10660

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	#print("HITSTUN UPDATE")
	character.current_frame += 1
	
	character.velocity.x = lerp(character.velocity.x, 0, 0.1)
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.current_frame == hitstun_frames:
		character.hitstun = 0
		Transitioned.emit(self, "idle")
