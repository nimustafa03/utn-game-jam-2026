extends Control

@export var LEVEL_1_SCENE : String
@export var OPTIONS_SCENE : String 

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("(ruta de la escena)")


func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("(ruta de la escena)")


func _on_salir_pressed() -> void:
	get_tree().quit()
