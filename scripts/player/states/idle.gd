extends PlayerState
## Quieto en el piso.



func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.apply_friction(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif Input.is_action_just_pressed("jump"):
		transitioned.emit(self, &"jump")
	elif player.get_move_direction() != 0.0:
		transitioned.emit(self, &"walk")
