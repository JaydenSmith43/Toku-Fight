extends SGCharacterBody2D

var input_prefix : String = "P1_"
@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel
@export var hurtbox : SGArea2D
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
var jump_velocity_x : int = 0
var being_thrown := false
var entered := false
var current_frame := 0
var hit := false

#var frame_loop = 0
#custom_physics_process
func _ready():
	healthbar.init_health(health)
	up_direction = SGFixed.vector2(0, -65536)
	floor_max_angle = SGFixed.deg_to_rad(0.001)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)

func _get_local_input() -> Dictionary:
	var input_vector : Vector2
	var a_button := false
	var b_button := false
	var c_button := false
	
	#input_vector = Input.get_vector(input_prefix + "Left", input_prefix + "Right", input_prefix + "Up", input_prefix + "Down")
	if Input.is_action_pressed(input_prefix + "Left"):
		input_vector.x -= 1
	if Input.is_action_pressed(input_prefix + "Right"):
		input_vector.x += 1
	if Input.is_action_pressed(input_prefix + "Down"):
		input_vector.y -= 1
	if Input.is_action_pressed(input_prefix + "Up"):
		input_vector.y += 1
	
	if Input.is_action_just_pressed(input_prefix + "Light"):
		a_button = true
	if Input.is_action_just_pressed(input_prefix + "Medium"):
		b_button = true
	if Input.is_action_just_pressed(input_prefix + "Heavy"):
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

func _predict_remote_input(previous_input: Dictionary, ticks_since_real_input: int) -> Dictionary:
	var input = previous_input.duplicate()
	input.erase("a")
	input.erase("b")
	input.erase("c")
	#if ticks_since_real_input > 2:
	#	input.erase("input_vector")
	return input

func _network_process(input: Dictionary) -> void:
	state_machine.tick_physics_process(input)
	hurtbox.tick_physics_process()
	#move_and_collide(SGFixed.vector2(0,0))
	###TODO try calling screenbounds in here our below. maybe save its position

func _save_state() -> Dictionary:
	return {
		current_state_name = state_machine.current_state.state_name,
		entered = entered,
		current_frame = current_frame,
		fixed_position_x = fixed_position_x,
		fixed_position_y = fixed_position_y,
		jump_velocity_x = jump_velocity_x,
		velocity_x = velocity.x,
		velocity_y = velocity.y,
		movename = movename,
		hitstun = hitstun,
		blockstun = blockstun,
		health = health
		#collision_y = collision.fixed_position_y
	}

func _load_state(state: Dictionary) -> void:
	state_machine.load_state_network(state)
	entered = state['entered']
	current_frame = state['current_frame']
	fixed_position_x = state['fixed_position_x']
	fixed_position_y = state['fixed_position_y']
	jump_velocity_x = state['jump_velocity_x']
	velocity.x = state['velocity_x']
	velocity.y = state['velocity_y']
	movename = state['movename']
	hitstun = state['hitstun']
	blockstun = state['blockstun']
	health = state['health']
	#collision.fixed_position_y = state['collision_y']
	
	sync_to_physics_engine()
	#print_rich("[color=CORNFLOWER_BLUE]L_pos_x: " + str(fixed_position_x))
	#print_rich("[color=CORNFLOWER_BLUE]L_pos_y: " + str(fixed_position_y))
	#print_rich("[color=CORNFLOWER_BLUE]L_velocity_x: " + str(velocity.x))
	#print_rich("[color=CORNFLOWER_BLUE]L_velocity_y: " + str(velocity.y))
	#print_rich("[color=CORNFLOWER_BLUE]L_hit: " + str(hit))
	#print_rich("[color=CORNFLOWER_BLUE]L_current_state: [color=RED]" + state_machine.current_state.state_name)
