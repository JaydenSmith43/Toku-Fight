extends State
class_name S_Hitstun

var hitstun_frames := 0

func Enter():
	character.current_frame = 0
	hitstun_frames = character.hitstun
	
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

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	print("HITSTUN UPDATE")
	character.current_frame += 1
	
	if character.current_frame == hitstun_frames:
		character.hitstun = 0
		Transitioned.emit(self, "idle")
