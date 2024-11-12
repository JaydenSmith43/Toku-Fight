extends Node3D

@onready var test_menu = $TestMenu

@onready var floor = $Floor
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var screen_boundaries = $ScreenBoundaries
@onready var player1 = $test1
@onready var player2 = $test2

var visible_2D := false

func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	test_menu.setup_match_for_replay(my_peer_id, peer_ids, match_info)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Visible_Toggle"):
		if visible_2D:
			floor.visible = false
			left_wall.visible = false
			right_wall.visible = false
			screen_boundaries.visible = false
			player1.visible = false
			player2.visible = false
			visible_2D = false
		else:
			floor.visible = true
			left_wall.visible = true
			right_wall.visible = true
			screen_boundaries.visible = true
			player1.visible = true
			player2.visible = true
			visible_2D = true
