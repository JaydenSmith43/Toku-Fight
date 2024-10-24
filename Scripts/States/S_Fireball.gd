extends State
class_name S_Fireball

var played : bool = false

func Enter():
	played = false
	attack_timer.wait_time = 0.8
	attack_timer.start()

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(input: Dictionary):
	if (!played):
		#sprite.play("fireball")
		#TODO
		played = true
	if attack_timer.time_left <= 0:
		Transitioned.emit(self, "idle")
