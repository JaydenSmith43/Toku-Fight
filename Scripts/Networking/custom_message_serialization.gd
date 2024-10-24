extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"

const input_path_mapping := {
	'/root/Node3D/test1': 1,
	'/root/Node3D/test2': 2
}

enum HeaderFlags {
	HAS_INPUT_VECTOR = 0x01,
	HAS_A_BUTTON = 0x02,
	HAS_B_BUTTON = 0x03,
	HAS_C_BUTTON = 0x04
}

var input_path_mapping_reverse := {}

func _init() -> void:
	for key in input_path_mapping:
		input_path_mapping_reverse[input_path_mapping[key]] = key

func serialize_input(all_input: Dictionary) -> PackedByteArray:
	var buffer := StreamPeerBuffer.new()
	buffer.resize(16)
	
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
		if input.has('a_button'):
			header |= HeaderFlags.HAS_A_BUTTON #1 byte
		if input.has('b_button'):
			header |= HeaderFlags.HAS_B_BUTTON #1 byte
		if input.has('c_button'):
			header |= HeaderFlags.HAS_C_BUTTON #1 byte
		
		buffer.put_u8(header)
		
		if input.has('input_vector'):
			var input_vector: Vector2 = input['input_vector']
			buffer.put_float(input_vector.x) #4 bytes
			buffer.put_float(input_vector.y) #4 bytes
		
		if input.has('a_button'):
			buffer.put_u8(input['a_button'])
		if input.has('b_button'):
			buffer.put_u8(input['b_button'])
		if input.has('c_button'):
			buffer.put_u8(input['c_button'])
	
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
		input['input_vector'] = Vector2(buffer.get_float(), buffer.get_float())
	
	all_input[path] = input
	return all_input
