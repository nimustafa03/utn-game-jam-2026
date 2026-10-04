extends AnimatableBody2D

@export var FLOAT_AMPLITUDE: float = 12.0
@export var FLOAT_PERIOD: float = 3.0

var start_y: float
var elapsed_time := 0.0


func _ready() -> void:
	start_y = position.y
	$AnimatedSprite2D.play("default")


func _process(delta: float) -> void:
	elapsed_time += delta
	var angular_frequency := TAU / maxf(FLOAT_PERIOD, 0.01)
	position.y = start_y + FLOAT_AMPLITUDE * sin(elapsed_time * angular_frequency)
