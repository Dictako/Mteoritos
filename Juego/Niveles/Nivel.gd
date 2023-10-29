class_name Nivel
extends Node2D

##Atributos onready
onready var contenedor_disparos: Node

##Atributos export
export var explosion:PackedScene = null


##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contededores()
	
	


##Metodos Customs
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparando")
	Eventos.connect("destruir", self, "_on_destruir")
	
func crear_contededores() -> void:
	contenedor_disparos = Node.new()
	contenedor_disparos.name = "ContenedorDisparo"
	add_child(contenedor_disparos)

func _on_disparando(proyectil: Proyectil) -> void:
	add_child(proyectil)
	
func _on_destruir(posicion: Vector2) -> void:
	var new_explosion:Node2D = explosion.instance()
	new_explosion.global_position = posicion
	add_child(new_explosion)
