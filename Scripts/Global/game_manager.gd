extends Node

enum Game_State {
	#GAME_START,
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
@export var fade_sprite : Sprite2D
@export var ko_sprite : Sprite2D
@export var ko_overlay : Sprite2D
@export var win_panel : Panel
@export var test_menu : Node

@onready var audioplayer : AudioStreamPlayer = $AudioStreamPlayer
@onready var anim_player : NetworkAnimationPlayer = $"../NetworkAnimationPlayer"

var STAGE_THEME = preload("res://Audio/Music/stage-theme2.mp3")

var player1
var player2
var current_frame := 0

var current_round := 0
var p1_rounds := 0
var p2_rounds := 0
var pause := false
var disable_input := false
var disable_damage := false
var current_game_state = Game_State.ROUND
var intro := true
var song_played := false

func game_state_update():
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
	ko_overlay.visible = false
	ko_sprite.visible = false
	fade_sprite.modulate.a -= 0.05
	
	if fade_sprite.modulate.a <= 0:
		fade_sprite.modulate.a = 0
		current_game_state = Game_State.ROUND

func fade_out():
	fade_sprite.modulate.a += 0.05
	
	if fade_sprite.modulate.a >= 1:
		fade_sprite.modulate.a = 1
		current_game_state = Game_State.ROUND

func game_process() -> void:
	if intro:
		player1.time_label.text = "60"
		player2.time_label.text = "60"
	elif !match_timer.is_stopped():
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
	disable_input = true
	if !pause:
		ko_overlay.visible = true
		ko_sprite.visible = true
		#pause_game()
		final_hit_timer.start()

func round_intro():
	if !song_played:
		#SyncManager.play_sound(str(get_path()) + ":theme", STAGE_THEME, {volume_db = -10})
		audioplayer.play()
		song_played = true
		test_menu.disable_message_label()
	intro = true
	anim_player.play("round_start")
	
	current_game_state = Game_State.FADE_IN
	disable_input = false
	disable_damage = false
	current_round += 1
	player1.round_label.text = "Round " + str(current_round)
	player2.round_label.text = "Round " + str(current_round)
	#Do countdown animation
	
	#Start time after countdown is over
	countdown_timer.start()
	

func round_start():
	intro = false
	match_timer.start()

func round_end():
	#turn off final hit effect
	if p2_rounds == 1:
		player1.round_count_1.modulate.r = 255
		player1.round_count_1.modulate.g = 255
		player1.round_count_1.modulate.b = 0
	elif p2_rounds == 2:
		player1.round_count_2.modulate.r = 255
		player1.round_count_2.modulate.g = 255
		player1.round_count_2.modulate.b = 0
	
	if p1_rounds == 1:
		player2.round_count_1.modulate.r = 255
		player2.round_count_1.modulate.g = 255
		player2.round_count_1.modulate.b = 0
	elif p1_rounds == 2:
		player2.round_count_2.modulate.r = 255
		player2.round_count_2.modulate.g = 255
		player2.round_count_2.modulate.b = 0
	
	disable_input = true
	disable_damage = true
	fade_sprite.modulate.a = -5
	current_game_state = Game_State.FADE_OUT
	round_end_timer.start()
	match_timer.stop()
	#pause the screen on that final hit, do this through?:
		#modulate canvas node to #ff0000
		#setting a boolean in the player that when true doesn't run physics process
		#pause current characters animations
		#then after resume
	#fade from red to no alpha
	#make all objects black/very dark
	

func win_game():
	#go to win screen
	win_panel.visible = true
	if p1_rounds == 2:
		win_panel.get_child(0).text = "Player 2 Wins!"
	elif p2_rounds == 2:
		win_panel.get_child(0).text = "Player 1 Wins!"
	player1.disable_ui()
	player2.disable_ui()

func _on_countdown_timer_timeout() -> void:
	round_start()

func _on_match_timer_timeout() -> void:
	if player1.health > player2.health:
		p2_rounds += 1
	elif player2.health > player1.health:
		p1_rounds += 1
	
	round_end()

func _on_round_end_timer_timeout() -> void:
	if p1_rounds == 2 or p2_rounds == 2:
		win_game()
	else:
		player1.state_machine.current_state.Transitioned.emit(player1.state_machine.current_state, "intro")
		player2.state_machine.current_state.Transitioned.emit(player2.state_machine.current_state, "intro")

func _on_final_hit_timer_timeout() -> void:
	#pause_game()
	round_end()

#func _on_rematch_button_button_down() -> void:
	##if multiplayer.get_unique_id() == 1:
		##player2.rematch = true
	##elif multiplayer.get_unique_id() != 1:
		##player1.rematch = true
	##
	##if player1.rematch and player2.rematch:
	#game_start()
	#win_panel.visible = false
	#player1.state_machine.current_state.Transitioned.emit(player1.state_machine.current_state, "intro")
	#player2.state_machine.current_state.Transitioned.emit(player2.state_machine.current_state, "intro")
