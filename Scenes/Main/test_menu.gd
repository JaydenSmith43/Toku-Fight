extends Node

const DummyNetworkAdapter = preload("res://addons/godot-rollback-netcode/DummyNetworkAdaptor.gd")

@onready var main_menu = $CanvasLayer/MainMenu
@onready var connection_panel = $CanvasLayer/ConnectionPanel
@onready var host_field = $CanvasLayer/ConnectionPanel/GridContainer/HostField
@onready var port_field = $CanvasLayer/ConnectionPanel/GridContainer/PortField
@onready var message_label = $CanvasLayer/MessageLabel
@onready var sync_lost_label = $CanvasLayer/SyncLostLabel
@onready var reset_button = $CanvasLayer/ResetButton

const LOG_FILE_DIRECTORY = 'user://detailed_logs'

var logging_enabled := true

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	SyncManager.sync_started.connect(_on_SyncManager_sync_started)
	SyncManager.sync_stopped.connect(_on_SyncManager_sync_stopped)
	SyncManager.sync_error.connect(_on_SyncManager_sync_error)

func _on_server_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_field.text), 1)
	multiplayer.multiplayer_peer = peer
	connection_panel.visible = false
	main_menu.visible = false
	message_label.text = "Listening..."

func _on_client_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_field.text, int(port_field.text))
	multiplayer.multiplayer_peer = peer
	connection_panel.visible = false
	main_menu.visible = false
	message_label.text = "Connecting..."

func _on_peer_connected(peer_id: int):
	message_label.text = "Connected!"
	SyncManager.add_peer(peer_id)
	
	get_parent().get_node("test1").set_multiplayer_authority(1)
	if multiplayer.is_server():
		get_parent().get_node("test2").set_multiplayer_authority(peer_id)
	else:
		get_parent().get_node("test2").set_multiplayer_authority(multiplayer.get_unique_id())
	
	if multiplayer.is_server():
		message_label.text = "Starting..."
		$Timer.start()
		await $Timer.timeout
		SyncManager.start()

func _on_peer_disconnected(peer_id: int):
	message_label.text = "Disconnected!"
	SyncManager.remove_peer(peer_id)

func _on_server_disconnected(peer_id: int):
	_on_peer_disconnected(1)

func _on_reset_button_pressed() -> void:
	SyncManager.stop()
	SyncManager.clear_peers()
	var peer = multiplayer.multiplayer_peer
	if peer:
		peer.close()
	get_tree().reload_current_scene() 

func _on_SyncManager_sync_started() -> void:
	message_label.text = "Started!"
	
	if logging_enabled and not SyncReplay.active:
		var dir = DirAccess.open(LOG_FILE_DIRECTORY)
		if not dir:
			DirAccess.make_dir_absolute(LOG_FILE_DIRECTORY)
		
		var datetime = Time.get_datetime_dict_from_system(true)
		var log_file_name = "%04d%02d%02d-%02d%02d%02d-peer-%d.log" % [
			datetime['year'],
			datetime['month'],
			datetime['day'],
			datetime['hour'],
			datetime['minute'],
			datetime['second'],
			multiplayer.get_unique_id()
		]
		SyncManager.start_logging(LOG_FILE_DIRECTORY + '/' + log_file_name) #,{stage: volcano}

func _on_SyncManager_sync_stopped() -> void:
	if logging_enabled:
		SyncManager.stop_logging()

func _on_SyncManager_sync_lost() -> void:
	sync_lost_label.visible = true

func _on_SyncManager_sync_regained() -> void:
	sync_lost_label.visible = false

func _on_SyncManager_sync_error(msg: String) -> void:
	message_label.text = "Fatal sync error: " + msg
	sync_lost_label.visible = false
	
	var peer = multiplayer.multiplayer_peer
	if peer:
		peer.close()
	SyncManager.clear_peers()

func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	connection_panel.visible = false
	main_menu.visible = false
	reset_button.visible = false

func _on_online_button_pressed() -> void:
	connection_panel.popup_centered()
	SyncManager.reset_network_adaptor()

func _on_local_button_pressed() -> void:
	main_menu.visible = false
	get_parent().get_node("test2").input_prefix = "P2_"
	SyncManager.network_adaptor = DummyNetworkAdapter.new()
	SyncManager.start()
