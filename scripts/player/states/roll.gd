extends PlayerState
## Caminando en el piso.

const MIN_ANIMATION_SPEED := 0.3
const MAX_ANIMATION_SPEED := 1.0
const RESTING_ANIMATION_SPEED := 0.08

func enter(_previous_state: StringName) -> void:
	super(_previous_state)
	player.sprite.flip_h = false
	_update_animation_speed(player.get_move_direction())

func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.update_facing(direction)
	player.sprite.flip_h = false
	player.apply_gravity(delta)
	player.velocity.x = lerp(player.velocity.x, SPEED*direction, SLIDE/2*delta)
	
	player.move_and_slide()
	_update_animation_speed(direction)
	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif direction == 0.0:
		player.velocity = lerp(player.velocity, Vector2.ZERO, SLIDE/2*delta)
		if absf(player.velocity.x) < 5.0:
			transitioned.emit(self, &"idle")


func _update_animation_speed(direction: float) -> void:
	var max_speed := absf(SPEED)
	var speed_sign := signf(direction)
	if is_zero_approx(speed_sign):
		speed_sign = signf(player.velocity.x)
	if is_zero_approx(speed_sign):
		speed_sign = signf(player.sprite.speed_scale)
	if is_zero_approx(speed_sign):
		speed_sign = 1.0

	if is_zero_approx(max_speed):
		player.sprite.speed_scale = MIN_ANIMATION_SPEED * speed_sign
		return

	var speed_ratio := clampf(absf(player.velocity.x) / max_speed, 0.0, 1.0)
	player.sprite.speed_scale = maxf(
		RESTING_ANIMATION_SPEED,
		lerpf(MIN_ANIMATION_SPEED, MAX_ANIMATION_SPEED, speed_ratio)
	) * speed_sign
