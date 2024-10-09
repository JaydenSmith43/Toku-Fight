extends State
class_name S_Idle

@onready var inputArray = $"../../Input"

@export var move_speed : float = 12.0
@export var jump_force : float = 45.0
@export var gravity : float = 60.0

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String

#@export var collision : CollisionShape2D = null
#@export var idleCol : BoxShape3D 
#get boxshape3D from player or create new one for each hitbox/hurtbox change

var otherPlayer : CharacterBody3D

var crouch : bool = false

func Enter():
	
	if (get_parent().get_parent().is_in_group("player1")):
		I_left = "P1_Left"
		I_right = "P1_Right"
		I_up = "P1_Up"
		I_down = "P1_Down"
		I_light = "P1_Light"
		
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		I_left = "P2_Left"
		I_right = "P2_Right"
		I_up = "P2_Up"
		I_down = "P2_Down"
		I_light = "P2_Light"
		
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]
	pass

func Exit():
	pass
	#print("left idle")

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	#print("Distance: " + str(character.position.x - otherPlayer.position.x))
	
	if (character.position.x - otherPlayer.position.x < 0):
		model.rotation_degrees.z = 0
		model.scale = Vector3(1,1,1)
		character.leftside = true
		
	else:
		model.rotation_degrees.z = 180
		model.scale = Vector3(-1,-1,-1)
		
		character.leftside = false
		
	
	if !character.is_on_floor():
		character.velocity.y -= gravity * _delta
	
	character.velocity.x = 0
	
	#region Input
	if Input.is_action_pressed(I_left) and character.leftside == true:
		character.blocking = true
		pass
	elif Input.is_action_pressed(I_right) and character.leftside == false:
		character.blocking = true
		pass
	else:
		character.blocking = false
	
	if Input.is_action_pressed(I_left) and crouch == false: #left
		character.velocity.x -= move_speed
		anim_player.play("ForwardWalk")
		#TODO play animation
		
	if Input.is_action_pressed(I_right) and crouch == false: #right
		character.velocity.x += move_speed
		anim_player.play("ForwardWalk")
		#TODO BackWalk animation
	
	if Input.is_action_just_pressed(I_light) and crouch == false: #right
		if check_fireball_left():
			do_fireball()
			pass
		else:
			do_A()
			pass
	
	if Input.is_action_pressed(I_up) and character.is_on_floor():
		character.velocity.y = +jump_force
		Transitioned.emit(self, "jump")
		character.blocking = false
		pass
	
	if Input.is_action_pressed(I_down):
		character.velocity.x = 0
		#if sprite.animation != "crouch":
			#sprite.play("crouch")
		#TODO
		crouch = true
	elif character.velocity.x == 0:
		anim_player.play("Idle2")
		#TODO
		crouch = false
	
	character.move_and_slide()
	#endregion

func do_fireball():
	character.blocking = false
	Transitioned.emit(self, "hadou")
	
func do_A():
	character.blocking = false
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
