extends StaticBody2D

@export var character1 : Node2D
@export var character2 : Node2D

func _physics_process(delta):
	var distance = character1.position.x - character2.position.x
	var midpoint = (character1.position.x + character2.position.x) / 2
	
	if distance < 0:
		distance *= -1
	
	if distance < 890:
		position.x = midpoint
