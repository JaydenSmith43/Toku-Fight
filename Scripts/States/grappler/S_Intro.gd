extends State
class_name S_Intro

func Enter():
	anim_player.stop()
	anim_player.play("idle")
	character.current_frame = 0

func Exit():
	character.current_frame = 0
	character.reset_self()

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == 1:
		character.rematch = false
		character.reset_self()
		if character.is_in_group("player1"):
			character.game_manager.current_game_state = 0
	
	if character.current_frame == 180:
		Transitioned.emit(self, "idle")
