extends State
class_name S_Idle

@onready var inputArray = $"../../Input"
@export var gravity : float = 60
@export var move_speed : float = 12.0

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String
var I_medium : String
var I_heavy : String

var otherPlayer : CharacterBody3D

func Enter():
	
	if (get_parent().get_parent().is_in_group("player1")):
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

func Exit():
	pass
	#print("left idle")

func State_Physics_Update(_delta: float):
	#print("Distance: " + str(character.position.x - otherPlayer.position.x))
	if !character.is_on_floor():
		character.velocity.y -= gravity * _delta
	
	if (character.position.x - otherPlayer.position.x < 0):
		model.rotation_degrees.z = 0
		model.scale = Vector3(1,1,1)
		character.leftside = true
	else:
		model.rotation_degrees.z = 180
		model.scale = Vector3(-1,-1,-1)
		character.leftside = false
	
	character.velocity.x = 0
	
	checkInputs()

func checkInputs():
	if Input.is_action_pressed(I_left) and character.leftside == true:
		character.blocking = true
	elif Input.is_action_pressed(I_right) and character.leftside == false:
		character.blocking = true
	else:
		character.blocking = false

	if Input.is_action_pressed(I_left) and character.crouch == false:
		character.velocity.x -= move_speed
		anim_player.play("ForwardWalk")
	if Input.is_action_pressed(I_right) and character.crouch == false: #TODO BackWalk animation
		character.velocity.x += move_speed
		anim_player.play("ForwardWalk")

	if Input.is_action_pressed(I_up):
		Transitioned.emit(self, "prejump")
		character.blocking = false
		pass
	elif Input.is_action_pressed(I_down):
		character.velocity.x = 0
		anim_player.play("Crouch")
		character.crouch = true
	elif character.velocity.x == 0:
		anim_player.play("Idle2")
		character.crouch = false

	if Input.is_action_just_pressed(I_heavy) and character.crouch == false:
		if check_fireball_left():
			do_fireball()
		else:
			do_5C()
	elif Input.is_action_just_pressed(I_medium) and character.crouch == false:
		if check_fireball_left():
			do_fireball()
		else:
			do_5B()
	elif Input.is_action_just_pressed(I_light) and character.crouch == false:
		if check_fireball_left():
			do_fireball()
		else:
			do_5A()

	if Input.is_action_just_pressed(I_heavy) and character.crouch == true:
		do_2C()
	elif Input.is_action_just_pressed(I_medium) and character.crouch == true:
		do_2B()
	elif Input.is_action_just_pressed(I_light) and character.crouch == true:
		do_2A()

	character.move_and_slide()

func do_fireball():
	character.blocking = false
	Transitioned.emit(self, "hadou")
	
func do_5A():
	character.blocking = false
	character.movename = "grappler_5a"
	Transitioned.emit(self, "attack")

func do_5B():
	character.blocking = false
	character.movename = "grappler_5b"
	Transitioned.emit(self, "attack")

func do_5C():
	character.blocking = false
	character.movename = "grappler_5c"
	Transitioned.emit(self, "attack")

func do_2A():
	character.blocking = false
	character.movename = "grappler_2a"
	Transitioned.emit(self, "attack")

func do_2B():
	character.blocking = false
	character.movename = "grappler_2b"
	Transitioned.emit(self, "attack")

func do_2C():
	character.blocking = false
	character.movename = "grappler_2c"
	Transitioned.emit(self, "attack")

func check_fireball_left():
	if character.leftside == false:
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
