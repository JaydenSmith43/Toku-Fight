extends State
class_name S_Thrower

var throw = preload("res://Scenes/Characters/throw2D.tscn")
var move_end_frame := 25

var throw_end_frame := 60

var other_player : SGCharacterBody2D

func _ready() -> void:
	if character.is_in_group("player1"):
		other_player = get_tree().get_nodes_in_group("player2")[0]
	else:
		other_player = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	anim_player.play("throw")
	character.throwing = false
	character.current_frame = 0
	character.throw_state_frame = 0

func Exit():
	character.throwing = false
	character.current_frame = 0
	character.throw_state_frame = 0

func State_Physics_Update(input: Dictionary):
	if !character.throwing:
		character.current_frame += 1
		
		if other_player.being_thrown == true:
			anim_player.play("grappler_thrower")
			character.throwing = true
	
		if character.current_frame == 5:
			create_throw()
	
		if character.current_frame == move_end_frame:
			character.current_frame = 0
			character.movename = "idle"
			Transitioned.emit(self, "idle")
	else:
		character.throw_state_frame += 1
			
		if character.throw_state_frame == throw_end_frame:
			character.movename = "idle"
			Transitioned.emit(self, "idle")

#5 frame startup
#3 in air
func create_throw():
	var player : String
	if character.is_in_group("player1"):
		player = "player1"
	else:
		player = "player2"
	
	SyncManager.spawn("Throw", get_parent().get_parent(), throw, { 
		#damage = data["damage"],
		end_frame = 5,
		fixed_pos_x = SGFixed.from_float(2),
		fixed_pos_y = -SGFixed.from_float(3),
		extents_x = SGFixed.div(SGFixed.from_float(2), 131072),
		extents_y = SGFixed.div(SGFixed.from_float(2), 131072),
		player = player,
		left_side = character.left_side
	})
