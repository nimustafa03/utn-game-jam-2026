extends PlayerState
## Caminando en el piso.

func enter(_previous_state: StringName) -> void:
	super(_previous_state)
	animation_playback_speed = 0.5

func update(delta : float) -> void:
	animation_playback_speed = move_toward(animation_playback_speed, 1.0, SLIDE*delta)

func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.apply_gravity(delta)
	player.velocity.x = lerp(player.velocity.x, SPEED*direction, SLIDE*delta)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif Input.is_action_just_pressed("jump"):
		transitioned.emit(self, &"jump")
	elif direction == 0.0:
		player.velocity = lerp(player.velocity, Vector2.ZERO, SLIDE*delta)
		if player.velocity == Vector2.ZERO:
			transitioned.emit(self, &"idle")
