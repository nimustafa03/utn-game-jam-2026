extends PlayerState
## Subiendo después de saltar. Si soltás el botón antes, el salto queda más corto.

const JUMP_CUT := 0.5


func enter(_previous_state: StringName) -> void:
	player.velocity.y = player.jump_velocity


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.apply_gravity(delta)
	player.accelerate_horizontal(direction, delta, player.air_control)

	if Input.is_action_just_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= JUMP_CUT

	player.move_and_slide()

	if player.velocity.y >= 0.0:
		transitioned.emit(self, &"fall")
