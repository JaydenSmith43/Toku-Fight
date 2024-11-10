class_name Hurtbox2D
extends SGArea2D

@export var character : SGCharacterBody2D

#const sfx_light = preload("res://SFX/HitFX/light_hit.wav")

func _ready():
	connect("area_entered", self._on_area_entered)
	
	if character.is_in_group("player2"):
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(4, false)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(3, true)
	sync_to_physics_engine()

func tick_physics_process() -> void:
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		overlapping_areas[0].timer.wait_ticks = 0
		_on_area_entered(overlapping_areas[0])
		#SyncManager.despawn(overlapping_areas[0])
		
		#overlapping_areas[0].queue_free()
		#SyncManager.despawn(overlapping_areas[0])
		#overlapping_areas[0]._on_network_timer_timeout()
	#sync_to_physics_engine()

func _on_area_entered(hitbox : Hitbox2D) -> void:
	if hitbox == null:
		return
	
	if hitbox.height == "low" and character.low_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "high" and character.high_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "mid" and character.high_blocking == true:
		block(hitbox)
		pass
	elif hitbox.height == "mid" and character.low_blocking == true:
		block(hitbox)
		pass
	elif owner.has_method("take_damage"):
		hit(hitbox)

func block(hitbox: Hitbox2D):
	character.blockstun = hitbox.blockstun
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "block")
	SyncManager.despawn(hitbox)

func hit(hitbox: Hitbox2D):
	owner.take_damage(hitbox.damage)
	character.hitstun = hitbox.hitstun
	character.height_hit = hitbox.height
	
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "hitstun")
	SyncManager.despawn(hitbox) #if hitboxes are grouped, delete the others in the group
	choose_random_sound()
	

func choose_random_sound():
	
	SyncManager.play_sound(str(get_path()) + ":light_hit", sfx_light)
