extends State
class_name S_Hitstun

var current_frame := 0
var blockstun_frames := 10

func Enter():
	current_frame = 0
	#if !character.crouch:
	#	anim_player.play("StandBlock")
	#else:
	#	anim_player.play("CrouchBlock")

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == blockstun_frames:
		Transitioned.emit(self, "idle")
