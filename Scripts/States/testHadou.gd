extends State
class_name testHadou

var played : bool = false

func Enter():
	played = false
	attack_timer.wait_time = 0.8
	attack_timer.start()

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	if (!played):
		#sprite.play("fireball")
		#TODO
		played = true
	print(attack_timer.time_left)
	if attack_timer.time_left <= 0:
		Transitioned.emit(self, "idle")
