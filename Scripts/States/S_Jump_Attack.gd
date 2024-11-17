extends State
class_name S_JumpAttack

#var played : bool = false
var move_end_frame = 30
var hitbox = preload("res://Scenes/Characters/hitbox2d.tscn")
var anim_name := ""
var player_group := ""

var hitstun : int = 0
var blockstun : int = 0
var sfx : String = ""

func Enter():
	character.current_frame = 0
	#load cancel properties

func Exit():
	character.current_frame = 0
	pass

func State_Physics_Update(input: Dictionary):
	character.current_frame += 1
	character.velocity.y += 2229
	
	if character.jump_velocity_x > 0:
		character.velocity.x = character.jump_velocity_x + (2184)
	elif character.jump_velocity_x < 0:
		character.velocity.x = character.jump_velocity_x - (2184)
		pass
	
	character.move_and_slide()
	model.position.x = SGFixed.to_float(character.fixed_position_x)
	model.position.y = -SGFixed.to_float(character.fixed_position_y)
	
	if character.is_on_floor():
		Transitioned.emit(self, "idle")
		return

	if character.get_groups()[0] == "player1":
		StaticData.load_json_file(character.move_name, character.get_groups()[0])
		anim_name = StaticData.P1_move_data["anim_name"]
		move_end_frame = StaticData.P1_move_data["move_end_frame"]
	else:
		StaticData.load_json_file(character.move_name, character.get_groups()[0])
		anim_name = StaticData.P2_move_data["anim_name"]
		move_end_frame = StaticData.P2_move_data["move_end_frame"]
	anim_player.play(anim_name)
	
	Attack.check_cancel(character, input, "jump")
	
	if character.get_groups()[0] == "player1":
		if character.current_frame >= StaticData.P1_move_data["cancel_frame"] and character.buffered_move != "":
			character.cancel = false
			Attack.do_jump_attack(character, character.buffered_move)
	else:
		if character.current_frame >= StaticData.P2_move_data["cancel_frame"] and character.buffered_move != "":
			character.cancel = false
			Attack.do_jump_attack(character, character.buffered_move)
	
	check_frame()
	
	
	if character.current_frame >= move_end_frame:
		if character.get_groups()[0] == "player1":
			StaticData.current_move_p1 = ""
		else:
			StaticData.current_move_p2 = ""
		character.cancel = false
		character.current_frame = 0
		
		character.move_name = "idle"
		Transitioned.emit(self, "idle")

func check_frame():
	if character.get_groups()[0] == "player1":
		for data in StaticData.P1_move_data["frames"]:
			if character.current_frame == data["frame"]:
				hitstun = data["hitstun"]
				blockstun = data["blockstun"]
				
				var hitbox_string = "hitbox"
				var hitbox_index = 1
				var hitbox_input = hitbox_string + str(hitbox_index)
			
				while data.has(hitbox_input):
					create_hitbox(data[hitbox_input])
					hitbox_index += 1
					hitbox_input = hitbox_string + str(hitbox_index)
	else:
		for data in StaticData.P2_move_data["frames"]:
			if character.current_frame == data["frame"]:
				hitstun = data["hitstun"]
				blockstun = data["blockstun"]
				sfx = data['sfx']
				
				var hitbox_string = "hitbox"
				var hitbox_index = 1
				var hitbox_input = hitbox_string + str(hitbox_index)
			
				while data.has(hitbox_input):
					create_hitbox(data[hitbox_input])
					hitbox_index += 1
					hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox(data):
	var player : String
	if character.is_in_group("player1"):
		player = "player1"
	else:
		player = "player2"
	
	SyncManager.spawn("Hitbox", get_parent().get_parent(), hitbox, { 
		damage = data["damage"],
		end_frame = data["end_frame"],
		fixed_pos_x = SGFixed.from_float(data["pos_x"]),
		fixed_pos_y = -SGFixed.from_float(data["pos_y"]),
		extents_x = SGFixed.div(SGFixed.from_float(data["scale_x"]), 131072),
		extents_y = SGFixed.div(SGFixed.from_float(data["scale_y"]), 131072),
		height = data['height'],
		sfx = sfx,
		hitstun = hitstun,
		blockstun = blockstun,
		player = player,
		character = character,
		left_side = character.left_side
	})
