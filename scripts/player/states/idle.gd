extends PlayerState
## Quieto en el piso.

const ROLL_ANIMATION := "player_roll"
const REST_FRAMES := 3

var waiting_for_rest_frame := false


func enter(previous_state: StringName) -> void:
	var previous_state_name := String(previous_state).to_lower()
	if previous_state_name == "roll":
		waiting_for_rest_frame = true
		_pause_on_rest_frame()
		return

	waiting_for_rest_frame = false
	if previous_state_name == "fall":
		player.sprite.speed_scale = 1.0
		player.sprite.play(ROLL_ANIMATION)
		player.sprite.frame = 3
		player.sprite.frame_progress = 0.0
		player.sprite.pause()
		return

	super(previous_state)


func update(_delta: float) -> void:
	if waiting_for_rest_frame:
		_pause_on_rest_frame()


func _pause_on_rest_frame() -> void:
	if REST_FRAMES == player.sprite.frame:
		player.sprite.pause()
		waiting_for_rest_frame = false


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.velocity.y = lerp(player.velocity.y, 0.0, SLIDE)
	player.move_and_slide()

	if not player.is_on_floor():
		transitioned.emit(self, &"fall")
	elif player.get_move_direction() != 0.0:
		transitioned.emit(self, &"roll")
