extends State
class_name testJump

@export var gravity : float = 150.0

@export var collision : CollisionShape2D
@export var jumpCol : RectangleShape2D

func Enter():
	#collision.shape = jumpCol
	#collision.position.y = -120
	pass

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float): #ADD a check for facing left without changing model
	if !character.is_on_floor():
		character.velocity.y -= gravity * _delta
		#character.position.y = lerp()
	else:
		Transitioned.emit(self, "idle")
	

	character.move_and_slide()
