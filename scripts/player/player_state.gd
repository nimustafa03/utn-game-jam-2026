class_name PlayerState
extends State
## Base de los estados del jugador: expone `player` ya tipado.
@export var ANIMATION_NAME : String

var player: Player:
	get:
		return actor as Player

func _ready():
	actor.sprite.play(ANIMATION_NAME)
