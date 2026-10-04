extends CharacterBody2D

@export_enum("Left: -1", "Right: 1") var DIRECTION: int = -1
@export var SPEED: float = 500.0
@onready var activation_timer: Timer = $ActivationTimer
@onready var delete_timer : Timer = $DeleteTimer
@onready var warning_sprite = $TextureRect
@onready var warning_sprite2 = $TextureRect2
var target_speed = 0.0

func _ready():
	if DIRECTION == 1:
		get_node("AnimatedSprite2D").flip_h = true

func _physics_process(_delta: float) -> void:
	velocity = Vector2(target_speed * DIRECTION, 0.0)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()


func _on_waker_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	activation_timer.start()
	await activation_timer.timeout
	warning_sprite.visible = false
	warning_sprite2.visible = false
	target_speed = SPEED
	
	delete_timer.start()
	await delete_timer.timeout
	self.queue_free()
