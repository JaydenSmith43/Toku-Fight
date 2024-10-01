extends CanvasLayer
class_name UI

@onready var score_label = $Score
#$Control/MarginContainer/VBoxContainer/HBoxContainer/Score

var score = 0:
	set(new_score):
		score = new_score
		_update_score_label()

func _ready():
	_update_score_label()

func _update_score_label():
	score_label.text = str(score)

func _on_collected(collectable) -> void:
	if collectable: 
		score += 100

###THIS IS WHAT WOULD BE IN THE PLAYER OBJECT

signal collected(collectable) #will emit the type "collectable" when emitted

func collect(collectable):
	collected.emit(collectable) #so now when this is will be called when a pickup occurs
	#you would body.collect(self) from the thing being picked up

###THIS WOULD BE THE GAME SCRIPT WHICH COTAINS THE WORLD AND PLAYER
#extends Node2D
#class_name Game

#@export var tank: Tank
#@export var ui : UI

#func _ready():
#	if tank.collected.is_connected(ui.on_collected):
#		tank.collected.connect(ui.on_collected)
