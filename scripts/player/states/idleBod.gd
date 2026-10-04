extends PlayerState


func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self,&"jump")

func physics_update(delta:float) -> void:
	player.velocity.y = lerp(player.velocity.y, 0.0, SLIDE)
	player.apply_friction(delta)
	player.apply_gravity(delta)
	player.move_and_slide()
	
	if not player.is_on_floor():
		transitioned.emit(self,&"fall")
	elif player.get_move_direction() != 0.0:
		transitioned.emit(self, &"walk")
