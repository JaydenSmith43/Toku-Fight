extends State
class_name S_Thrower

var throw = preload("res://Scenes/Characters/throw.tscn")
var current_frame := 0
var move_end_frame := 25

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == 5:
		var new_throw = throw.instantiate()
		new_throw.leftside = character.leftside
		new_throw.scale_x = 2
		new_throw.scale_y = 2
		new_throw.pos_x = 2
		new_throw.pos_y = 3
		
		if character.is_in_group("player1"):
			new_throw.player = "player1"
		else:
			new_throw.player = "player2"
		
		get_parent().get_parent().add_child(new_throw)
	
	if current_frame == move_end_frame:
		current_frame = 0
		character.movename = "idle"
		Transitioned.emit(self, "idle")

#5 frame startup
#3 in air
