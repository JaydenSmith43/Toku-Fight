class_name Hurtbox
extends Area3D

@export var character : CharacterBody3D
@export var state_machine : Node

func _init() -> void:
	pass

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox : Hitbox3D) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage") and character.blocking == true:
		state_machine.current_state.Transitioned.emit(state_machine.current_state, "block")
		hitbox.queue_free()
	elif owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		hitbox.queue_free() #if hitboxes are grouped, delete the others in the group