class_name Hurtbox2D
extends SGArea2D

@export var character : SGCharacterBody2D

const SFX_LIGHT_1 = preload("res://SFX/Combat/hit_light/hit_light_1.mp3")
const SFX_LIGHT_2 = preload("res://SFX/Combat/hit_light/hit_light_2.mp3")
const SFX_LIGHT_3 = preload("res://SFX/Combat/hit_light/hit_light_3.mp3")
const SFX_MEDIUM_1 = preload("res://SFX/Combat/hit_medium/hit_medium_1.mp3")
const SFX_MEDIUM_2 = preload("res://SFX/Combat/hit_medium/hit_medium_2.mp3")
const SFX_MEDIUM_3 = preload("res://SFX/Combat/hit_medium/hit_medium_3.mp3")
const SFX_HEAVY_1 = preload("res://SFX/Combat/hit_heavy/hit_heavy_1.mp3")
const SFX_HEAVY_2 = preload("res://SFX/Combat/hit_heavy/hit_heavy_2.mp3")
const SFX_HEAVY_3 = preload("res://SFX/Combat/hit_heavy/hit_heavy_3.mp3")
const SFX_BLOCK_1 = preload("res://SFX/Combat/block/block_1.mp3")
const SFX_BLOCK_2 = preload("res://SFX/Combat/block/block_2.mp3")
const SFX_BLOCK_3 = preload("res://SFX/Combat/block/block_3.mp3")

const hit_particle = preload("res://Scenes/effects/hit_particle.tscn")

func _ready():
	if character.is_in_group("player2"):
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(4, false)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(3, true)
	sync_to_physics_engine()

func tick_physics_process() -> void:
	sync_to_physics_engine()
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		_on_area_entered(overlapping_areas[0])
	#elif character.is_in_group("player2"):
		#print("no overlap")

func _on_area_entered(hitbox : Hitbox2D) -> void:
	if hitbox == null or !character.hittable:
		return
	
	if hitbox.height == "low" and character.low_blocking == true:
		block(hitbox)
		block_sound()
		pass
	elif hitbox.height == "high" and character.high_blocking == true:
		block(hitbox)
		block_sound()
		pass
	elif hitbox.height == "mid" and character.high_blocking == true:
		block(hitbox)
		block_sound()
		pass
	elif hitbox.height == "mid" and character.low_blocking == true:
		block(hitbox)
		block_sound()
		pass
	elif owner.has_method("take_damage"):
		hit(hitbox)

func block(hitbox: Hitbox2D):
	character.blockstun = hitbox.blockstun
	character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "block")
	SyncManager.despawn(hitbox)

func hit(hitbox: Hitbox2D):
	#print(str(multiplayer.multiplayer_peer.get_unique_id()) + ":current_frame: " + str(character.current_frame) + ": hit")
	if character.is_in_group("player1"):
		get_tree().get_nodes_in_group("player2")[0].cancel = true
	else:
		get_tree().get_nodes_in_group("player1")[0].cancel = true
	
	owner.take_damage(hitbox.damage)
	
	character.hitstun = hitbox.hitstun
	character.height_hit = hitbox.height
	
	var current_state_name = character.state_machine.current_state.state_name
	if current_state_name == "juggle" or current_state_name == "jump" or current_state_name == "jumpattack":
		character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "juggle")
	else:
		character.state_machine.current_state.Transitioned.emit(character.state_machine.current_state, "hitstun")
	
	SyncManager.despawn(hitbox) #if hitboxes are grouped, delete the others in the group
	#SyncManager.spawn("hit_particle", get_parent().get_parent(), hit_particle)
	choose_hit_sound(hitbox.sfx)
	

func choose_hit_sound(effect : String):
	match effect:
		"light":
			var random = randi_range(0, 2)
			match random:
				0:
					SyncManager.play_sound(str(get_path()) + ":light_hit", SFX_LIGHT_1)
				1:
					SyncManager.play_sound(str(get_path()) + ":light_hit", SFX_LIGHT_2)
				2:
					SyncManager.play_sound(str(get_path()) + ":light_hit", SFX_LIGHT_3)
		"medium":
			var random = randi_range(0, 2)
			match random:
				0:
					SyncManager.play_sound(str(get_path()) + ":medium_hit", SFX_MEDIUM_1)
				1:
					SyncManager.play_sound(str(get_path()) + ":medium_hit", SFX_MEDIUM_2)
				2:
					SyncManager.play_sound(str(get_path()) + ":medium_hit", SFX_MEDIUM_3)
		"heavy":
			var random = randi_range(0, 2)
			match random:
				0:
					SyncManager.play_sound(str(get_path()) + ":heavy_hit", SFX_HEAVY_1)
				1:
					SyncManager.play_sound(str(get_path()) + ":heavy_hit", SFX_HEAVY_2)
				2:
					SyncManager.play_sound(str(get_path()) + ":heavy_hit", SFX_HEAVY_3)

func block_sound():
	var random = randi_range(0, 2)
	match random:
		0:
			SyncManager.play_sound(str(get_path()) + ":block", SFX_BLOCK_1)
		1:
			SyncManager.play_sound(str(get_path()) + ":block", SFX_BLOCK_2)
		2:
			SyncManager.play_sound(str(get_path()) + ":block", SFX_BLOCK_3)
