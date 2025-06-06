class_name Throw2D
extends SGArea2D

signal tell_script(left_side, extents_x, extents_y)

@export var timer : NetworkTimer

var left_side := true
var player := ""
var extents_x := 0.0
var extents_y := 0.0
var end_frame := 5
var techable := false

func net_ready() -> void:
	if player == "player2":
		set_collision_layer_bit(7, false)
		set_collision_mask_bit(6, false)
		set_collision_layer_bit(8, true)
		set_collision_mask_bit(5, true)
	tell_script.emit(left_side, extents_x, extents_y)
	timer.wait_ticks = end_frame
	timer.start()
	sync_to_physics_engine()

func _network_spawn(data: Dictionary) -> void:
	#damage = data['damage']
	end_frame = data['end_frame']
	left_side = data['left_side']
	
	if left_side == true:
		fixed_position_x = data['fixed_pos_x']
	else:
		fixed_position_x = -data['fixed_pos_x']
	
	fixed_position_y = data['fixed_pos_y']
	extents_x = data['extents_x']
	extents_y = data['extents_y']
	player = data['player']

	techable = data['techable']
	net_ready()

func _on_network_timer_timeout() -> void:
	SyncManager.despawn(self)
