extends CharacterBody3D

@onready var healthbar = $UI/HealthBar
@onready var label = $UI/HealthBar/StateLabel
@onready var hurtbox = $Hurtbox
@onready var collision = $collision

var health := 100
var leftside := false
var low_blocking := false
var high_blocking := false
var crouch := false
var jump := false
var movename := "null"
var hitstun := 0
var blockstun := 0
var height_hit := ""
var colliding := false
var jump_velocity = 0

var frame_loop = 0

func _ready():
	healthbar.init_health(health)
	
	if is_in_group("player2"):
		healthbar.position.x = 1100
		healthbar.rotation_degrees = 180
		
		hurtbox.set_collision_layer_value(2, false) #TODO TODO TODO TODO move to hurtbox initialization
		hurtbox.set_collision_mask_value(5, false)
		hurtbox.set_collision_layer_value(3, true)
		hurtbox.set_collision_mask_value(4, true)

func take_damage(damage : int):
	health -= damage
	healthbar._set_health(health)

#func _physics_process(delta: float) -> void:
	#frame_loop += 1
	#if frame_loop > 60:
		#frame_loop = 1
	#
	#print(str(frame_loop) + ": " + str(velocity.x))
