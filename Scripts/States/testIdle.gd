extends State
class_name testIdle

@onready var inputArray = $"../../Input"

@export var move_speed : float = 450.0
@export var jump_force : float = 700.0
@export var gravity : float = 1800.0

var I_left : String
var I_right : String
var I_up : String
var I_down : String
var I_light : String

#@export var collision : CollisionShape2D = null
@export var idleCol : RectangleShape2D

var otherPlayer : CharacterBody2D

var crouch : bool = false

func Enter():
	#Add player 1 or 2 logic here for group adding
	
	#if (!collision):
		#collision = get_parent().get_parent().get_child(1) #2nd child
	#collision.shape = idleCol
	#collision.position.y = 105
	
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
	print("left idle")

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	#print("Distance: " + str(character.position.x - otherPlayer.position.x))
	if (character.position.x - otherPlayer.position.x > 0):
		sprite.position.x = -120
		sprite.flip_h = true
	else:
		sprite.position.x = 120
		sprite.flip_h = false
	
	
	if !character.is_on_floor():
		character.velocity.y += gravity * _delta
	
	character.velocity.x = 0
	
	#region Input
	if Input.is_action_pressed(I_left) and crouch == false: #left
		character.velocity.x -= move_speed
		sprite.play("walk")
	if Input.is_action_pressed(I_right) and crouch == false: #right
		character.velocity.x += move_speed
		sprite.play("walk")
	
	if Input.is_action_just_pressed(I_light) and crouch == false: #right
		if check_fireball():
			do_fireball()
			pass
		else:
			do_A()
			pass
	
	if Input.is_action_pressed(I_up) and character.is_on_floor():
		character.velocity.y = -jump_force
		Transitioned.emit(self, "jump")
		pass
	
	if Input.is_action_pressed(I_down):
		character.velocity.x = 0
		if sprite.animation != "crouch":
			sprite.play("crouch")
		crouch = true
	elif character.velocity.x == 0:
		sprite.play("idle")
		crouch = false
	
	character.move_and_slide()
	#endregion

func do_fireball():
	Transitioned.emit(self, "hadou")
	
func do_A():
	Transitioned.emit(self, "attack")

func check_fireball():
	var motionD : bool = false
	var motionDR : bool = false
	var motionR : bool = false
	
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
