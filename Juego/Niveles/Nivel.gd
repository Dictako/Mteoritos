class_name Nivel
extends Node2D

##Atributos onready
onready var contenedor_disparos: Node


##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contededores()
	


##Metodos Customs
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparando")
	
func crear_contededores() -> void:
	contenedor_disparos = Node.new()
	contenedor_disparos.name = "ContenedorDisparo"
	add_child(contenedor_disparos)


func _on_disparando(proyectil: Proyectil) -> void:
	add_child(proyectil)
