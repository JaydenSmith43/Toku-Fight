extends State
class_name S_Prejump

func Enter():
	if character.entered:
		return
	character.entered = true
	character.current_frame = 0
	character.low_blocking = false
	character.high_blocking = false
	character.jump = true
	#print("enter prejump")
	anim_player.play("jump")

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	#print("PREJUMP UPDATE: " + str(character.current_frame))
	
	if character.current_frame == 3:
		character.entered = false
		character.current_frame = 0
		Transitioned.emit(self, "jump")
