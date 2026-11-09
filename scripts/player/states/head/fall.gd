extends PlayerState

@export_range(1.0,10.0) var airControlDampener : float = 1.0 # Hace más lento el movimiento horizontal al caer. Por defecto es 1.0. Se aplica dividiendo la velocidad final horizontal por el valor dado.
@export_range(0.0, 5000.0) var horizontalSpeed : float = 500.0 # Velocidad de movimiento horizontal
@export_range(0.0, 10000.0) var horizontalSlide : float = 1000.0 # Aceleración de velocidad horizontal.

@export_range(-1000.0, 0.0) var BOUNCE_THRESHOLD : float = 20.0


var fallSpeedMultiplier : float = 1.0 # Multiplicador de velocidad de caida, aplicado cuando se presionan las teclas de movimiento. El 1.0 es un valor default, no se debe modificar desde esta declaración.
var imminentImpactVelocity : float = 0.0 # Asignada cada frame de físicas, justo al final. Consultada cuando se impacta contra el suelo.


func update(_delta: float) -> void:
	if Input.is_action_pressed("move_down"):
		fallSpeedMultiplier = 1.5
	if Input.is_action_pressed("move_up"):
		fallSpeedMultiplier = 0.5
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		horizontalSlide = 1000.0
	if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
		horizontalSlide = 1.0
	if Input.is_action_just_released("move_down") || Input.is_action_just_released("move_up"):
		fallSpeedMultiplier = 1.0


func physics_update(delta: float) -> void:
	var direction := player.get_move_direction()
	player.velocity.y = move_toward(player.velocity.y, SPEED*fallSpeedMultiplier, SLIDE*delta)
	player.velocity.x = move_toward(player.velocity.x, (horizontalSpeed/airControlDampener)*direction, horizontalSlide*delta)
	player.move_and_slide()
	
	if player.is_on_floor() && imminentImpactVelocity > BOUNCE_THRESHOLD:
		apply_bounce(-imminentImpactVelocity/2)
	
	if player.is_on_floor() && imminentImpactVelocity <= BOUNCE_THRESHOLD:
		transitioned.emit(self, &"roll")
	imminentImpactVelocity = player.velocity.y

func apply_bounce(bounce_velocity : float) -> void:
	player.velocity.y = bounce_velocity
