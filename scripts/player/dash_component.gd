extends Node

var dashed_while_airborne = false

func _process(delta):
	if Input.is_action_just_pressed("dash") && owner.state_machine.current_state.ANIMATION_NAME != "dash" && !dashed_while_airborne:
		owner.state_machine._on_state_transitioned(owner.state_machine.current_state, &"dash")
		if not owner.is_on_floor():
			dashed_while_airborne = true
