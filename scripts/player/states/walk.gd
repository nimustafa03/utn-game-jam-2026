extends PlayerState


func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, &"jump")


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.apply_gravity(delta)

	var acceleration_weight := clampf(SLIDE * delta, 0.0, 1.0)
	player.velocity.x = lerpf(player.velocity.x, SPEED * direction, acceleration_weight)
	player.apply_friction(delta)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif direction == 0.0 and absf(player.velocity.x) < 0.5:
		transitioned.emit(self, &"idle")
