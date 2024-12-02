extends State
class_name S_CommandThrown

var end_frame

var I_light : String
var I_medium : String

var other_player : SGCharacterBody2D

var jump_velocity = 46811
var jump_gravity = 1000
var fall_gravity = 674

const SFX_EXPLOSION = preload("res://Audio/SFX/Combat/explosion.mp3")

func _ready() -> void:
	if character.is_in_group("player1"):
		other_player = get_tree().get_nodes_in_group("player2")[0]
	else:
		other_player = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	character.being_thrown = true
	#character.hittable = false
	
	character.current_frame = 0
	character.throw_state_frame = 0
	character.velocity.x = 0
	
	if character.left_side:
		model.rotate_y(deg_to_rad(90))
	else:
		model.rotate_y(deg_to_rad(-90))

func Exit():
	character.being_thrown = false
	character.hittable = true

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	
	if character.current_frame == 1:
		anim_player.play("buster_taker")
		if character.left_side:
			character.fixed_position_x = other_player.fixed_position_x + (4 * 65536)
		else:
			character.fixed_position_x = other_player.fixed_position_x - (4 * 65536)
	
	if character.current_frame == 60:
		character.velocity.y = -46811
		
	if character.current_frame >= 60 and character.current_frame < 165:
		character.velocity.y += get_gravity()
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.current_frame == 165: #TODO SEND THEM TO KNOCKDOWN STATE FOR CERTAIN AMOUNT OF FRAMES
		character.take_damage(18)
		SyncManager.play_sound(str(get_path()) + ":explosion", SFX_EXPLOSION)
	if character.current_frame == 200:
		character.camera_state = "normal"
		character.velocity.y = -65536 * 3
		character.move_and_slide()
		Transitioned.emit(self, "juggle")

func get_gravity() -> float:
	return jump_gravity if character.velocity.y < 0.0 else fall_gravity
