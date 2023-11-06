class_name Nivel
extends Node2D

##Atributos onready
onready var contenedor_disparos: Node
onready var contenedor_mteoritos: Node

##Atributos export
export var explosion:PackedScene = null
export var mteorito: PackedScene = null
export var explosion_mteorito: PackedScene = null

##Metodos
func _ready() -> void:
	conectar_seniales()
	crear_contededores()
	
	


##Metodos Customs
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparando")
	Eventos.connect("destruir", self, "_on_destruir")
	Eventos.connect("spawn_mteoritos", self, "_on_spawn_mteoritos")
	Eventos.connect("mteorito_destruido", self, "_on_explosion_mteorito")
	
func crear_contededores() -> void:
	contenedor_disparos = Node.new()
	contenedor_disparos.name = "ContenedorDisparo"
	add_child(contenedor_disparos)
	
	contenedor_mteoritos = Node.new()
	contenedor_mteoritos.name = "ContenedorMteoritos"
	add_child(contenedor_mteoritos)

func _on_disparando(proyectil: Proyectil) -> void:
	add_child(proyectil)
	
func _on_destruir(posicion: Vector2) -> void:
	var new_explosion:Node2D = explosion.instance()
	new_explosion.global_position = posicion
	add_child(new_explosion)
	


##Conexion señales externas
func _on_spawn_mteoritos(pos_spawn: Vector2, dir_mteorito:Vector2, tamanio: float) -> void:
	var new_mteorito: Mteorito = mteorito.instance()
	new_mteorito.crear(
		pos_spawn, 
		dir_mteorito, 
		tamanio
		)
	contenedor_mteoritos.add_child(new_mteorito)
	
func _on_explosion_mteorito(pos:Vector2) -> void:
	var new_explosion_mteorito: ExplosionMteorito = explosion_mteorito.instance()
	new_explosion_mteorito.global_position = pos
	add_child(new_explosion_mteorito)
