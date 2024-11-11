extends State
class_name S_Prejump

func Enter():
	character.current_frame = 0
	character.low_blocking = false
	character.high_blocking = false
	character.jump = true
	anim_player.play("jump")

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1

	if character.current_frame == 3:
		character.current_frame = 0
		Transitioned.emit(self, "jump")
