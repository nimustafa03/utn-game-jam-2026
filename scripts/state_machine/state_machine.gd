class_name StateMachine
extends Node
## Administra los estados hijos: guarda el actual, cambia de uno a otro
## y le reenvía _process, _physics_process y el input.

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# Esperamos a que el dueño (la escena raíz) termine de cargar.
	await owner.ready

	for child in get_children():
		if child is State:
			var state := child as State
			states[String(state.name).to_lower()] = state
			state.actor = owner
			state.transitioned.connect(_on_state_transitioned)

	# Si no se asignó un estado inicial en el Inspector, usamos el primer hijo.
	if initial_state == null and not states.is_empty():
		initial_state = states.values()[0]

	if initial_state:
		current_state = initial_state
		current_state.enter(&"")


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_state_transitioned(from_state: State, new_state_name: StringName) -> void:
	# Ignoramos pedidos de estados que ya no están activos.
	if from_state != current_state:
		return

	var new_state: State = states.get(String(new_state_name).to_lower())
	if new_state == null:
		push_warning("StateMachine: no existe el estado '%s'" % new_state_name)
		return

	var previous_name := current_state.name
	current_state.exit()
	new_state.enter(previous_name)
	current_state = new_state
