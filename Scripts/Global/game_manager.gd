extends Node

enum Game_State {
	ROUND_INTRO,
	ROUND,
	ROUND_END,
	FADE_IN,
	FADE_OUT,
	FINAL_HIT_PAUSE,
}

@export var match_timer : NetworkTimer
@export var countdown_timer : NetworkTimer
@export var round_end_timer : NetworkTimer
@export var final_hit_timer : NetworkTimer
@export var fade_texture : Sprite2D

var player1
var player2
var current_frame = 0

var current_round := 0
var p1_rounds := 0
var p2_rounds := 0
var pause = false
var disable_input = false
var current_game_state = Game_State.ROUND

func game_state_update():
	#print("game_state: " + str(current_game_state))
	if pause:
		return
	
	match current_game_state:
		Game_State.ROUND_INTRO:
			round_intro()
		Game_State.ROUND:
			pass
		Game_State.FADE_IN:
			fade_in()
		Game_State.FADE_OUT:
			fade_out()
		Game_State.ROUND_END:
			pass
		Game_State.FINAL_HIT_PAUSE:
			final_hit_pause()


func fade_in():
	fade_texture.modulate.a -= 0.05
	
	if fade_texture.modulate.a <= 0:
		fade_texture.modulate.a = 0
		current_game_state = Game_State.ROUND

func fade_out():
	fade_texture.modulate.a += 0.05
	
	if fade_texture.modulate.a >= 1:
		fade_texture.modulate.a = 1
		current_game_state = Game_State.ROUND

func _physics_process(_delta: float) -> void:
	#player1.input_current_frame += 1
	#if player1.input_current_frame > current_frame:
	#current_frame = player1.input_current_frame
	player1.time_label.text = str(match_timer.ticks_left / 60)
	player2.time_label.text = str(match_timer.ticks_left / 60)
	game_state_update()

func pause_game():
	pause = !pause
	
	if pause:
		player1.anim_player.pause()
		player2.anim_player.pause()
	else:
		player1.anim_player.play()
		player2.anim_player.play()


#func game_reset():
	#player1.reset_self()
	#player2.reset_self()
	#
	#if player1 == null or player2 == null:
		#return
	#
	#current_round = 0
	#p1_rounds = 0
	#p2_rounds = 0

func game_start():
	if player1 == null or player2 == null:
		return
	
	current_round = 0
	p1_rounds = 0
	p2_rounds = 0

func final_hit_pause():
	if !pause:
		pause_game()
		final_hit_timer.start()

func round_intro():
	current_game_state = Game_State.FADE_IN
	disable_input = false
	current_round += 1
	player1.round_label.text = "Round " + str(current_round)
	player2.round_label.text = "Round " + str(current_round)
	
	#Do countdown animation
	
	
	#Start time after countdown is over
	countdown_timer.start()
	

func round_start():
	match_timer.start()

func round_end():
	#turn off final hit effect
	
	disable_input = true
	fade_texture.modulate.a = -5
	current_game_state = Game_State.FADE_OUT
	round_end_timer.start()
	#pause the screen on that final hit, do this through?:
		#modulate canvas node to #ff0000
		#setting a boolean in the player that when true doesn't run physics process
		#pause current characters animations
		#then after resume
	#fade from red to no alpha
	#make all objects black/very dark
	
	#determine winner an give them point
	#check for if that resulted in a win
	

func win_game():
	#go to win screen
	pass

func _on_countdown_timer_timeout() -> void:
	round_start()

func _on_match_timer_timeout() -> void:
	round_end()

func _on_round_end_timer_timeout() -> void:
	###TODO CHECK FOR FINAL ROUND AND THEN END GAME
	player1.state_machine.current_state.Transitioned.emit(player1.state_machine.current_state, "intro")
	player2.state_machine.current_state.Transitioned.emit(player2.state_machine.current_state, "intro")
	round_intro()

func _on_final_hit_timer_timeout() -> void:
	pause_game()
	round_end()
