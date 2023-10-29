class_name Enemigo
extends Node2D


##Atributos onready
onready var colision:CollisionShape2D = $Area2D/Colision


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.me_muero()
