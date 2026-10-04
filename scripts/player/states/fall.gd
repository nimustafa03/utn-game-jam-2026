extends PlayerState
## Cayendo (después de un salto o de caminar fuera de una plataforma).

@export var INITIAL_BOUNCE_IMPULSE: float = 300.0
@export_range(0.0, 1.0) var IMPACT_SPEED_MULTIPLIER: float = 0.25
@export_range(0.1, 1.0) var FALL_GRAVITY_SCALE: float = 0.5
@export_file("*.mp3","*.ogg","*.wav") var fallSFX: String = "res://assets/final/sonidos/pillowFall.mp3"
@export var fall_sfx_player: AudioStreamPlayer2D
@export var FALL_SPEED : float = 700.0 

const MIN_BOUNCE_IMPULSE := 40.0
const BOUNCE_FALLOFF := 0.5

var bounce_impulse := 0.0
var was_on_floor := false

var fallSpeedMultiplier : float = 1.0

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

func update(delta: float) -> void:
	super(delta)
	if Input.is_action_pressed("move_down"):
		fallSpeedMultiplier = 1.5
	if Input.is_action_pressed("move_up"):
		fallSpeedMultiplier = 0.5
	
	if Input.is_action_just_released("move_down") || Input.is_action_just_released("move_up"):
		fallSpeedMultiplier = 1.0

func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.velocity.y = move_toward(player.velocity.y, FALL_SPEED*fallSpeedMultiplier, SLIDE*delta)
	player.velocity.x = move_toward(player.velocity.x, SPEED*direction, SLIDE*delta)
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
