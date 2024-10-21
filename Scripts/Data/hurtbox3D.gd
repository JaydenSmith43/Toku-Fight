class_name Hurtbox
extends Area3D

@export var character : CharacterBody3D

func _init() -> void:
	pass

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox : Hitbox3D) -> void:
	if hitbox == null:
		return
	
	if hitbox.height == "low" and character.low_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "high" and character.high_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "mid" and character.high_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "mid" and character.low_blocking == true:
		block(hitbox)
		pass
	elif owner.has_method("take_damage"):
		hit(hitbox)

func block(hitbox: Hitbox3D):
	character.blockstun = hitbox.blockstun
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "block")
	hitbox.queue_free()

func hit(hitbox: Hitbox3D):
	owner.take_damage(hitbox.damage)
	character.hitstun = hitbox.hitstun
	character.height_hit = hitbox.height
	
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "hitstun")
	hitbox.queue_free() #if hitboxes are grouped, delete the others in the group
