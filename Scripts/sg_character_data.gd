extends Node3D

var input_prefix : String = "P1_"
@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel
@onready var hurtbox = $Hurtbox
@onready var collision = $collision
@export var state_machine : Node
@export var sg_physics : SGCharacterBody2D

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

var character_velocity = SGFixedVector2.new()

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
	
	input_vector = Input.get_vector(input_prefix + "Left", input_prefix + "Right", input_prefix + "Up", input_prefix + "Down")
	#input_vector = Input.get_vector("P2_Left", "P2_Right", "P2_Up", "P2_Down")
	
	#if Input.is_action_pressed("P1_Left"):
		
	
	if Input.is_action_just_pressed(input_prefix + "Light"):
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

#func _predict_remote_input(previous_input: Dictionary, ticks_since_real_input: int) -> Dictionary:
#	var input = previous_input.duplicate()
#	input.erase("a")
#	input.erase("b")
#	input.erase("c")
	#if ticks_since_real_input > 2:
	#	input.erase("input_vector")
#	return input

func _network_process(input: Dictionary) -> void:
	state_machine.tick_physics_process(input)

func _save_state() -> Dictionary:
	return {
		#current_state = state_machine.states.get(state_machine.new_state_name.to_lower()),
		position = position,
		#velocity = velocity
	}

func _load_state(state: Dictionary) -> void:
	#velocity = state['velocity']
	position = state['position']
	sg_physics.sync_to_physics_engine()

#func _physics_process(delta: float) -> void:
	#frame_loop += 1
	#if frame_loop > 60:
		#frame_loop = 1
	#
	#print(str(frame_loop) + ": " + str(velocity.x))
