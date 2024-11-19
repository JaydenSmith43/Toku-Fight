extends Node

var current_round = 1
var player1
var player2
var pause = false

func pause_game():
	pause = !pause
	
	if pause:
		player1.pause = true
		player2.pause = true
		player1.anim_player.pause()
		player2.anim_player.pause()
	else:
		player1.pause = false
		player2.pause = false
		player1.anim_player.play()
		player2.anim_player.play()

func round_start():
	#reset health
	#reset positions
	##player 1 to p1 position and player 2 to p2 position
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
