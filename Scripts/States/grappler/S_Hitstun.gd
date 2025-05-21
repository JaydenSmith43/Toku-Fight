extends State
class_name S_Hitstun

#var hitstun_frames := 0

var otherPlayer : SGCharacterBody2D

func Enter():
	character.throw_invul = true
	if character.is_in_group("player1"):
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
		otherPlayer.combo += 1
		otherPlayer.game_manager.increase_combo_counter(false)
	else:
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]
		otherPlayer.combo += 1
		otherPlayer.game_manager.increase_combo_counter(true)
	
	
	character.current_frame = 0
	#hitstun_frames = character.hitstun
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
		character.velocity.x = -8000 #stun_velocity #-10660
	else:
		character.velocity.x = 8000

func Exit():
	character.throw_invul = false

func State_Physics_Update(input: Dictionary):
	var otherplayer_state = otherPlayer.state_machine.current_state.state_name
	if otherplayer_state == "thrown":
		otherPlayer.state_machine.current_state.Transitioned.emit(otherPlayer.state_machine.current_state, "idle")

	character.current_frame += 1
	character.velocity.x = lerp(character.velocity.x, 0, 0.1)
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.current_frame == character.hitstun:
		character.hitstun = 0
		otherPlayer.combo = 0
		if otherPlayer.is_in_group("player1"):
			otherPlayer.game_manager.combo_end(true)
		else:
			otherPlayer.game_manager.combo_end(false)
		Transitioned.emit(self, "idle")
