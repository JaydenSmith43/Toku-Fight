extends State
class_name S_GroundAttack

var hitbox = preload("res://Scenes/Characters/hitbox2d.tscn")

var anim_name := ""
var player_group := ""

var move_end_frame = 30
var hitstun : int = 0
var hitstop : int = 0
var blockstun : int = 0
var sfx : String = ""

func Enter():
	character.current_frame = 0
	#load cancel properties

func Exit():
	character.current_frame = 0

func State_Physics_Update(input: Dictionary):
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
	
	Attack.check_cancel(character, input, input_array, "ground")
	
	if character.get_groups()[0] == "player1":
		check_cancel_window(StaticData.P1_move_data)
	else:
		check_cancel_window(StaticData.P2_move_data)
	
	check_player_frame()
	
	if character.current_frame >= move_end_frame:
		if character.get_groups()[0] == "player1":
			StaticData.current_move_p1 = ""
		else:
			StaticData.current_move_p2 = ""
		character.cancel = false
		character.current_frame = 0
		
		character.move_name = "idle"
		Transitioned.emit(self, "idle")

func check_cancel_window(move_data):
	if character.current_frame >= move_data["cancel_frame"] and character.buffered_move != "":
		character.cancel = false
		anim_player.stop()
		Attack.do_ground_attack(character, character.buffered_move)

func check_player_frame():
	if character.get_groups()[0] == "player1":
		for data in StaticData.P1_move_data["frames"]:
			check_frame(data)
	else:
		for data in StaticData.P2_move_data["frames"]:
			check_frame(data)

func check_frame(data):
	if character.current_frame == data["frame"]:
		hitstun = data["hitstun"]
		hitstop = data["hitstop"]
		blockstun = data["blockstun"]
		
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
		hitstop = hitstop,
		blockstun = blockstun,
		player = player,
		character = character,
		left_side = character.left_side
	})
