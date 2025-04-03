extends Node

var P1_move_data = {}
var P2_move_data = {}

var data_file_path = ""
var current_move_p1
var current_move_p2

func load_json_file(characterName: String, fileName: String, player: String):
	data_file_path = "res://Scripts/MoveData/" + characterName + "/" + fileName + ".json"
	var parsedResult
	
	var dataFile = FileAccess.open(data_file_path, FileAccess.READ)
	if !FileAccess.file_exists(data_file_path):
		print("Creating new file: " + data_file_path)
	else:
		parsedResult = JSON.parse_string(dataFile.get_as_text())
	
	if parsedResult is Dictionary:
		if player == "player1":
			P1_move_data = parsedResult
		else:
			P2_move_data = parsedResult
	else:
		print("Error reading file!")

func check_new_move(characterName: String, fileName: String, player: String):
	#var move_already_loaded = false
	
	if player == "player1" and fileName != current_move_p1:
		load_json_file(characterName, fileName, player)
	elif player == "player2"  and fileName != current_move_p2:
		load_json_file(characterName, fileName, player)
	
