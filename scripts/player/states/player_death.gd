extends PlayerState

const RESTART_DELAY := 5.0

var time_since_death := 0.0
func enter(_previous_state: StringName) -> void:
	player.velocity = Vector2.ZERO
	time_since_death = 0.0
	super(_previous_state)


func update(delta: float) -> void:
	time_since_death += delta
	var menuReinicio= get_tree().current_scene.get_node("Player/RestartScreen")
	menuReinicio.visible = true
	menuReinicio.actualizar_contador(maxf(ceil(RESTART_DELAY - time_since_death), 0))
	menuReinicio.habilitar_boton(time_since_death >= RESTART_DELAY)


func physics_update(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if time_since_death < RESTART_DELAY:
		return
	if event.is_action_pressed(&"ui_restart_level"):
		get_tree().reload_current_scene()
