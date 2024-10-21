extends State
class_name S_Teched

var current_frame = 0
var animation_end = 27
var current_position : Vector3

func _ready() -> void:
	pass # Replace with function body.

func Enter():
	anim_player.play("throw_teched")
	current_frame = 0
	current_position = character.position

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == animation_end:
		character.movename = "idle"
		Transitioned.emit(self, "idle")
	
	if character.left_side:
		character.position = lerp(character.position, current_position - Vector3(3,0,0), 0.1)
	else:
		character.position = lerp(character.position, current_position + Vector3(3,0,0), 0.1)
	character.move_and_slide()
