extends PlayerState

func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0.0, SLIDE*delta)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif player.get_move_direction() != 0.0:
		transitioned.emit(self, &"roll")
