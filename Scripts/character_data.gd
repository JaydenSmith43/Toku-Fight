extends CharacterBody3D

@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel
@onready var hurtbox = $Hurtbox
@onready var collision = $collision
@export var state_machine : Node

var health := 100
var left_side := false
var low_blocking := false
var high_blocking := false
var crouch := false
var jump := false
var movename := "null"
var hitstun := 0
var blockstun := 0
var height_hit := ""
var colliding := false
var jump_velocity = 0
var being_thrown := false
var input_vector : Vector2

var frame_loop = 0
#custom_physics_process
func _ready():
	healthbar.init_health(health)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180
		
		hurtbox.set_collision_layer_value(2, false) #TODO TODO TODO TODO move to hurtbox initialization
		hurtbox.set_collision_mask_value(5, false)
		hurtbox.set_collision_layer_value(3, true)
		hurtbox.set_collision_mask_value(4, true)

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)

func _get_local_input() -> Dictionary:
	var input_vector
	var a_button := false
	var b_button := false
	var c_button := false
	
	if is_in_group("player1"):
		input_vector = Input.get_vector("P1_Left", "P1_Right", "P1_Up", "P1_Down")
	else:
		input_vector = Input.get_vector("P2_Left", "P2_Right", "P2_Up", "P2_Down")
	
	if Input.is_action_just_pressed("P1_Light"):
		a_button = true
	if Input.is_action_just_pressed("P1_Medium"):
		b_button = true
	if Input.is_action_just_pressed("P1_Heavy"):
		c_button = true
	
	var input := {}
	if input_vector != Vector2.ZERO:
		input["input_vector"] = input_vector
	if a_button == true:
		input["a"] = a_button
	if b_button == true:
		input["b"] = b_button
	if c_button == true:
		input["c"] = c_button
	
	return input

func _network_process(input: Dictionary) -> void:
	state_machine.tick_physics_process(input)

func _save_state() -> Dictionary:
	return {
		velocity = velocity
	}

func _load_state(state: Dictionary) -> void:
	velocity = state['velocity']

#func _physics_process(delta: float) -> void:
	#frame_loop += 1
	#if frame_loop > 60:
		#frame_loop = 1
	#
	#print(str(frame_loop) + ": " + str(velocity.x))
