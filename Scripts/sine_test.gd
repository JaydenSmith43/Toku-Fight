extends Node2D

var time : float
var frequency : float = 5
var amplitude = -100

func _process(delta):
	time += delta
	position.y = get_sine()

func get_sine():
	return sin(time * frequency) * amplitude
