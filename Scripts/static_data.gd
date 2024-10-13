extends Node

var P1_move_data = {}
var P2_move_data = {}

var data_file_path = ""

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
