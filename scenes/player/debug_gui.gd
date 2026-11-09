extends Control

@export var parent : Player
@onready var x_velocity = get_node("CanvasLayer/X Velocity")
@onready var y_velocity = get_node("CanvasLayer/Y Velocity")
@onready var state_name = get_node("CanvasLayer/State Name")

var visibility_toggle : bool = false

func _process(_delta : float) -> void:
	
	if Input.is_action_just_pressed("debug_ui_enable"):
		get_node("CanvasLayer").visible = !visibility_toggle
		visibility_toggle = !visibility_toggle

	x_velocity.text = str(parent.velocity.x)
	y_velocity.text = str(parent.velocity.y)
	state_name.text = String(parent.state_machine.current_state.name)
	
