extends Node

var moveData = {}

var data_file_path = ""

#func _ready():
	#moveData = load_json_file(data_file_path)

func load_json_file(fileName : String):
	data_file_path = "res://Scripts/Data/" + fileName + ".json"
	
	if FileAccess.file_exists(data_file_path):
		var dataFile = FileAccess.open(data_file_path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			moveData = parsedResult
		else:
			print("Error reading file!")
	else:
		print("File doesn't exist!")
