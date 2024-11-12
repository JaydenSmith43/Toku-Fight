extends Node

var P1_move_data = {}
var P2_move_data = {}

var data_file_path = ""
var current_move_p1
var current_move_p2

func load_json_file(fileName : String, player : String):
	data_file_path = "res://Scripts/MoveData/" + fileName + ".json"
	
	if FileAccess.file_exists(data_file_path):
		var dataFile = FileAccess.open(data_file_path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			if player == "player1":
				P1_move_data = parsedResult
			else:
				P2_move_data = parsedResult
		else:
			print("Error reading file!")
	else:
		print("File doesn't exist!")

func check_new_move(fileName : String, player : String):
	var move_already_loaded = false
	
	if player == "player1" and fileName != current_move_p1:
		load_json_file(fileName, player)
	elif player == "player2"  and fileName != current_move_p2:
		load_json_file(fileName, player)
	
