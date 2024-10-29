extends Area3D

@export var character : CharacterBody3D
@export var state_machine : Node

func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
	#if character.is_in_group("player2"): ###TODO TODO TODO TODO TODO
	#	set_collision_layer_value(6, false)
	#	set_collision_mask_value(9, true)
	#	set_collision_layer_value(7, false)
	#	set_collision_mask_value(8, true)
	#	pass

func _on_area_entered(throw : Throw) -> void:
	if throw == null:
		return
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")
