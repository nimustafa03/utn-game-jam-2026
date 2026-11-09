extends PlayerState

@export_range(0.1,2.0) var MIN_ANIMATION_SPEED := 0.3
@export_range(0.1,2.0) var MAX_ANIMATION_SPEED := 2.0
@export_range(0.0,1.0) var RESTING_ANIMATION_SPEED := 0.08
@export var REST_FRAME : int = 3 # Frame de descanso. En el que se vea más natural.


func enter(previous_state: StringName) -> void:
	super(previous_state)
	player.sprite.frame = REST_FRAME
	player.sprite.frame_progress = 0.0
	player.sprite.pause()


func physics_update(delta: float) -> void:
	var direction = player.get_move_direction()
	player.sprite.flip_h = false
	player.velocity.x = lerp(player.velocity.x, SPEED*direction, (SLIDE*delta)/2)
	update_animation_speed(direction)
	
	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	player.move_and_slide()


func update_animation_speed(direction: float) -> void:
	var speed_sign = signf(direction)
	if is_zero_approx(direction):
		speed_sign = signf(signf(player.velocity.x))
		
	var speed_ratio := clampf(absf(player.velocity.x) / SPEED, 0.0, 1.0)

	if direction == 0.0 && absf(player.velocity.x) <= 10.0:
		pause_on_rest_frame(speed_sign)
	
	player.sprite.speed_scale = maxf(
			RESTING_ANIMATION_SPEED,
			lerpf(
					MIN_ANIMATION_SPEED, 
					MAX_ANIMATION_SPEED, 
					speed_ratio
			)
	) * speed_sign

func pause_on_rest_frame(direction : float) -> void:
	player.velocity.x = 10.0 * direction
	if REST_FRAME == player.sprite.frame:
		player.sprite.pause()
		player.velocity.x = 0.0

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_left"): ## Es importante mantener este check para que la animación se reanude una vez que el jugador vuelva a moverse.
		player.sprite.play(ANIMATION_NAME)
