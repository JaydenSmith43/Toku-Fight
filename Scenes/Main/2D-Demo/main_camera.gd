extends Camera3D

@export var character1 : CharacterBody3D
@export var character2 : CharacterBody3D

func _physics_process(delta):
	var distance = character1.position.x - character2.position.x
	var midpoint = (character1.position.x + character2.position.x) / 2
	
	#print(distance)
	
	if distance < 0:
		distance *= -1
	
	if midpoint < 38 && midpoint > -38:
		#position.x = lerp(position.x, midpoint, delta * 10)
		position.x = midpoint
	
	#if distance < 40:
	#position.x = midpoint
	
	