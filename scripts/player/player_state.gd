class_name PlayerState
extends State
## Base de los estados del jugador: expone `player` ya tipado.
@export var SPEED : float = 0.0
@export var SLIDE : float = 0.0
@export var ANIMATION_NAME : String = "player_idle"

var player: Player:
	get:
		return actor as Player
var animation_playback_speed : float = 1.0

func enter(_previous_state: StringName) -> void:
	player.sprite.play(ANIMATION_NAME, animation_playback_speed)
