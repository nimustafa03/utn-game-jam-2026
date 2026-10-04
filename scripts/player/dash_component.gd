extends Node


func _process(delta):
	if Input.is_action_just_pressed("dash") && owner.state_machine.current_state.ANIMATION_NAME != "dash":
		owner.state_machine._on_state_transitioned(owner.state_machine.current_state, &"dash")
