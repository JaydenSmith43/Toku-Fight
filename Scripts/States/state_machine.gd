extends Node

@export var initial_state : State
@onready var state_label = $"../UI/HealthBar/StateLabel"

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		state_label.text = "State: \n" + current_state.name
		#print(state_label.text)

func tick_physics_process(input: Dictionary):
	current_state.State_Physics_Update(input)

func load_state_network(network_state_data: Dictionary):
	if states.get(network_state_data['current_state_name']):
		current_state = states.get(network_state_data['current_state_name'])
		#print("Current State: " + current_state.name.to_lower())

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	#print(state_label.text)
