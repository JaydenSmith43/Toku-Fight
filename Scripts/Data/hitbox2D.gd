class_name Hitbox2D
extends SGArea2D

signal tell_script(left_side, fixed_pos_x, fixed_pos_y, extents_x, extents_y)

@export var timer : NetworkTimer
@onready var collision_shape = $SGCollisionShape2D

var damage := 10
var height = "mid"
var sfx = ""
var left_side := true
var player := ""
var extents_x := 293610
var extents_y := 228220
var fixed_pos_x := 0
var fixed_pos_y := 0
var end_frame := 6000
var hitstun := 0
var blockstun := 0

func net_ready() -> void:
	#print("ready hitbox")
	if player == "player2":
		set_collision_layer_bit(3, false)
		set_collision_mask_bit(2, false)
		set_collision_layer_bit(4, true)
		set_collision_mask_bit(1, true)
		remove_from_group("p1_hitbox")
		add_to_group("p2_hitbox")
	tell_script.emit(left_side, fixed_pos_x, fixed_pos_y, extents_x, extents_y)
	timer.wait_ticks = end_frame
	timer.start()
	sync_to_physics_engine()

func tick_physics_process() -> void:
	sync_to_physics_engine()

func _network_spawn(data: Dictionary) -> void:
	damage = data['damage']
	end_frame = data['end_frame']
	fixed_pos_x = data['fixed_pos_x']
	fixed_pos_y = data['fixed_pos_y']
	extents_x = data['extents_x']
	extents_y = data['extents_y']
	height = data['height']
	sfx = data['sfx']
	hitstun = data['hitstun']
	blockstun = data['blockstun']
	player = data['player']
	left_side = data['left_side']
	net_ready()

func _on_network_timer_timeout() -> void:
	SyncManager.despawn(self)
