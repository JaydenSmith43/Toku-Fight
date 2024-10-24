class_name Pushout
extends Area3D

@export var character : CharacterBody3D
var otherPlayer : CharacterBody3D

var colliding = false

func _ready() -> void:
	if (get_parent().get_parent().is_in_group("player1")):
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]

func _physics_process(_delta: float) -> void:
	if colliding:
		if character.left_side:
			if !character.jump:
				character.velocity.x -= 3
				character.move_and_slide()
		else:
			if !character.jump:
				character.velocity.x += 3
				character.move_and_slide()
	#print("velocity: " + str(character.velocity.x))

func _on_area_entered(_area: Area3D) -> void:
	colliding = true


func _on_area_exited(_area: Area3D) -> void:
	colliding = false
