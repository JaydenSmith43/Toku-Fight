extends State
class_name S_Grapplerj214

var hitbox = preload("res://Scenes/Characters/hitbox2d.tscn")

var velocity_x

var otherPlayer : SGCharacterBody2D

func Enter():
	character.current_frame = 0
	character.velocity.x = 0
	character.velocity.y = 0
	anim_player.play("divekick")
	
	if character.is_in_group("player1"):	
		otherPlayer = get_tree().get_nodes_in_group("player2")[0]
	else:
		otherPlayer = get_tree().get_nodes_in_group("player1")[0]

func Exit():
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	if character.current_frame == 1:
		if (character.fixed_position.x - otherPlayer.fixed_position.x < 0):
			character.left_side = true
		else:
			character.left_side = false
		
		if character.left_side:
			velocity_x = 20000
		else:
			velocity_x = -20000
	
	if character.current_frame >= 20:
		character.velocity.x = velocity_x
		character.velocity.y = 30000
	
	if character.current_frame == 20:
		spawn_hitbox()
	
	if character.current_frame == 26:
		spawn_hitbox()
	
	if character.current_frame == 32:
		spawn_hitbox()
	
	if character.current_frame == 38:
		spawn_hitbox()
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.is_on_floor():
		Transitioned.emit(self, "idle")
		return

func spawn_hitbox():
	SyncManager.spawn("Hitbox", get_parent().get_parent(), hitbox, { 
		damage = 1,
		end_frame = 5,
		fixed_pos_x = SGFixed.from_float(2),
		fixed_pos_y = -SGFixed.from_float(-3),
		extents_x = SGFixed.div(SGFixed.from_float(1), 131072),
		extents_y = SGFixed.div(SGFixed.from_float(1), 131072),
		height = "high",
		sfx = "light",
		hitstun = 20,
		blockstun = 10,
		player = character.get_groups()[1],
		character = character,
		left_side = character.left_side
	})
