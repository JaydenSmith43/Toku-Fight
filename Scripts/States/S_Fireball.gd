extends State
class_name S_Fireball

func Enter():
	anim_player.play("Idle")
	#attack_timer.wait_time = 0.8
	#attack_timer.start()
	character.current_frame = 0

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	if character.current_frame >= 48:
		Transitioned.emit(self, "idle")
