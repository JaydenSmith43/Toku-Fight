extends CharacterBody2D

@onready var healthbar = $UI/HealthBar

var health : int = 100

func _ready():
	healthbar.init_health(health)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180

func _physics_process(_delta):
	print(health)

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)
