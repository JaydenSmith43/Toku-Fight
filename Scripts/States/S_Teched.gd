extends State
class_name S_Teched

#var current_frame = 0
var animation_end = 27
var current_position : SGFixedVector2

func _ready() -> void:
	pass # Replace with function body.

func Enter():
	anim_player.play("throw_teched")
	character.current_frame = 0
	#current_position = Vector3(character.position.x, character.position.y, 0.477)
	current_position = SGFixed.vector2(character.fixed_position_x, character.fixed_position_y)
	if character.left_side:
		character.velocity.x = -19660
	else:
		character.velocity.x = 19660

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == animation_end:
		character.movename = "idle"
		Transitioned.emit(self, "idle")
	
	character.velocity.x = lerp(character.velocity.x, 0, 0.1)
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
