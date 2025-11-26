extends Node
class_name State

signal Transitioned

@export var character : CharacterData
@export var model : Node3D
@export var state_name : String
@onready var attack_timer : Timer = $"../../AttackTimer" #TODO get rid of this
@onready var anim_player : NetworkAnimationPlayer = $"../../model/AnimationPlayer"
@onready var input_array = $"../../Input"

func Enter():
	pass

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_input: Dictionary):
	pass
