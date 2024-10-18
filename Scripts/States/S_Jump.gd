extends State
class_name S_Jump

@export var gravity : float = 120
var current_frame := 0

func Enter():
	current_frame = 0
	character.collision.position.y += 1
	pass

func Exit():
	pass

func State_Physics_Update(delta: float): #ADD a check for facing left without changing model
	current_frame += 1
	print(current_frame)
	
	if !character.is_on_floor():
		character.velocity.y -= gravity * 1/60
		character.velocity.x = character.jump_velocity
		pass
	elif character.is_on_floor() and current_frame > 20:
		character.jump = false
		character.jump_velocity = 0
		character.collision.position.y -= 1
		Transitioned.emit(self, "idle")
		pass
	
	character.move_and_slide()
	
