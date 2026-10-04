class_name State
extends Node
## Clase base de todos los estados. Cada estado es un nodo hijo del StateMachine.

## Se emite para pedir un cambio de estado (por nombre de nodo, sin importar mayúsculas).
signal transitioned(from_state: State, new_state_name: StringName)

## Nodo dueño de la máquina (lo asigna StateMachine al iniciar).
var actor: Node


func enter(_previous_state: StringName) -> void:
	pass


func exit() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
