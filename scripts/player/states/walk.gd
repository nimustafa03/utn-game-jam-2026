extends PlayerState
## Caminando en el piso.


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.apply_gravity(delta)
	player.accelerate_horizontal(direction, delta)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif Input.is_action_just_pressed("jump"):
		transitioned.emit(self, &"jump")
	elif direction == 0.0:
		transitioned.emit(self, &"idle")
