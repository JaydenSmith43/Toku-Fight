extends State
class_name S_Grappler63214

var throw = preload("res://Scenes/Characters/throw2D.tscn")
var move_end_frame := 40

var throw_end_frame := 240

var other_player : SGCharacterBody2D
var jump_velocity = 46811
var jump_gravity = 1000
var fall_gravity = 674

func _ready() -> void:
	if character.is_in_group("player1"):
		other_player = get_tree().get_nodes_in_group("player2")[0]
	else:
		other_player = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	anim_player.play("buster_whiff")
	character.throwing = false
	character.current_frame = 0
	character.throw_state_frame = 0
	character.velocity.x = 0

func Exit():
	character.throwing = false
	character.current_frame = 0
	character.throw_state_frame = 0

func State_Physics_Update(input: Dictionary):
	if !character.throwing:
		character.current_frame += 1
		
		if other_player.being_thrown == true:
			anim_player.play("buster_thrower")
			character.throwing = true
	
		if character.current_frame == 10:
			create_throw()
	
		if character.current_frame == move_end_frame:
			character.current_frame = 0
			character.move_name = "idle"
			Transitioned.emit(self, "idle")
	else:
		character.throw_state_frame += 1
		character.camera_state = "buster"
		
		if character.throw_state_frame == 60:
			character.velocity.y = -46811
		
		if character.throw_state_frame >= 60:
			character.velocity.y += get_gravity()
	
		character.move_and_slide()
		model.position.x = SGFixed.to_float(character.fixed_position_x)
		model.position.y = -SGFixed.to_float(character.fixed_position_y)
			
		if character.throw_state_frame == throw_end_frame:
			character.camera_state = "normal"
			character.move_name = "idle"
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
		left_side = character.left_side,
		techable = false
	})

func get_gravity() -> float:
	return jump_gravity if character.velocity.y < 0.0 else fall_gravity
