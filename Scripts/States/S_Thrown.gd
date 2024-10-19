extends State
class_name S_Thrown

var current_frame = 0
var throw_window_end = 15

var I_light : String
var I_medium : String

func _ready() -> void:
	if (get_parent().get_parent().is_in_group("player1")):
		I_light = "P1_Light"
		I_medium = "P1_Medium"
	else:
		I_light = "P2_Light"
		I_medium = "P2_Medium"

func Enter():
	anim_player.play("HitHigh")

func State_Physics_Update(_delta: float):
	current_frame += 1
	
	if Input.is_action_just_pressed(I_light) and Input.is_action_just_pressed(I_medium):
		tech_throw()
	
	if current_frame == throw_window_end:
		character.take_damage(10)
		#current_frame = 0
		#Transitioned.emit(self, "idle")

func tech_throw():
	Transitioned.emit(self, "idle")
