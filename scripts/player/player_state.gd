class_name PlayerState
extends State
## Base de los estados del jugador: expone `player` ya tipado.
@export var SPEED : float = 0.0
@export var SLIDE : float = 0.0
@export var ANIMATION_NAME : String = "player_idle"

var player: Player:
	get:
		return actor as Player

func enter(_previous_state: StringName) -> void:
	player.sprite.speed_scale = 1.0
	player.sprite.play(ANIMATION_NAME)
