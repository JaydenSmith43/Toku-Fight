extends SGArea2D

@export var character : SGCharacterBody2D

func tick_physics_process() -> void:
	sync_to_physics_engine()
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		_on_area_entered(overlapping_areas[0])

func _on_area_entered(pushbox : SGArea2D):
	fixed_position_x = 0
	return
