extends State
class_name S_Idle

@onready var inputArray = $"../../Input"
var gravity : float = 60
var move_speed : int = 16
var pushout_distance = 2

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String
var I_medium : String
var I_heavy : String

var otherPlayer : SGCharacterBody2D

func _ready() -> void:
	if (character.is_in_group("player1")):
		I_left = "P1_Left"
		I_right = "P1_Right"
		I_up = "P1_Up"
		I_down = "P1_Down"
		I_light = "P1_Light"
		I_medium = "P1_Medium"
		I_heavy = "P1_Heavy"
		
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		I_up = "P2_Up"
		I_down = "P2_Down"
		I_light = "P2_Light"
		I_medium = "P2_Medium"
		I_heavy = "P2_Heavy"
		
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	pass

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	#if character.colliding:
		#pushout_distance = 2
	#else:
		#pushout_distance = 0
	#
	##print("Distance: " + str(character.position.x - otherPlayer.position.x))
	#
	if (character.position.x - otherPlayer.position.x < 0):
		model.rotation_degrees.z = 0
		model.scale = Vector3(1,1,1)
		character.left_side = true
	else:
		model.rotation_degrees.z = 180
		model.scale = Vector3(-1,-1,-1)
		character.left_side = false
	character.character_velocity.x = 0
	character.character_velocity.y = 0
	#character.velocity.x = 0
	
	network_checkInputs(input)
	

func network_checkInputs(input: Dictionary) -> void:
	#if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_down) and character.left_side == true:
		#character.low_blocking = true
		#character.high_blocking = false
	#elif Input.is_action_pressed(I_right) and Input.is_action_pressed(I_down) and character.left_side == false:
		#character.low_blocking = true
		#character.high_blocking = false
	#elif Input.is_action_pressed(I_left) and character.left_side == true:
		#character.high_blocking = true
		#character.low_blocking = false
	#elif Input.is_action_pressed(I_right) and character.left_side == false:
		#character.high_blocking = true
		#character.low_blocking = false
	#else:
		#character.low_blocking = false
		#character.high_blocking = false

	if input.get("input_vector", Vector2.ZERO).x == 0: #neutral
		character.low_blocking = false
		character.high_blocking = false
	
	elif input.get("input_vector", Vector2.ZERO).x < 0 and character.crouch == false:
		if character.left_side == true:
			character.character_velocity.x = SGFixed.NEG_ONE
			character.character_velocity.imul(SGFixed.ONE*3)
			character.move_and_collide(character.character_velocity)
			#character.velocity.x = -(move_speed - 2)
			#sg_vector = SGFixedVector2(-move_speed - 2, 0)
			
			#character.sg_physics.move_and_collide(SGFixedVector2(-move_speed - 2, 0))
		else:
			character.character_velocity.x = SGFixed.NEG_ONE
			character.character_velocity.imul(SGFixed.ONE*3)
			character.move_and_collide(character.character_velocity)
			#character.velocity.x = -move_speed
			#character.sg_physics.move_and_collide(SGFixedVector2(-move_speed, 0))
		anim_player.play("forward_walk")
	elif input.get("input_vector", Vector2.ZERO).x > 0 and character.crouch == false: 
		#if character.left_side == false:
		character.character_velocity.x = SGFixed.ONE
		character.character_velocity.imul(SGFixed.ONE*3)
		character.move_and_collide(character.character_velocity)
			#character.velocity.x = (move_speed - 2)
		#else:
			##character.character_velocity.x = SGFixed.ONE
			##character.character_velocity.imul(move_speed_2)
			##character.sg_physics.move_and_collide(character.character_velocity)
			#character.velocity.x = move_speed
		anim_player.play("forward_walk") #TODO BackWalk animation
	
	#character.position = Vector3(character.sg_physics.position.x, -character.sg_physics.position.y, 0) / 10
	##print(character.sg_physics.velocity)

	if input.get("input_vector", Vector2.ZERO).y < 0:
		character.jump_velocity = character.velocity.x
		Transitioned.emit(self, "prejump")
		return
	elif input.get("input_vector", Vector2.ZERO).y > 0:
		character.velocity.x = 0
		anim_player.play("crouch")
		character.crouch = true
	elif character.velocity.x == 0:
		anim_player.play("idle")
		character.crouch = false

	#if input.get("a") and input.get("b") and character.crouch == false:
	#	do_throw()
	#elif Input.is_action_just_pressed(I_heavy) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5C()
	#elif Input.is_action_just_pressed(I_medium) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5B()
	#elif Input.is_action_just_pressed(I_light) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5A()
