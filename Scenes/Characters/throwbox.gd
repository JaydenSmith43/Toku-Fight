extends Area3D

@export var character : CharacterBody3D
@export var state_machine : Node

func _ready() -> void:
	connect("area_entered", self._on_area_entered)


func _on_area_entered(throw : Throw) -> void:
	if throw == null:
		return
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "thrown")
