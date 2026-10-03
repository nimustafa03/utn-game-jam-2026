extends PlayerState
## Caminando en el piso.

const MIN_ANIMATION_SPEED := 0.3
const MAX_ANIMATION_SPEED := 1.0

func enter(_previous_state: StringName) -> void:
	super(_previous_state)
	_update_animation_speed()

func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.apply_gravity(delta)
	player.velocity.x = lerp(player.velocity.x, SPEED*direction, SLIDE/2*delta)
	
	player.move_and_slide()
	_update_animation_speed()
	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif direction == 0.0:
		player.velocity = lerp(player.velocity, Vector2.ZERO, SLIDE/2*delta)
		if player.velocity.x > -1 && player.velocity.x < 1:
			transitioned.emit(self, &"idle")


func _update_animation_speed() -> void:
	var max_speed := absf(SPEED)
	if is_zero_approx(max_speed):
		player.sprite.speed_scale = MIN_ANIMATION_SPEED
		return

	var speed_ratio := clampf(absf(player.velocity.x) / max_speed, 0.0, 1.0)
	player.sprite.speed_scale = lerpf(MIN_ANIMATION_SPEED, MAX_ANIMATION_SPEED, speed_ratio)
