extends State
class_name S_Teched

#var current_frame = 0
var animation_end = 27

func _ready() -> void:
	pass # Replace with function body.

func Enter():
	anim_player.play("throw_teched")
	character.current_frame = 0
	if character.left_side:
		character.velocity.x = -19660
	else:
		character.velocity.x = 19660

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == animation_end:
		character.move_name = "idle"
		Transitioned.emit(self, "idle")
	
	character.velocity.x = lerp(character.velocity.x, 0, 0.1)
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
