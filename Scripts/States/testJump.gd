extends State
class_name testJump

@export var move_speed : float = 450.0
@export var gravity : float = 1800.0

@export var collision : CollisionShape2D
@export var jumpCol : RectangleShape2D

func Enter():
	#collision.shape = jumpCol
	#collision.position.y = -120
	print()

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	if !character.is_on_floor():
		character.velocity.y += gravity * _delta
		#character.position.y = lerp()
	else:
		Transitioned.emit(self, "idle")
	character.move_and_slide()
