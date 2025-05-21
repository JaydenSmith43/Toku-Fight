extends State
class_name S_Knockdown

var knockdown_frame := 60

func Enter():
	character.current_frame = 0
	anim_player.play("knockdown")
	character.hittable = false
	character.throw_invul = true

func Exit():
	character.current_frame = 0
	character.hittable = true
	character.throw_invul = false

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == 1:
		model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if knockdown_frame - character.current_frame == 22:
		anim_player.play("getup")
	
	if character.current_frame == knockdown_frame:
		Transitioned.emit(self, "idle")
		return
