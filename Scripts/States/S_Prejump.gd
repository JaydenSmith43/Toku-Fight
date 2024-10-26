extends State
class_name S_Prejump

var current_frame = 0
var played : bool = false
@export var jump_force : float = 40.0

func Enter():
	current_frame = 0
	played = false
	character.low_blocking = false
	character.high_blocking = false
	character.jump = true
	#anim_player.play("jump")

func State_Physics_Update(input: Dictionary):
	current_frame += 1
	print(current_frame)
	
	if current_frame == 3:
		Transitioned.emit(self, "jump")