#
	#if input.get("c") and character.crouch == true:
	#	do_2C()
	#elif input.get("b") and character.crouch == true:
	#	do_2B()
	#elif input.get("a") and character.crouch == true:
	#	do_2A()
	
	#character.move_and_slide()

#func checkInputs():
	#if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_down) and character.left_side == true:
		#character.low_blocking = true
		#character.high_blocking = false
	#elif Input.is_action_pressed(I_right) and Input.is_action_pressed(I_down) and character.left_side == false:
		#character.low_blocking = true
		#character.high_blocking = false
	#elif Input.is_action_pressed(I_left) and character.left_side == true:
		#character.high_blocking = true
		#character.low_blocking = false
	#elif Input.is_action_pressed(I_right) and character.left_side == false:
		#character.high_blocking = true
		#character.low_blocking = false
	#else:
		#character.low_blocking = false
		#character.high_blocking = false
#
	#if Input.is_action_pressed(I_left) and Input.is_action_pressed(I_right):
		#character.low_blocking = false
		#character.high_blocking = false
	#
	#if Input.is_action_pressed(I_left) and character.crouch == false:
		#if character.left_side == true:
			##character.velocity.x -= (move_speed - 2)
			#return
		#else:
			#character.velocity.x -= move_speed
		#anim_player.play("forward_walk")
	#if Input.is_action_pressed(I_right) and character.crouch == false: #TODO BackWalk animation
		#if character.left_side == false:
			##character.velocity.x += (move_speed - 2)
			#return
		#else:
			#character.velocity.x += move_speed
		#anim_player.play("forward_walk")
#
	#if Input.is_action_pressed(I_up):
		#character.jump_velocity = character.velocity.x
		#Transitioned.emit(self, "prejump")
		#pass
	#elif Input.is_action_pressed(I_down):
		#character.velocity.x = 0
		#anim_player.play("crouch")
		#character.crouch = true
	#elif character.velocity.x == 0:
		#anim_player.play("idle")
		#character.crouch = false
#
	#if Input.is_action_just_pressed(I_light) and Input.is_action_just_pressed(I_medium) and character.crouch == false:
		#do_throw()
	#elif Input.is_action_just_pressed(I_heavy) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5C()
	#elif Input.is_action_just_pressed(I_medium) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5B()
	#elif Input.is_action_just_pressed(I_light) and character.crouch == false:
		#if check_fireball_left():
			#do_fireball()
		#else:
			#do_5A()
#
	#if Input.is_action_just_pressed(I_heavy) and character.crouch == true:
		#do_2C()
	#elif Input.is_action_just_pressed(I_medium) and character.crouch == true:
		#do_2B()
	#elif Input.is_action_just_pressed(I_light) and character.crouch == true:
		#do_2A()
#
	#character.move_and_slide()

func do_throw():
	Transitioned.emit(self, "thrower")

func do_fireball():
	character.blocking = false
	Transitioned.emit(self, "hadou")

func do_5A():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5a"
	Transitioned.emit(self, "attack")

func do_5B():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5b"
	Transitioned.emit(self, "attack")

func do_5C():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5c"
	Transitioned.emit(self, "attack")

func do_2A():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2a"
	Transitioned.emit(self, "attack")

func do_2B():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2b"
	Transitioned.emit(self, "attack")

func do_2C():
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2c"
	Transitioned.emit(self, "attack")

func check_fireball_left():
	if character.left_side == false:
		return check_fireball_right()
	
	var motionD : bool = false
	var motionDR : bool = false
	
	var n : int = 0
	while n < inputArray.inputs.size():
		if inputArray.inputs[n].type == "down":
			motionD = true
			n += 1
			continue
		elif inputArray.inputs[n].type == "down-r" and motionD == true:
			motionDR = true
			n += 1
			continue
		elif inputArray.inputs[n].type == "right" and motionDR == true:
			return true
		n += 1
	return false

func check_fireball_right():
	var motionD : bool = false
	var motionDL : bool = false
	
	var n : int = 0
	while n < inputArray.inputs.size():
		if inputArray.inputs[n].type == "down":
			motionD = true
			n += 1
			continue
		elif inputArray.inputs[n].type == "down-l" and motionD == true:
			motionDL = true
			n += 1
			continue
		elif inputArray.inputs[n].type == "left" and motionDL == true:
			return true
		n += 1
	return false
