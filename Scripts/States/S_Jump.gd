extends State
class_name S_Jump

@export var jump_height : float
@export var jump_time_to_peak : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0

var otherPlayer : SGCharacterBody2D

func _ready() -> void:
	if (character.is_in_group("player1")):
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]

func Enter():
	character.current_frame = 0
	character.velocity.x = character.jump_velocity_x
	character.velocity.y = -46811
	
	#print(SGFixed.from_float(jump_velocity))
	
	character.set_collision_mask_bit(15, false)
	#character.collision.fixed_position.y -= SGFixed.ONE
	
	#print("starting jump_velocity_x: " + str(character.jump_velocity_x))
	#print("jump_velocity: " + str(jump_velocity))
	#print("jump_gravity: " + str(jump_gravity))
	#print("fall_gravity: " + str(fall_gravity))

func Exit():
	#character.jump_velocity_x = 0
	#character.velocity.y = 0
	character.velocity.x = 0
	#character.collision.fixed_position.y += SGFixed.ONE
	character.set_collision_mask_bit(15, true)
	#print("exit jump")

func State_Physics_Update(input: Dictionary): #ADD a check for facing left without changing model
	character.current_frame += 1
	#print("JUMP UPDATE: " + str(character.current_frame))
	character.velocity.y += 2229 #(-15 * 65536) / ((0.35 * 60) * (0.35 * 60))
	
	if character.jump_velocity_x > 0:
		character.velocity.x = character.jump_velocity_x + (2184)
	elif character.jump_velocity_x < 0:
		character.velocity.x = character.jump_velocity_x - (2184)
		pass
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	check_jump_attack(input)
	
	if character.is_on_floor() : #and current_frame > 20
		#if input.get("input_vector", Vector2.ZERO).y > 0:
			#if (character.fixed_position.x - otherPlayer.fixed_position.x < 0):
				#model.rotation_degrees.z = 0
				#model.scale = Vector3(1,1,1)
				#character.left_side = true
			#else:
				#model.rotation_degrees.z = 180
				#model.scale = Vector3(-1,-1,-1)
				#character.left_side = false
			#character.velocity.x = 0
			#character.velocity.y = 0
			#
			#if input.get("input_vector", Vector2.ZERO).x < 0 and character.crouch == false:
				#if character.left_side == true:
					#character.velocity.x = -15291
				#else:
					#character.velocity.x = -17476 
			#if input.get("input_vector", Vector2.ZERO).x > 0 and character.crouch == false: 
				#if character.left_side == false:
					#character.velocity.x = 15291
				#else:
					#character.velocity.x = 17476
			#character.jump_velocity_x = character.velocity.x
			#Transitioned.emit(self, "prejump")
			#return
		
		Transitioned.emit(self, "idle")
		return

#func get_gravity() -> float:
	#return jump_gravity if character.character_velocity.y < 0.0 else fall_gravity

func check_jump_attack(input: Dictionary):
	if input.get("a") and input.get("b") and character.crouch == false:
		#Attack.do_throw(character)
		return
	elif input.get("c") and character.crouch == false:
		Attack.check_motions_available(character, input_array, "jump_c", "jump")
		return
	elif input.get("b") and character.crouch == false:
		Attack.check_motions_available(character, input_array, "jump_b", "jump")
		return
	elif input.get("a") and character.crouch == false:
		Attack.check_motions_available(character, input_array, "jump_a", "jump")
		return
