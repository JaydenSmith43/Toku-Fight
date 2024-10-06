extends StaticBody3D

@export var character1 : Node3D
@export var character2 : Node3D

#Get characters after stage load

func _physics_process(delta):
	var distance = character1.position.x - character2.position.x
	var midpoint = (character1.position.x + character2.position.x) / 2
	
	if distance < 0:
		distance *= -1
	
	if distance < 890:
		position.x = midpoint
