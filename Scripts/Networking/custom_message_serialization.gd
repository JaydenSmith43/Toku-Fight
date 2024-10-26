extends "res://addons/godot-rollback-netcode/MessageSerializer.gd"

const input_path_mapping := {
	'/root/Node3D/test1': 1,
	'/root/Node3D/test2': 2
}

enum HeaderFlags {
	HAS_INPUT_VECTOR = 0x01,
	HAS_A_BUTTON = 0x02,
	HAS_B_BUTTON = 0x02,
	HAS_C_BUTTON = 0x02
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
		if input.has('a_button'):
			header |= HeaderFlags.HAS_A_BUTTON #1 byte
		if input.has('b'):
			header |= HeaderFlags.HAS_B_BUTTON #1 byte
		if input.has('c'):
			header |= HeaderFlags.HAS_C_BUTTON #1 byte
		
		buffer.put_u8(header)
		
		if input.has('input_vector'):
			var input_vector: Vector2 = input['input_vector']
			buffer.put_float(input_vector.x) #4 bytes
			buffer.put_float(input_vector.y) #4 bytes
		
		if input.has('a'):
			var a_button: bool = input['a']
			buffer.put_8(a_button) #1 byte
		if input.has('b'):
			var b_button: bool = input['b']
			buffer.put_8(b_button) #1 byte
		if input.has('c'):
			var c_button: bool = input['c']
			buffer.put_8(c_button) #1 byte
	
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
	if header & HeaderFlags.HAS_A_BUTTON:
		input['a'] = bool(buffer.get_8())
	if header & HeaderFlags.HAS_B_BUTTON:
		input['b'] = buffer.get_8()
	if header & HeaderFlags.HAS_C_BUTTON:
		input['c'] = bool(buffer.get_8())
	
	all_input[path] = input
	return all_input
