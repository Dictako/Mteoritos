class_name EstacionReacarga
extends Node2D


##Atribustos export
export var energia: float = 6.0
export var radio_energia_entregada:float = 0.05

##Atributos onready
onready var carga_sfx:AudioStreamPlayer = $CargaSfx

##Atributos
var nave_player: Player = null
var player_en_zona: bool = false

##Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	controlar_energia(radio_energia_entregada)
	
	if event.is_action_pressed("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action_pressed("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)
	
	if event.is_action_released("recargar_laser"):
		Eventos.emit_signal("ocultar_energia_laser")
	elif event.is_action_released("recargar_escudo"):
		Eventos.emit_signal("ocultar_energia_escudo")
##Metdos Customs
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action_pressed("recargar_escudo") or event.is_action_pressed("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			carga_sfx.play()
		return true
	
	return false

func controlar_energia(_consumo:float)-> void:
	energia -= radio_energia_entregada
	if energia <= 0.0:
		$VacioSfx.play()
	
##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruirse"):
		body.destruirse()
	elif body.has_method("me_muero"):
		body.me_muero()


func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		player_en_zona = true
		nave_player = body
		Eventos.emit_signal("deteccion_zona_recarga", true)
	body.set_gravity_scale(0.1)
	


func _on_AreaRecarga_body_exited(body: Node) -> void:
	if body is Player:
		player_en_zona = false
		Eventos.emit_signal("deteccion_zona_recarga", false)
	body.set_gravity_scale(0.0)
