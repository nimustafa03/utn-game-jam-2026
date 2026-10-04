extends Node
## Autoload: configuración básica de ventana para PC.
## F11 alterna pantalla completa. ESC sale de pantalla completa.

const MIN_WINDOW_SIZE := Vector2i(640, 360)


func _ready() -> void:
	get_window().min_size = MIN_WINDOW_SIZE


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_F11:
			toggle_fullscreen()
		KEY_ESCAPE:
			if is_fullscreen():
				set_fullscreen(false)


func is_fullscreen() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func set_fullscreen(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func toggle_fullscreen() -> void:
	set_fullscreen(not is_fullscreen())
