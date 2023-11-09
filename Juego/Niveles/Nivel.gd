class_name Nivel
extends Node2D

##Atributos onready
onready var contenedor_disparos: Node
onready var contenedor_mteoritos: Node
onready var contenedor_sector_mteoritos: Node
onready var camara_nivel:Camera2D = $CamaraNivel

##Atributos export
export var explosion:PackedScene = null
export var mteorito: PackedScene = null
export var explosion_mteorito: PackedScene = null
export var sector_mteoritos: PackedScene = null
export var tiempo_transcision_camara: float = 1.2

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
	Eventos.connect("nave_en_sector_peligro", self, "_on_nave_sector_peligro")
	
func crear_contededores() -> void:
	contenedor_disparos = Node.new()
	contenedor_disparos.name = "ContenedorDisparo"
	add_child(contenedor_disparos)
	
	contenedor_mteoritos = Node.new()
	contenedor_mteoritos.name = "ContenedorMteoritos"
	add_child(contenedor_mteoritos)
	
	contenedor_sector_mteoritos = Node.new()
	contenedor_sector_mteoritos.name = "ContenedorSectorMteoritos"
	add_child(contenedor_sector_mteoritos)

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

func crear_sector_mteorito(centro_camara:Vector2, numero_peliro:int) -> void: 
	var new_sector_mteorito: SectorMteorito = sector_mteoritos.instance()
	new_sector_mteorito.global_position = centro_camara
	camara_nivel.current = true
	contenedor_sector_mteoritos.add_child(new_sector_mteorito)
	transicion_camaras(
		$Player/CamaraPlayer.global_position,
		camara_nivel.global_position,
		camara_nivel
		)
	
	
	
func _on_nave_sector_peligro(centrocam:Vector2, tipo_peligro:String, cant_peligro:int)-> void:
	if tipo_peligro == "Mteorito":
		crear_sector_mteorito(centrocam, cant_peligro)
	elif tipo_peligro == "Enemigo":
		pass

func transicion_camaras(desde:Vector2, hasta:Vector2,camara_actual: Camera2D) -> void:
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transcision_camara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	camara_actual.current = true
	$TweenCamara.start()
