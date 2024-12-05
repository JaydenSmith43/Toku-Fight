extends SGCharacterBody2D

var input_prefix : String = "P1_"
@onready var healthbar = $UI/HealthBar
@onready var input_display = $UI
@onready var name_label = $UI/NameLabel
@onready var round_label = $UI/RoundLabel
@onready var time_label = $UI/TimeLabel
@onready var round_count_1 = $UI/RoundCount1
@onready var round_count_2 = $UI/RoundCount2
#@onready var label = $UI/HealthBar/StateLabel
@onready var input_array = $Input
@onready var anim_player = $model/AnimationPlayer
@onready var collision = $collision
@export var hurtbox : SGArea2D
@export var throwbox : SGArea2D
@export var state_machine : Node
@export var model : Node3D
@export var game_manager : Node

var character_name = "grappler"
var motions = ["j214", "63214"]
var charge = ["28"]
var camera_state = "normal"

var health := 100
var list_of_hitboxes = []

var input_current_frame := 0
var left_side := false
var low_blocking := false
var high_blocking := false
var crouch := false
var move_name := "null"
var buffered_move := ""
var hitstun := 0
var blockstun := 0
var height_hit := ""
var colliding := false
var jump_velocity_x : int = 0
var being_thrown := false
var throwing := false
var teching := false
var cancel := false
var throw_state_frame := 0
var current_frame := 0
var hittable = true
var combo := 0
var throw_invul := false
var rematch := true

func _ready():
	healthbar.init_health(health)
	up_direction = SGFixed.vector2(0, -65536)
	
	if is_in_group("player1"):
		game_manager.player1 = self
	else:
		game_manager.player2 = self
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180
		name_label.position.x = 1908 - 202
		name_label.horizontal_alignment = 1
		round_count_1.position.x = 1123
		round_count_2.position.x = 1159
		model.swap_color(2)
	game_manager.game_start()

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)
	
	if health <= 0:
		if is_in_group("player1"):
			game_manager.p1_rounds += 1
		else:
			game_manager.p2_rounds += 1
		game_manager.final_hit_pause()

func reset_self():
	if is_in_group("player1"):
		fixed_position.x = -8 * 65536
		model.rotation_degrees.z = 0
		model.scale = Vector3(1,1,1)
		left_side = true
	else:
		fixed_position.x = 8 * 65536
		model.rotation_degrees.z = 180
		model.scale = Vector3(-1,-1,-1)
		left_side = false
	sync_to_physics_engine()
	health = 100
	healthbar._set_health(health)
	model.position.x = SGFixed.to_float(fixed_position_x)
	model.position.y = -SGFixed.to_float(fixed_position_y)

func update_hitboxes():
	var hitboxes
	hitboxes = get_tree().get_nodes_in_group("p1_hitbox")
	for hitbox in hitboxes:
		hitbox.tick_physics_process()
	hitboxes = get_tree().get_nodes_in_group("p2_hitbox")
	for hitbox in hitboxes:
		hitbox.tick_physics_process()

func disable_ui():
	healthbar.visible = false
	round_label.visible = false
	time_label.visible = false
	name_label.visible = false
	round_count_1.visible = false
	round_count_2.visible = false

func enable_ui():
	healthbar.visible = true
	round_label.visible = true
	time_label.visible = true
	name_label.visible = true
	round_count_1.visible = true
	round_count_2.visible = true

func _get_local_input() -> Dictionary:
	var input_vector : Vector2i
	
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
	if input_vector != Vector2i.ZERO:
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
	#if is_in_group("player1"):
	#	print_rich("[color=CORNFLOWER_BLUE]P1 netprocess: " + str(current_frame))
	#else:
	#	print_rich("[color=CORNFLOWER_BLUE]P2 netprocess: " + str(current_frame))
	#GameManager.game_state_update()
	#if input.get("a"):
	#	game_manager.pause_game()
	
	if game_manager.disable_input:
		input.clear()
	
	if game_manager.pause:
		pass
	else:
		if is_in_group("player1"):
			game_manager.game_process()
		update_hitboxes()
		input_array.input_handler(self, input)
		input_display.update_input_display()
		state_machine.tick_physics_process(input)
		update_hitboxes()
		hurtbox.tick_physics_process()
		throwbox.tick_physics_process()
		#update_hitboxes()
	
	###TODO try calling screenbounds in here our below. maybe save its position

