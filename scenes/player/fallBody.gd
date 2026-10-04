extends PlayerState
func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.apply_gravity(delta)
	player.move_and_slide()

	if player.is_on_floor():
		if direction != 0.0:
			transitioned.emit(self, &"walk")
		else:
			transitioned.emit(self, &"idle")
