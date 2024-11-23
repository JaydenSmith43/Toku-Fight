extends Node

enum Game_State {
	ROUND_INTRO,
	ROUND,
	ROUND_END
}

@export var network_timer : NetworkTimer

var player1
var player2

var current_round := 0
var p1_rounds := 0
var p2_rounds := 0
var pause = false
var disable_input = true
var current_game_state = Game_State

func game_state_update():
	if pause:
		return
	match current_game_state:
		Game_State.ROUND_INTRO:
			pass
		Game_State.ROUND:
			pass
		Game_State.ROUND_END:
			pass
	

func pause_game():
	pause = !pause
	
	if pause:
		player1.anim_player.pause()
		player2.anim_player.pause()
	else:
		player1.anim_player.play()
		player2.anim_player.play()

func game_start():
	if player1 == null or player2 == null:
		return
	
	current_round = 1
	p1_rounds = 0
	p2_rounds = 0
	
	if (player1.fixed_position.x - player2.fixed_position.x < 0):
		player1.model.rotation_degrees.z = 0
		player1.model.scale = Vector3(1,1,1)
		player1.left_side = true
		player2.model.rotation_degrees.z = 180
		player2.model.scale = Vector3(-1,-1,-1)
		player2.left_side = false
	else:
		player2.model.rotation_degrees.z = 0
		player2.model.scale = Vector3(1,1,1)
		player2.left_side = true
		player1.model.rotation_degrees.z = 180
		player1.model.scale = Vector3(-1,-1,-1)
		player1.left_side = false
	
	player1.model.position.x = SGFixed.to_float(player1.fixed_position_x)
	player1.model.position.y = -SGFixed.to_float(player1.fixed_position_y)
	player2.model.position.x = SGFixed.to_float(player2.fixed_position_x)
	player2.model.position.y = -SGFixed.to_float(player2.fixed_position_y)
	
	

func round_start():
	player1.health = 100
	player2.health = 100
	player1.fixed_position.x = -8
	player2.fixed_position.x = 8
	
	current_round += 1
	network_timer.start()
	#Do countdown animation
	
	
	#Start time after countdown is over
	
	
	#give input back to player (this can be done with a start state)
	
	pass

func round_end():
	#remove input from players but keep them in their states 
	#pause the screen on that final hit, do this through?:
		#modulate canvas node to #ff0000
		#setting a boolean in the player that when true doesn't run physics process
		#pause current characters animations
		#then after resume
	#fade from red to no alpha
	#make all objects black/very dark
	#increase round point
	#check for if that resulted in a win
	
	pass

func win_game():
	
	pass
