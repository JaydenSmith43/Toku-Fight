extends Node3D


func _network_spawn(data: Dictionary) -> void:
	pass

func _on_network_timer_timeout() -> void:
	SyncManager.despawn(self)
