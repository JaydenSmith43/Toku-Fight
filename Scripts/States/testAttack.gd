extends State
class_name testAttack

var played : bool = false
var current_frame = 0
@export var animation : AnimationPlayer

func Enter():
	current_frame = 0
	played = false
	#attack_timer.wait_time = 0.15
	#attack_timer.start()

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	
	
	current_frame += 1
	var new_hitbox := Hitbox
	#new_hitbox.damage
	#new_hitbox.end_frame
	#new_hitbox.size_x
	#new_hitbox.size_y
	#new_hitbox.end_frame
	
	if (!played):
		sprite.play("jab")
		animation.stop()
		animation.play("test_jab")
		played = true
	
	if attack_timer.time_left <= 0:
		Transitioned.emit(self, "idle")
		var data_to_send = ["a", "b", "c"]
		var json_string = JSON.stringify(data_to_send)
