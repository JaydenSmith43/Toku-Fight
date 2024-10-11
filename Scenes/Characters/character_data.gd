extends CharacterBody3D

@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel
@onready var hurtbox = $Hurtbox

var health := 100
var leftside := false
var blocking := false
var crouch := false
var movename := "null"

func _ready():
	healthbar.init_health(health)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180
		#label.position.x = 1000 #TODO TODO TODO TODO TODO
		#print(label.position.x)
		
		hurtbox.set_collision_layer_value(2, false)
		hurtbox.set_collision_mask_value(5, false)
		hurtbox.set_collision_layer_value(3, true)
		hurtbox.set_collision_mask_value(4, true)

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)
