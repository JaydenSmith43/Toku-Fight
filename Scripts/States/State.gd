extends Node
class_name State

signal Transitioned

@export var character : CharacterBody3D
@export var model : Node3D
@onready var attack_timer : Timer = $"../../AttackTimer" #TODO get rid of this
@onready var anim_player : NetworkAnimationPlayer = $"../../model/AnimationPlayer"


func Enter():
	pass

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(input: Dictionary):
	pass
