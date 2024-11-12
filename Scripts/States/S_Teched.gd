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

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == animation_end:
		character.movename = "idle"
		Transitioned.emit(self, "idle")
	
	if character.left_side:
		#character.position = lerp(character.position, current_position - Vector3(3,0,0), 0.1)
		character.fixed_position_x = lerp(character.fixed_position_x, current_position.x - (3 * SGFixed.ONE), 0.1)
		
	else:
		#character.position = lerp(character.position, current_position + Vector3(3,0,0), 0.1)
		character.fixed_position_x = lerp(character.fixed_position_x, current_position.x + (3 * SGFixed.ONE), 0.1)
	
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
