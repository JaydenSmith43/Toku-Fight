extends State
class_name S_Jump

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

var current_frame := 0

func Enter():
	current_frame = 0
	character.velocity.y = jump_velocity
	character.set_collision_mask_value(16, false)
	character.collision.position.y += 1

func Exit():
	character.jump = false
	character.jump_velocity = 0
	character.velocity.x = 0
	character.collision.position.y -= 1
	character.set_collision_mask_value(16, true)

func State_Physics_Update(delta: float): #ADD a check for facing left without changing model
	current_frame += 1
	
	if !character.is_on_floor():
		character.velocity.y += get_gravity() * delta
		
		if character.jump_velocity > 0:
			character.velocity.x = character.jump_velocity + 2
		elif character.jump_velocity < 0:
			character.velocity.x = character.jump_velocity - 2
			pass
	elif character.is_on_floor() and current_frame > 20:
		Transitioned.emit(self, "idle")
		pass
	
	character.move_and_slide()

func get_gravity() -> float:
	return jump_gravity if character.velocity.y > 0.0 else fall_gravity
