class_name Hurtbox
extends Area2D

func _init() -> void:
	pass

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox : Hitbox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"): #duck typing
		owner.take_damage(hitbox.damage)
