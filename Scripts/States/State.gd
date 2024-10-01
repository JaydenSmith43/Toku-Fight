extends Node
class_name State

signal Transitioned

@export var character : CharacterBody2D

@onready var sprite : AnimatedSprite2D = $"../../Sprite"
@onready var attack_timer : Timer = $"../../AttackTimer"

func Enter():
	pass

func Exit():
	pass

func State_Update(_delta: float):
	pass

func State_Physics_Update(_delta: float):
	pass
