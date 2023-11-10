class_name EstacionReacarga
extends Node2D


##Atribustos export
export var energia: float = 6.0
export var radio_energia_entregada:float = 0.05

##Atributos
var nave_player: Player = null
var player_en_zona: bool = false

##Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	energia -= radio_energia_entregada
	
	if event.is_action_pressed("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action_pressed("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)

##Metdos Customs
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action_pressed("recargar_escudo") or event.is_action_pressed("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		return true
	
	return false
	
##Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruirse"):
		body.destruirse()
	elif body.has_method("me_muero"):
		body.me_muero()


func _on_AreaRecarga_body_entered(body: Node) -> void:
	body.set_gravity_scale(0.1)


func _on_AreaRecarga_body_exited(body: Node) -> void:
	body.set_gravity_scale(0.0)
