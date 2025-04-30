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
	
	var player_right_extent = character.fixed_position_x + collision_area.shape.extents_x
	var player_left_extent = character.fixed_position_x - collision_area.shape.extents_x
	
	var opposing_right_extent = opposingPlayer.fixed_position_x + collision_area.shape.extents_x
	var opposing_left_extent = opposingPlayer.fixed_position_x - collision_area.shape.extents_x
	
	var left_push_check = player_right_extent - opposing_left_extent
	var right_push_check = opposing_right_extent - player_left_extent
	
	#print(left_push_check)
	#print(right_push_check)
	
	var characterVelocityX = 0
	var opposingVelocityX = 0
	
	if left_push_check < right_push_check:
		#print("left")
		characterVelocityX = -left_push_check / 2
		opposingVelocityX = left_push_check / 2
	elif right_push_check < left_push_check:
		#print("right")
		characterVelocityX = right_push_check / 2
		opposingVelocityX = -right_push_check / 2
	
	var current_state_name = character.state_machine.current_state.state_name
	var opposing_state_name = opposingPlayer.state_machine.current_state.state_name
	
	character.move_and_collide(SGFixed.vector2(characterVelocityX, 0))
	opposingPlayer.move_and_collide(SGFixed.vector2(opposingVelocityX, 0))
	#opposingPlayer.move_and_slide()
	#character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
