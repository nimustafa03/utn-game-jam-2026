extends PlayerState
## Cayendo (después de un salto o de caminar fuera de una plataforma).

@export var INITIAL_BOUNCE_IMPULSE: float = 300.0
@export_range(0.0, 1.0) var IMPACT_SPEED_MULTIPLIER: float = 0.25
@export_range(0.1, 1.0) var FALL_GRAVITY_SCALE: float = 0.5
@export_file("*.mp3","*.ogg","*.wav") var fallSFX: String = "res://assets/final/sonidos/Sonido fx almohada sin copyright [HQ].mp3"
@export var fall_sfx_player: AudioStreamPlayer2D

const MIN_BOUNCE_IMPULSE := 40.0
const BOUNCE_FALLOFF := 0.5

var bounce_impulse := 0.0
var was_on_floor := false


func enter(previous_state: StringName) -> void:
	super(previous_state)
	bounce_impulse = maxf(INITIAL_BOUNCE_IMPULSE, 0.0)
	was_on_floor = false

	if fall_sfx_player == null:
		push_error("Fall state requires an AudioStreamPlayer assigned to fall_sfx_player.")
		return

	var fall_stream := load(fallSFX) as AudioStream
	if fall_stream == null:
		push_error("Fall state could not load landing sound: %s" % fallSFX)
		return
	fall_sfx_player.stream = fall_stream


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.apply_gravity(delta * FALL_GRAVITY_SCALE)
	player.accelerate_horizontal(direction, delta, player.air_control)
	var impact_speed := maxf(player.velocity.y, 0.0)
	player.move_and_slide()

	var on_floor := player.is_on_floor()
	if on_floor and not was_on_floor and fall_sfx_player != null:
		fall_sfx_player.play()
	was_on_floor = on_floor

	if on_floor:
		if bounce_impulse >= MIN_BOUNCE_IMPULSE:
			var landing_bounce := bounce_impulse + impact_speed * IMPACT_SPEED_MULTIPLIER
			player.velocity.y = -landing_bounce
			bounce_impulse *= BOUNCE_FALLOFF
			return

		if direction != 0.0:
			transitioned.emit(self, &"roll")
		else:
			transitioned.emit(self, &"idle")
