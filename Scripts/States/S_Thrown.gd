extends State
class_name S_Thrown

var current_frame = 0
var throw_tech_window = 12

# Called when the node enters the scene tree for the first time.
func Enter():
	anim_player.play("HitHigh")


func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if current_frame == throw_tech_window:
		current_frame = 0
		Transitioned.emit(self, "idle")
