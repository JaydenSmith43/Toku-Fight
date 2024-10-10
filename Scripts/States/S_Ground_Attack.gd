extends State
class_name S_Attack

var played : bool = false
var current_frame = 0
var move_end_frame = 10
var hitbox = preload("res://Scenes/Characters/hitbox3d.tscn")
var anim_name := ""
#var new_hitbox := Hitbox3D.new()

#@export var animation_player : AnimationPlayer
#TODO SEND IN JSON DATA INTO THIS ATTACK STATE TO BE READ

func Enter():
	current_frame = 0
	played = false
	
	StaticData.load_json_file("grappler_5a")
	anim_name = StaticData.moveData["anim_name"]
	move_end_frame = StaticData.moveData["move_end_frame"]
	#load cancel properties

func Exit():
	pass

func State_Physics_Update(_delta: float):
	current_frame += 1
	checkFrame()
	
	if (!played):
		anim_player.play(anim_name)
		played = true
	
	if current_frame >= move_end_frame:
		Transitioned.emit(self, "idle")

func checkFrame():
	for data in StaticData.moveData["frames"]:
		if current_frame == data["frame"]:
			var hitbox_string = "hitbox"
			var hitbox_index = 1
			var hitbox_input = hitbox_string + str(hitbox_index)
			
			while data.has(hitbox_input):
				createHitbox(data[hitbox_input])
				hitbox_index += 1
				hitbox_input = hitbox_string + str(hitbox_index)

func createHitbox(data):
	var new_hitbox = hitbox.instantiate()
	new_hitbox.damage = data["damage"]
	new_hitbox.end_frame = data["end_frame"]
	new_hitbox.pos_y = data["pos_y"]
	new_hitbox.pos_x = data["pos_x"]
	new_hitbox.scale_x = data["scale_x"]
	new_hitbox.scale_y = data["scale_y"]
	
	new_hitbox.leftside = character.leftside
		
	if character.is_in_group("player1"):
		new_hitbox.player = "player1"
	else:
		new_hitbox.player = "player2"
		
	get_parent().get_parent().add_child(new_hitbox)
	pass
