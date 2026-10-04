extends CanvasLayer

signal solicitud_reinicio

@onready var contador = $VBoxContainer/Contador
@onready var botonReinicio = $VBoxContainer/ReiniciarNivel
func _ready() -> void:
	visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func actualizar_contador(segundos: int):
	contador.text = str(segundos)
	
func habilitar_boton(valor: bool):
	botonReinicio.disabled = !valor	



func _on_reiniciar_nivel_pressed() -> void:
	solicitud_reinicio.emit() # Replace with function body.