func _save_state() -> Dictionary:
	return {
		current_state_name = state_machine.current_state.state_name,
		current_frame = current_frame,
		fixed_position_x = fixed_position_x,
		fixed_position_y = fixed_position_y,
		jump_velocity_x = jump_velocity_x,
		velocity_x = velocity.x,
		velocity_y = velocity.y,
		move_name = move_name,
		hitstun = hitstun,
		blockstun = blockstun,
		health = health,
		being_thrown = being_thrown,
		throwing = throwing,
		teching = teching,
		throw_state_frame = throw_state_frame,
		model_rotation_y = model.rotation.y,
		cancel = cancel,
		buffered_move = buffered_move,
		input_current_frame = input_current_frame,
		camera_state = camera_state,
		hittable = hittable,
		combo = combo,
		throw_invul = throw_invul,
		rematch = rematch,
		
		fade_modulate_a = game_manager.fade_sprite.modulate.a,
		pause = game_manager.pause,
		p1_rounds = game_manager.p1_rounds,
		p2_rounds = game_manager.p2_rounds,
		current_round = game_manager.current_round,
		current_game_state = game_manager.current_game_state,
		intro = game_manager.intro,
		song_played = game_manager.song_played,
	}

func _load_state(state: Dictionary) -> void:
	state_machine.load_state_network(state)
	current_frame = state['current_frame']
	fixed_position_x = state['fixed_position_x']
	fixed_position_y = state['fixed_position_y']
	jump_velocity_x = state['jump_velocity_x']
	velocity.x = state['velocity_x']
	velocity.y = state['velocity_y']
	move_name = state['move_name']
	hitstun = state['hitstun']
	blockstun = state['blockstun']
	health = state['health']
	being_thrown = state['being_thrown']
	throwing = state['throwing']
	teching = state['teching']
	throw_state_frame = state['throw_state_frame']
	model.rotation.y = state['model_rotation_y']
	cancel = state['cancel']
	buffered_move = state['buffered_move']
	input_current_frame = state['input_current_frame']
	camera_state = state['camera_state']
	hittable = state['hittable']
	combo = state['combo']
	throw_invul = state['throw_invul']
	rematch = state['rematch']
	
	game_manager.fade_sprite.modulate.a = state['fade_modulate_a']
	game_manager.pause = state['pause']
	game_manager.p1_rounds = state['p1_rounds']
	game_manager.p2_rounds = state['p2_rounds']
	game_manager.current_round = state['current_round']
	game_manager.current_game_state = state['current_game_state']
	game_manager.intro = state['intro']
	game_manager.song_played = state['song_played']
	
	healthbar.health = health
	
	sync_to_physics_engine()
	#print_rich("[color=CORNFLOWER_BLUE]L_pos_x: " + str(fixed_position_x))
	#print_rich("[color=CORNFLOWER_BLUE]L_pos_y: " + str(fixed_position_y))
	#print_rich("[color=CORNFLOWER_BLUE]L_velocity_x: " + str(velocity.x))
	#print_rich("[color=CORNFLOWER_BLUE]L_velocity_y: " + str(velocity.y))
	
	#print_rich("[color=CORNFLOWER_BLUE]" + str(multiplayer.get_unique_id()) + " L_hitstun: " + str(hitstun))
	#print_rich("[color=RED]L_current_frame: " + str(current_frame))
	#print_rich("[color=CORNFLOWER_BLUE]" + str(multiplayer.get_unique_id()) + " L_current_state: [color=RED]" + state_machine.current_state.state_name)
	
