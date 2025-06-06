extends State
class_name S_Idle

var gravity : float = 60
var move_speed : int = 17476
var pushout_distance = 2

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String
var I_medium : String
var I_heavy : String

var opposingPlayer : SGCharacterBody2D

func _ready() -> void:
	if character.is_in_group("player1"):
		I_left = "P1_Left"
		I_right = "P1_Right"
		I_up = "P1_Up"
		I_down = "P1_Down"
		I_light = "P1_Light"
		I_medium = "P1_Medium"
		I_heavy = "P1_Heavy"
		
		opposingPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		I_up = "P2_Up"
		I_down = "P2_Down"
		I_light = "P2_Light"
		I_medium = "P2_Medium"
		I_heavy = "P2_Heavy"
		
		opposingPlayer = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	if model.rotation_degrees.y == -180 and character.left_side:
		model.rotate_y(deg_to_rad(-90))
	elif model.rotation_degrees.y == 0 and !character.left_side:
		model.rotate_y(deg_to_rad(90))
	
	character.current_frame = 0
	character.jump_velocity_x = 0
	character.velocity.y = 0
	character.velocity.x = 0
	#character.hittable = true
	#character.collision.fixed_position.y += SGFixed.ONE
	character.set_collision_mask_bit(15, true)
func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	#print(str(multiplayer.multiplayer_peer.get_unique_id()) + " idle state: " + str(character.current_frame))
	#if character.colliding:
		#pushout_distance = 2
	#else:
		#pushout_distance = 0
	
	#print("Distance: " + str(character.position.x - otherPlayer.position.x))
	
	if (character.fixed_position.x - opposingPlayer.fixed_position.x < 0):
		model.rotation_degrees.z = 0
		model.scale = Vector3(1,1,1)
		character.left_side = true
	else:
		model.rotation_degrees.z = 180
		model.scale = Vector3(-1,-1,-1)
		character.left_side = false
	character.velocity.x = 0
	character.velocity.y = 0
	
	network_checkInputs(input)
	

func network_checkInputs(input: Dictionary) -> void:
	if input.get("input_vector", Vector2.ZERO).x < 0 and input.get( # leftside downback
		"input_vector", Vector2.ZERO).y < 0 and character.left_side == true:
		character.low_blocking = true
		character.high_blocking = false
	elif input.get("input_vector", Vector2.ZERO).x > 0 and input.get( #rightside downback
		"input_vector", Vector2.ZERO).y < 0 and character.left_side == false:
		character.low_blocking = true
		character.high_blocking = false
	elif input.get("input_vector", Vector2.ZERO).x < 0 and character.left_side == true: #left back
		character.high_blocking = true
		character.low_blocking = false
	elif input.get("input_vector", Vector2.ZERO).x > 0 and character.left_side == false: # right back
		character.high_blocking = true
		character.low_blocking = false
	else: 
		character.low_blocking = false
		character.high_blocking = false

	if input.get("input_vector", Vector2.ZERO).y < 0: #crouch
		character.velocity.x = 0
		anim_player.play("crouch") 
		character.crouch = true
	
	if input.get("input_vector", Vector2.ZERO).y == 0: #y neutral
		character.crouch = false
	if input.get("input_vector", Vector2.ZERO).x == 0: #x neutral
		character.low_blocking = false
		character.high_blocking = false
		character.velocity.x = 0
	
	elif input.get("input_vector", Vector2.ZERO).x < 0 and character.crouch == false: #left
		if character.left_side == true:
			character.velocity.x = -15291 #-14/60*65536
			anim_player.play("forward_walk")
		else:
			character.velocity.x = -17476 
			anim_player.play("forward_walk")
	elif input.get("input_vector", Vector2.ZERO).x > 0 and character.crouch == false: #right
		if character.left_side == false:
			character.velocity.x = 15291
			anim_player.play("forward_walk")
		else:
			character.velocity.x = 17476
			anim_player.play("forward_walk")
		 #TODO BackWalk animation

	if character.velocity.x == 0 and character.crouch == false: #idle check
		anim_player.play("idle")
		character.crouch = false
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if input.get("input_vector", Vector2.ZERO).y > 0: #jump check
		character.jump_velocity_x = character.velocity.x
		Transitioned.emit(self, "prejump")
		return
	if Attack.check_motion(character, input_array, [6, 5, 6], ""):
		Transitioned.emit(self, "forward_dash")
		return

	if input_array.was_pressed("A", 1) and input_array.was_pressed("B", 1) and character.crouch == false:
		Attack.do_throw(character)
		return
	elif input_array.was_pressed("C", 1) and character.crouch == false:
		Attack.check_motions_available(character, input_array, "5c", "ground")
		return
	elif input_array.was_pressed("B", 1) and character.crouch == false:
		Attack.check_motions_available(character, input_array, "5b", "ground")
		return
	elif input_array.was_pressed("A", 1) and character.crouch == false:
		Attack.check_motions_available(character, input_array, "5a", "ground")
		return

	if input_array.was_pressed("C", 1) and character.crouch == true:
		Attack.do_ground_attack(character, "2c")
		return
	elif input_array.was_pressed("B", 1) and character.crouch == true:
		Attack.do_ground_attack(character, "2b")
		return
	elif input_array.was_pressed("A", 1) and character.crouch == true:
		Attack.do_ground_attack(character, "2a")
		return
