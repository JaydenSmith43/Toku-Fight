extends State
class_name S_JumpAttack

#var played : bool = false
var move_end_frame = 30
var hitbox = preload("res://Scenes/Characters/hitbox2d.tscn")
var anim_name := ""
var player_group := ""

var sfx : String = ""

func Enter():
	character.current_frame = 0
	character.throw_invul = true
	#load cancel properties

func Exit():
	character.current_frame = 0
	character.throw_invul = false

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
		StaticData.load_json_file(character.character_name, character.move_name, character.get_groups()[0])
		anim_name = StaticData.P1_move_data["anim_name"]
		move_end_frame = StaticData.P1_move_data["move_end_frame"]
	else:
		StaticData.load_json_file(character.character_name, character.move_name, character.get_groups()[0])
		anim_name = StaticData.P2_move_data["anim_name"]
		move_end_frame = StaticData.P2_move_data["move_end_frame"]
	anim_player.play(anim_name)
	
	Attack.check_cancel(character, input, input_array, "jump")
	
	if character.get_groups()[0] == "player1":
		if character.current_frame >= StaticData.P1_move_data["cancel_frame"] and character.buffered_move != "":
			character.cancel = false
			Attack.do_jump_attack(character, character.buffered_move)
	else:
		if character.current_frame >= StaticData.P2_move_data["cancel_frame"] and character.buffered_move != "":
			character.cancel = false
			Attack.do_jump_attack(character, character.buffered_move)
	
	check_for_box_on_frame()
	
	if character.current_frame >= move_end_frame:
		if character.get_groups()[0] == "player1":
			StaticData.current_move_p1 = ""
		else:
			StaticData.current_move_p2 = ""
		character.cancel = false
		character.current_frame = 0
		
		character.move_name = "idle"
		Transitioned.emit(self, "idle")

func check_for_box_on_frame():
	if character.get_groups()[0] == "player1":
		for data in StaticData.P1_move_data["frames"]:
			if character.current_frame == data["frame"]:
				
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
				sfx = data['sfx']
				
				var hitbox_string = "hitbox"
				var hitbox_index = 1
				var hitbox_input = hitbox_string + str(hitbox_index)
			
				while data.has(hitbox_input):
					create_hitbox(data[hitbox_input])
					hitbox_index += 1
					hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox(hitbox_data):
	var player : String
	if character.is_in_group("player1"):
		player = "player1"
	else:
		player = "player2"
	
	SyncManager.spawn("Hitbox", get_parent().get_parent(), hitbox, { 
		damage = hitbox_data["damage"],
		end_frame = hitbox_data["end_frame"],
		fixed_pos_x = SGFixed.from_float(hitbox_data["pos_x"]),
		fixed_pos_y = -SGFixed.from_float(hitbox_data["pos_y"]),
		extents_x = SGFixed.div(SGFixed.from_float(hitbox_data["scale_x"]), 131072),
		extents_y = SGFixed.div(SGFixed.from_float(hitbox_data["scale_y"]), 131072),
		height = hitbox_data['height'],
		sfx = sfx,
		hitstop = hitbox_data['hitstop'],
		hitstun = hitbox_data["hitstun"],
		blockstun = hitbox_data["blockstun"],
		player = player,
		character = character,
		left_side = character.left_side
	})
