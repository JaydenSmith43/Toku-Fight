extends State
class_name S_Thrown

var current_frame = 0
var throw_window_end = 15

var tech_throw_frame = 0
var tech_throw_end = 25
var teching : bool = false
var current_position : Vector3

var I_light : String
var I_medium : String

var other_player : CharacterBody3D

func _ready() -> void:
	if (character.is_in_group("player1")):
		I_light = "P1_Light"
		I_medium = "P1_Medium"
		other_player = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_light = "P2_Light"
		I_medium = "P2_Medium"
		other_player = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	character.being_thrown = true
	anim_player.play("grappler_throw_taker")
	current_frame = 0
	tech_throw_frame = 0
	teching = false
	
	if character.left_side:
		character.rotate_y(90)
	else:
		character.rotate_y(-90)

func Exit():
	character.being_thrown = false

func State_Physics_Update(_delta: float):
	current_frame += 1
	if teching:
		tech_throw_frame += 1
		if character.left_side:
			character.position = lerp(character.position, current_position - Vector3(2,0,0), 0.1)
		else:
			character.position = lerp(character.position, current_position + Vector3(2,0,0), 0.1)
		

		character.move_and_slide()
		if tech_throw_frame == tech_throw_end:
			character.being_thrown = false
			Transitioned.emit(self, "idle")
			return
	else:
		if Input.is_action_just_pressed(I_light) and Input.is_action_just_pressed(I_medium) and current_frame < throw_window_end:
			tech_throw()
	
		if current_frame == 40: #TODO SEND THEM TO KNOCKDOWN STATE FOR CERTAIN AMOUNT OF FRAMES
			character.take_damage(10)
		if current_frame == 60:
			if character.left_side:
				character.rotate_y(-90)
			else:
				character.rotate_y(90)
			Transitioned.emit(self, "idle")

func tech_throw():
	anim_player.play("throw_tech")
	teching = true
	current_position = character.position
	
	if character.left_side:
		character.rotate_y(-90)
	else:
		character.rotate_y(90)
	
	other_player.state_machine.current_state.Transitioned.emit(other_player.state_machine.current_state, "teched")
