extends Camera2D

@export var character1 : CharacterBody2D
@export var character2 : CharacterBody2D

func _physics_process(delta):
	var distance = character1.position.x - character2.position.x
	var midpoint = (character1.position.x + character2.position.x) / 2
	
	if distance < 0:
		distance *= -1
	
	if distance < 890:
		position.x = lerp(position.x, midpoint, delta * 40)
		#position.x = midpoint
