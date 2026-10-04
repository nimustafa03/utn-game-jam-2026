extends PlayerState

func enter(_previous_state: StringName) -> void:
	super(_previous_state)
	var direction := player.facing
	player.velocity.x = SPEED * direction

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") && player.is_on_floor():
		transitioned.emit(self, &"jump")
	if Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_left"):
		transitioned.emit(self, &"walk")

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0.0, SLIDE * delta)
	player.apply_gravity(delta)
	player.move_and_slide()
	
	if is_zero_approx(player.velocity.x):
		if player.is_on_floor():
			player.get_node("DashComponent").dashed_while_airborne = false
			if player.get_move_direction() != 0.0:
				transitioned.emit(self, &"walk")
			else:
				transitioned.emit(self, &"idle")
		else:
			transitioned.emit(self, &"fall")
	
