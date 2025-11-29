extends State
class_name S_GroundAttack

var hitbox = preload("res://Scenes/Characters/hitbox2d.tscn")

var anim_name := ""
var player_group := ""

var move_end_frame = 0
var sfx : String = ""
var hitstop_frame = 0
var hitstop_over = true

func Enter():
	character.current_frame = 0
	#load cancel properties

func Exit():
	character.current_frame = 0

func State_Physics_Update(input: Dictionary):
	if character.cancel and character.hitstop != 0:
		hitstop_over = false
		anim_player.speed_scale = 0
		hitstop_frame += 1
		if hitstop_frame == character.hitstop and hitstop_over == false:
			hitstop_frame = 0
			character.hitstop = 0
			hitstop_over = true
			anim_player.speed_scale = 1
	elif hitstop_over:
		character.current_frame += 1
		
		if character.get_groups()[0] == "player1":
			StaticData.load_json_file(character.character_name, character.move_name, character.get_groups()[0])
			anim_name = StaticData.P1_move_data["anim_name"]
			move_end_frame = StaticData.P1_move_data["move_end_frame"]
		else:
			StaticData.load_json_file(character.character_name, character.move_name, character.get_groups()[0])
			anim_name = StaticData.P2_move_data["anim_name"]
			move_end_frame = StaticData.P2_move_data["move_end_frame"]
		#if character.game_manager.pause
		anim_player.play(anim_name)
		
		check_player_frame()
		
	Attack.check_cancel(character, input, input_array, "ground") #TODO fix the no buffer during hitstop
		
	if character.get_groups()[0] == "player1":
		check_cancel_window(StaticData.P1_move_data)
	else:
		check_cancel_window(StaticData.P2_move_data)
		
	if character.current_frame >= move_end_frame:
		if character.get_groups()[0] == "player1":
			StaticData.current_move_p1 = ""
		else:
			StaticData.current_move_p2 = ""
		character.cancel = false
		character.current_frame = 0
		
		character.move_name = "idle"
		Transitioned.emit(self, "idle")

func enter_hitstop():
	
	return

func check_cancel_window(move_data):
	if character.current_frame >= move_data["cancel_frame"] and character.buffered_move != "":
		character.cancel = false
		anim_player.stop()
		Attack.do_ground_attack(character, character.buffered_move)

func check_player_frame():
	if character.get_groups()[0] == "player1":
		for data in StaticData.P1_move_data["frames"]:
			check_for_box_on_frame(data)
	else:
		for data in StaticData.P2_move_data["frames"]:
			check_for_box_on_frame(data)

func check_for_box_on_frame(data):
	if character.current_frame == data["frame"]:
		sfx = data["sfx"]
		
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
		hitstun = hitbox_data['hitstun'],
		blockstun = hitbox_data['blockstun'],
		player = player,
		character = character,
		left_side = character.left_side
	})
