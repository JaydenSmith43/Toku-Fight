extends CharacterBody3D

@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel

var health : int = 100

func _ready():
	healthbar.init_health(health)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180
		#label.position.x = 1000
		#print(label.position.x)

#func _physics_process(_delta):
	#print(health)

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)
