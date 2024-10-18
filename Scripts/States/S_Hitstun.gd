extends State
class_name S_Hitstun

var current_frame := 0
var hitstun_frames := 0

func Enter():
	current_frame = 0
	hitstun_frames = character.hitstun
	
	if anim_player.is_playing():
		anim_player.stop()
	
	if character.crouch:
		anim_player.play("HitCrouch")
	elif character.height_hit == "high":
		anim_player.play("HitHigh")
	elif character.height_hit == "mid":
		anim_player.play("HitMid")
	elif character.height_hit == "low":
		anim_player.play("HitLow")

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == hitstun_frames:
		character.hitstun = 0
		Transitioned.emit(self, "idle")
