extends State
class_name S_Prejump

var current_frame = 0
var played : bool = false
@export var jump_force : float = 40.0

func Enter():
	current_frame = 0
	played = false
	anim_player.play("Jump")

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == 3:
		character.velocity.y = +jump_force
		if character.velocity.x > 0:
			character.velocity.x = 10
		elif character.velocity.x < 0:
			character.velocity.x = -10
		Transitioned.emit(self, "jump")
