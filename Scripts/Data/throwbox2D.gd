extends SGArea2D

@export var character : SGCharacterBody2D
@export var state_machine : Node

func _ready() -> void:
	if character.is_in_group("player2"):
		set_collision_layer_bit(5, false)
		set_collision_mask_bit(8, false)
		set_collision_layer_bit(6, true)
		set_collision_mask_bit(7, true)
	sync_to_physics_engine()

func tick_physics_process() -> void:
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		overlapping_areas[0].timer.wait_ticks = 0
		_on_area_entered(overlapping_areas[0])

func _on_area_entered(throw : Throw2D) -> void:
	if throw == null:
		return
	SyncManager.despawn(throw)
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")
