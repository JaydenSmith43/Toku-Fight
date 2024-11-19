extends Camera3D

@export var character1 : SGCharacterBody2D
@export var character2 : SGCharacterBody2D

var camera_state = "normal"

func _physics_process(delta):
	var distance = character1.position.x - character2.position.x
	var midpoint = (character1.position.x + character2.position.x) / 2
	
	#print(distance)
	
	if distance < 0:
		distance *= -1
	
	if midpoint < 38 && midpoint > -38:
		#position.x = lerp(position.x, midpoint, delta * 10)
		position.x = midpoint
	
	if character1.camera_state == "buster" or character2.camera_state == "buster":
		buster_y_tracking()
		return
	elif camera_state == "normal":
		normal_y_tracking()

func normal_y_tracking():
	if character1.fixed_position_y < character2.fixed_position_y:
		position.y = (-character1.position.y * 0.1) + 5
	else:
		position.y = (-character2.position.y * 0.1) + 5

func buster_y_tracking():
	position.y = -character1.position.y + 5
