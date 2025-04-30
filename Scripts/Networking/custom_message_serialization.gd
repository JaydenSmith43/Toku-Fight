extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"

const input_path_mapping := {
	'/root/Node3D/Game/test1': 1,
	'/root/Node3D/Game/test2': 2
}

enum HeaderFlags {
	HAS_INPUT_VECTOR = 0x01,
	PRESS_A = 0x02,
	PRESS_B = 0x04,
	PRESS_C = 0x08
}

var input_path_mapping_reverse := {}

func _init() -> void:
	for key in input_path_mapping:
		input_path_mapping_reverse[input_path_mapping[key]] = key

func serialize_input(all_input: Dictionary) -> PackedByteArray:
	var buffer := StreamPeerBuffer.new()
	buffer.resize(128)
	
	buffer.put_u32(all_input['$']) #4 bytes
	buffer.put_u8(all_input.size() - 1) #1 byte
	
	for path in all_input:
		if path == '$':
			continue
		buffer.put_u8(input_path_mapping[path]) #1 byte
		
		var header := 0
		
		var input = all_input[path]
		if input.has('input_vector'):
			header |= HeaderFlags.HAS_INPUT_VECTOR #1 byte
		if input.get('a', false):
			header |= HeaderFlags.PRESS_A #1 byte
		if input.get('b', false):
			header |= HeaderFlags.PRESS_B #1 byte
		if input.get('c', false):
			header |= HeaderFlags.PRESS_C #1 byte
		
		buffer.put_u8(header)
		
		if input.has('input_vector'):
			var input_vector: Vector2i = input['input_vector']
			buffer.put_float(input_vector.x) #4 bytes
			buffer.put_float(input_vector.y) #4 bytes
	
	buffer.resize(buffer.get_position())
	return buffer.data_array

func unserialize_input(serialized: PackedByteArray) -> Dictionary:
	var buffer := StreamPeerBuffer.new()
	buffer.put_data(serialized)
	buffer.seek(0)
	
	var all_input := {}
	
	all_input['$'] = buffer.get_u32()
	
	var input_count = buffer.get_u8()
	if input_count == 0:
		return all_input
	
	var path = input_path_mapping_reverse[buffer.get_u8()]
	var input := {}
	
	var header = buffer.get_u8()
	if header & HeaderFlags.HAS_INPUT_VECTOR:
		input['input_vector'] = Vector2i(buffer.get_float(), buffer.get_float())
	if header & HeaderFlags.PRESS_A:
		input['a'] = true
	if header & HeaderFlags.PRESS_B:
		input['b'] = true
	if header & HeaderFlags.PRESS_C:
		input['c'] = true
	
	all_input[path] = input
	return all_input
