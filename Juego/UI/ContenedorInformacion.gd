class_name ContenedorInformacion
extends NinePatchRect

##Atributos export
export var auto_ocultar: bool = false setget set_auto_ocultar


##Atributos onready
onready var texto_contenedor:Label = $Label
onready var animacion: AnimationPlayer = $AnimationPlayer
onready var auto_ocultar_timer :Timer = $AutoOcultarTimer

##Atributos
var esta_activo: bool = true setget set_esta_activo

##Setter & Getters
func set_auto_ocultar(estado: bool) -> void:
	auto_ocultar = estado

func set_esta_activo(estado: bool) ->void:
	esta_activo = estado

##Metodos Customs
func mostrar() -> void:
	if esta_activo:
		animacion.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		animacion.stop()
	animacion.play("ocultar")

func mostrar_suavizado() -> void:
	if not esta_activo:
		return
	animacion.play("MostrarSuavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavizado() -> void:
	if esta_activo:
		animacion.play("OcultarSuavizado")

func cambiar_texto(texto:String) -> void:
	texto_contenedor.text = texto

func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
