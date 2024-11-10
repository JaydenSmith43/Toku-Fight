extends SGArea2D

@export var character : SGCharacterBody2D
@export var state_machine : Node

func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
	if character.is_in_group("player2"):
		set_collision_layer_bit(6, false)
		set_collision_mask_bit(9, true)
		set_collision_layer_bit(7, false)
		set_collision_mask_bit(8, true)

func _on_area_entered(throw : Throw) -> void:
	if throw == null:
		return
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")
