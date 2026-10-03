class_name PlayerState
extends State
## Base de los estados del jugador: expone `player` ya tipado.

var player: Player:
	get:
		return actor as Player
