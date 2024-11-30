extends Node3D

@onready var network_timer : NetworkTimer = $NetworkTimer

func _network_spawn(data: Dictionary) -> void:
	global_position.x = (data['pos_x'])
	global_position.y = -(data['pos_y'])
	print(position.x)
	print(position.y)
	network_timer.start()

func _on_network_timer_timeout() -> void:
	SyncManager.despawn(self)
