extends SGArea2D

@export var moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if moving == true:
		fixed_position_x += 5000
	
	sync_to_physics_engine()
