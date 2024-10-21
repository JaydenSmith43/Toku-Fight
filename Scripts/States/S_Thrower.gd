extends State
class_name S_Thrower

var throw = preload("res://Scenes/Characters/throw.tscn")
var current_frame := 0
var move_end_frame := 25

var throwing := false
var throw_current_frame := 0
var throw_end_frame := 60

var other_player : CharacterBody3D

func _ready() -> void:
	if character.is_in_group("player1"):
		other_player = get_tree().get_nodes_in_group("player2")[0]
	else:
		other_player = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	anim_player.play("throw")
	throwing = false
	current_frame = 0
	throw_current_frame = 0

func State_Physics_Update(_delta: float):
	
	
	if !throwing:
		current_frame += 1
		if other_player.being_thrown == true:
			anim_player.play("grappler_thrower")
			throwing = true
	
		if current_frame == 5:
			create_throw()
	
		if current_frame == move_end_frame:
			current_frame = 0
			character.movename = "idle"
			Transitioned.emit(self, "idle")
	else:
		throw_current_frame += 1
			
		if throw_current_frame == throw_end_frame:
			character.movename = "idle"
			Transitioned.emit(self, "idle")

#5 frame startup
#3 in air
func create_throw():
	var new_throw = throw.instantiate()
	new_throw.left_side = character.left_side
	new_throw.scale_x = 2
	new_throw.scale_y = 2
	new_throw.pos_x = 2
	new_throw.pos_y = 3
	
	if character.is_in_group("player1"):
		new_throw.player = "player1"
	else:
		new_throw.player = "player2"
	get_parent().get_parent().add_child(new_throw)
