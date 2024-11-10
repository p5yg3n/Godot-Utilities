class_name StateMachine
extends Node


signal transitioned(state_name)


@export var initial_state: State


@onready var state: State = initial_state


func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is State:
			child.state_machine = self
	state.enter()


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func transition_to(new_state_name: String, properties: Dictionary = {}) -> void:
	if not has_node(new_state_name):
		return

	state.exit()
	state = get_node(new_state_name)
	state.enter(properties)
	emit_signal("transitioned", state.name)
