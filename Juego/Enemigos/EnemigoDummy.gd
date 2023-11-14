class_name Enemigo
extends Node2D


##Atributos onready
onready var colision:CollisionShape2D = $Area2D/Colision


##Atributos
var puntos_vida: float = 100.0

func _process(_delta: float) -> void:
	$CanionBase.set_esta_disparando(true)

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.me_muero()

func recibir_danio(danio: int) -> void:
	if danio > puntos_vida:
		Eventos.emit_signal("destruir", global_position)
		queue_free()
	else:
		puntos_vida -= danio
