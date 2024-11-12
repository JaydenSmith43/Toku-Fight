extends SGPhysicsBody2D

@export var character1 : SGCharacterBody2D
@export var character2 : SGCharacterBody2D

#Get characters after stage load

func _physics_process(delta):
	var distance = character1.fixed_position_x - character2.fixed_position_x
	var midpoint = SGFixed.div(character1.fixed_position_x + character2.fixed_position_x, 131072)
	
	
	if distance < 0:
		distance *= -1
	
	#if distance < 20:
	
	fixed_position.x = midpoint
	
	
	sync_to_physics_engine()
