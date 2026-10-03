class_name Player
extends CharacterBody2D
## Jugador 2D (vista lateral). La lógica de cada estado vive en scripts/player/states/.

@export_group("Movimiento")
@export var max_speed: float = 220.0
@export var acceleration: float = 1500.0
@export var friction: float = 1800.0
## Qué tanto control tenés en el aire (1.0 = igual que en el piso).
@export_range(0.0, 1.0) var air_control: float = 0.7

@export_group("Salto y caída")
@export var jump_velocity: float = -420.0
@export var max_fall_speed: float = 700.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_ensure_input_actions()


func get_move_direction() -> float:
	return Input.get_axis("move_left", "move_right")


func apply_gravity(delta: float) -> void:
	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)


func accelerate_horizontal(direction: float, delta: float, control: float = 1.0) -> void:
	velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * control * delta)


func apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)


func update_facing(direction: float) -> void:
	if direction != 0.0:
		facing = int(signf(direction))
		sprite.flip_h = facing < 0


## Crea las acciones de teclado si todavía no existen en el Input Map.
## Más adelante podés definirlas en Project Settings > Input Map y borrar esto.
func _ensure_input_actions() -> void:
	var bindings := {
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"jump": [KEY_SPACE, KEY_W, KEY_UP],
	}
	for action: String in bindings:
		if InputMap.has_action(action):
			continue
		InputMap.add_action(action)
		for key: int in bindings[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = key as Key
			InputMap.action_add_event(action, ev)
