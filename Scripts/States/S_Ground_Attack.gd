extends State
class_name S_Attack

var played : bool = false
var current_frame = 0
var move_end_frame = 10
var hitbox = preload("res://Scenes/Characters/hitbox3d.tscn")
var anim_name := ""
var player_group := ""

var hitstun : int = 0
var blockstun : int = 0

#@export var animation_player : AnimationPlayer
#TODO SEND IN JSON DATA INTO THIS ATTACK STATE TO BE READ

func Enter():
	current_frame = 0
	played = false

	if character.get_groups()[0] == "player1":
		StaticData.load_json_file(character.movename, character.get_groups()[0]) #send in current character button from idle state
		anim_name = StaticData.P1_move_data["anim_name"]
		move_end_frame = StaticData.P1_move_data["move_end_frame"]
	else:
		StaticData.load_json_file(character.movename, character.get_groups()[0]) #send in current character button from idle state
		anim_name = StaticData.P2_move_data["anim_name"]
		move_end_frame = StaticData.P2_move_data["move_end_frame"]
	
	#load cancel properties

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	check_frame()
	
	if (!played):
		anim_player.play(anim_name)
		played = true
	
	if current_frame >= move_end_frame:
		character.movename = "idle"
		Transitioned.emit(self, "idle")

func check_frame():
	if character.get_groups()[0] == "player1":
		for data in StaticData.P1_move_data["frames"]:
			if current_frame == data["frame"]:
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
			if current_frame == data["frame"]:
				hitstun = data["hitstun"]
				blockstun = data["blockstun"]
				
				var hitbox_string = "hitbox"
				var hitbox_index = 1
				var hitbox_input = hitbox_string + str(hitbox_index)
			
				while data.has(hitbox_input):
					create_hitbox(data[hitbox_input])
					hitbox_index += 1
					hitbox_input = hitbox_string + str(hitbox_index)

func create_hitbox(data):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.damage = data["damage"]
	new_hitbox.end_frame = data["end_frame"]
	new_hitbox.pos_y = data["pos_y"]
	new_hitbox.pos_x = data["pos_x"]
	new_hitbox.scale_x = data["scale_x"]
	new_hitbox.scale_y = data["scale_y"]
	new_hitbox.height = data["height"]
	new_hitbox.hitstun = hitstun
	new_hitbox.blockstun = blockstun
	
	new_hitbox.leftside = character.leftside
		
	if character.is_in_group("player1"):
		new_hitbox.player = "player1"
	else:
		new_hitbox.player = "player2"
		
	get_parent().get_parent().add_child(new_hitbox)
	pass
