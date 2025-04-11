extends SGArea2D

@export var character : SGCharacterBody2D
@export var collision_area : SGCollisionShape2D
@export var model : Node3D
var opposingPlayer : SGCharacterBody2D

func tick_physics_process() -> void:
	sync_to_physics_engine()
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		_on_area_entered(overlapping_areas[0])

func _on_area_entered(pushbox : SGArea2D):
	if character.is_in_group("player1"):
		opposingPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		opposingPlayer = get_tree().get_nodes_in_group("player1")[0]
	
	#print(character.fixed_position_x)
	#print(collision_area.shape.extents_x)
	
	var player_right_extent = character.fixed_position_x + collision_area.shape.extents_x
	var player_left_extent = character.fixed_position_x - collision_area.shape.extents_x
	
	var opposing_right_extent = opposingPlayer.fixed_position_x + collision_area.shape.extents_x
	var opposing_left_extent = opposingPlayer.fixed_position_x - collision_area.shape.extents_x
	
	var left_push_check = player_right_extent - opposing_left_extent
	var right_push_check = opposing_right_extent - player_left_extent
	print(left_push_check)
	print(right_push_check)
	
	if left_push_check < right_push_check:
		print("left")
		character.fixed_position_x -= left_push_check
		opposingPlayer.fixed_position_x += left_push_check
	elif right_push_check < left_push_check:
		print("right")
		character.fixed_position_x += right_push_check
		opposingPlayer.fixed_position_x -= right_push_check
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	#player_pos = 1
	#player_right = 2
	#player_left = 0
	
	#player_pos = 4
	#player_right = 5
	#player_left = 3
