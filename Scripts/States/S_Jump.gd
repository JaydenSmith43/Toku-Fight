extends State
class_name S_Jump

@export var gravity : float = 120
var current_frame := 0

func Enter():
	current_frame = 0
	#anim_player.play("Jump")
	pass

func Exit():
	pass

func State_Physics_Update(_delta: float): #ADD a check for facing left without changing model
	current_frame += 1
	print(current_frame)
	
	if !character.is_on_floor():
		character.velocity.y -= gravity * _delta
		pass
	elif character.is_on_floor() and current_frame > 20:
		Transitioned.emit(self, "idle")
		pass
	
	character.move_and_slide()
	
