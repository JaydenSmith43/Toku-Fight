extends Node3D

@onready var test_menu = $TestMenu

func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	test_menu.setup_match_for_replay(my_peer_id, peer_ids, match_info)
