extends PlayerState
## Cayendo (después de un salto o de caminar fuera de una plataforma).

@export var INITIAL_BOUNCE_IMPULSE: float = 300.0
@export_range(0.0, 1.0) var IMPACT_SPEED_MULTIPLIER: float = 0.25
@export_range(0.1, 1.0) var FALL_GRAVITY_SCALE: float = 0.5

const MIN_BOUNCE_IMPULSE := 40.0
const BOUNCE_FALLOFF := 0.5

var bounce_impulse := 0.0


func enter(previous_state: StringName) -> void:
	super(previous_state)
	bounce_impulse = maxf(INITIAL_BOUNCE_IMPULSE, 0.0)


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.apply_gravity(delta * FALL_GRAVITY_SCALE)
	player.accelerate_horizontal(direction, delta, player.air_control)
	var impact_speed := maxf(player.velocity.y, 0.0)
	player.move_and_slide()

	if player.is_on_floor():
		if bounce_impulse >= MIN_BOUNCE_IMPULSE:
			var landing_bounce := bounce_impulse + impact_speed * IMPACT_SPEED_MULTIPLIER
			player.velocity.y = -landing_bounce
			bounce_impulse *= BOUNCE_FALLOFF
			return

		if direction != 0.0:
			transitioned.emit(self, &"roll")
		else:
			transitioned.emit(self, &"idle")
