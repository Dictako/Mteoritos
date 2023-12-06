class_name Nivel
extends Node2D

##Atributos onready
onready var contenedor_disparos: Node
onready var contenedor_mteoritos: Node
onready var contenedor_sector_mteoritos: Node
onready var contenedor_enemigo: Node
onready var actualizador_timer: Timer = $ActualizadorTimer
onready var camara_nivel:Camera2D = $CamaraNivel
onready var camara_player:Camera2D = $Player/CamaraPlayer

##Atributos export
export var explosion:PackedScene = null
export var mteorito: PackedScene = null
export var explosion_mteorito: PackedScene = null
export var sector_mteoritos: PackedScene = null
export var enemigo_interceptor: PackedScene = null
export var tiempo_transcision_camara: float = 1.2
export var rele_de_massa: PackedScene = null
export var tiempo_limite:int = 10
export var musica_nivel:AudioStream = null
export var musica_peligro:AudioStream = null
export (String, FILE, "*tscn") var prox_nivel = null



##Atributos
var nume_enemigos_base = 0
var mteoritos_restantes = 0
var player:Player = null

##Metodos
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MusicaJuego.set_streams(musica_nivel, musica_peligro)
	MusicaJuego.play_musica_nivel()
	Eventos.emit_signal("nivel_iniciado")
	Eventos.emit_signal("actualizar_tiempo_restante", tiempo_limite)
	conectar_seniales()
	crear_contededores()
	nume_enemigos_base = contabilizar_enemigos()
	player = DatosJuegos.get_player_actual()
	actualizador_timer.start()


##Metodos Customs
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparando")
	Eventos.connect("destruir", self, "_on_destruir")
	Eventos.connect("spawn_mteoritos", self, "_on_spawn_mteoritos")
	Eventos.connect("mteorito_destruido", self, "_on_explosion_mteorito")
	Eventos.connect("nave_en_sector_peligro", self, "_on_nave_sector_peligro")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("base_destruida", self, "_on_base_destruida")
	Eventos.connect("spawn_orbital", self, "_on_spawn_orbital")
	Eventos.connect("nivel_completado", self, "_on_nivel_completado")
	
func destruir_nivel() -> void:
	crear_explosion(
		player.global_position,
		2,
		1.5,
		Vector2(300.0, 200.0)
	)
	player.me_muero()



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
	
	contenedor_enemigo = Node.new()
	contenedor_enemigo.name = "ContenedorEnemigo"
	add_child(contenedor_enemigo)

func contabilizar_enemigos() -> int:
	return $ContenedorBaseEnemiga.get_child_count()


func crear_rele() -> void:
	var new_rele_masa:ReleDeMassa = rele_de_massa.instance()
	var pos_aleatoria: Vector2 = crear_posicion_aleatoria(400.0, 200.0)
	var margen:Vector2 = Vector2(600.0, 600.0)
	if pos_aleatoria.x < 0:
		margen.x *= -1
	if pos_aleatoria.y < 0:
		margen.y *= -1
	
	new_rele_masa.global_position = player.global_position + (margen + pos_aleatoria)
	add_child(new_rele_masa)


func _on_disparando(proyectil: Proyectil) -> void:
	contenedor_disparos.add_child(proyectil)
	
func _on_destruir(posicion: Vector2) -> void:
	var new_explosion:Node2D = explosion.instance()
	new_explosion.global_position = posicion
	add_child(new_explosion)
	

func _on_nave_destruida(nave: Player, posicion: Vector2, num_explosiones: int) -> void:
	if nave is Player:
		transicion_camaras(
			posicion,
			posicion + crear_posicion_aleatoria(-200.0, 200.0),
			camara_nivel,
			tiempo_transcision_camara
		)
		$RestartTimer.start()
	crear_explosion(posicion, num_explosiones, 0.6, Vector2(100.0, 50.0))
	
	for _i in range(num_explosiones):
		var new_explosion: Node2D = explosion.instance()
		new_explosion.global_position = posicion + crear_posicion_aleatoria(100.0, 50.0)
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6), "timeout")



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
	
	controlar_mteoritos_restantes()

func _on_base_destruida(pos_partes: Array) -> void:
	for posicion in pos_partes:
		crear_explosion(posicion, 1)
		yield(get_tree().create_timer(0.5), "timeout")
		
		nume_enemigos_base -= 1
		if nume_enemigos_base == 0:
			crear_rele()

func _on_spawn_orbital(enemigo:EnemigoOrbital) -> void:
	contenedor_enemigo.add_child(enemigo)

func _on_nivel_completado() -> void:
	Eventos.emit_signal("nivel_terminado")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene(prox_nivel)

func crear_explosion(
		posicion: Vector2,
		numero: int,
		intervalo:float = 0.0,
		rangos_aleatorios: Vector2 = Vector2(0.0, 0.0)
	) -> void:
		for _i in range(numero):
			var new_explosion: Node2D = explosion.instance()
			new_explosion.global_position = posicion + crear_posicion_aleatoria(
				rangos_aleatorios.x,
				rangos_aleatorios.y
			)
			add_child(new_explosion)
			yield(get_tree().create_timer(intervalo), "timeout")

func crear_sector_mteorito(centro_camara:Vector2, numero_peliro:int) -> void: 
	MusicaJuego.transcision_musica()
	mteoritos_restantes = numero_peliro
	var new_sector_mteorito: SectorMteorito = sector_mteoritos.instance()
	new_sector_mteorito.global_position = centro_camara
	contenedor_sector_mteoritos.add_child(new_sector_mteorito)
	camara_nivel.zoom = camara_player.zoom
	camara_nivel.devolver_zoom_original()
	transicion_camaras(
		camara_player.global_position,
		camara_nivel.global_position,
		camara_nivel,
		tiempo_transcision_camara * 10
		)

func crear_sector_enemigo(num_enemigos:int) -> void:
	for _i in range(num_enemigos):
		var new_interceptor:Interceptor = enemigo_interceptor.instance()
		var spaw_pos: Vector2 = crear_posicion_aleatoria(1000.0, 800.0)
		new_interceptor.global_position = player.global_position + spaw_pos
		contenedor_enemigo.add_child(new_interceptor)



func controlar_mteoritos_restantes() -> void:
	mteoritos_restantes -= 1
	Eventos.emit_signal("cambio_numero_mteoritos", mteoritos_restantes)
	if mteoritos_restantes == 0:
		MusicaJuego.transcision_musica()
		contenedor_sector_mteoritos.get_child(0).queue_free()
		camara_player.set_puede_hacer_zoom(true)
		var zoom_actual = camara_player.zoom
		camara_player.zoom = camara_nivel.zoom
		camara_player.zoom_suavizado(zoom_actual.x, zoom_actual.y, 1.0)
		transicion_camaras(
			camara_nivel.global_position,
			camara_player.global_position,
			camara_player,
			tiempo_transcision_camara * 10
		)	
	
func _on_nave_sector_peligro(centrocam:Vector2, tipo_peligro:String, cant_peligro:int)-> void:
	if tipo_peligro == "Mteorito":
		crear_sector_mteorito(centrocam, cant_peligro)
		Eventos.emit_signal("cambio_numero_mteoritos", cant_peligro)
	elif tipo_peligro == "Enemigo":
		crear_sector_enemigo(cant_peligro)

func crear_posicion_aleatoria(rango_horizontal:float, rango_vertical:float) -> Vector2:
	randomize()
	var rang_x = rand_range(-rango_horizontal, rango_horizontal)
	var rang_y = rand_range(-rango_vertical, rango_vertical)
	
	return Vector2(rang_x, rang_y)


func transicion_camaras(
	desde:Vector2, 
	hasta:Vector2, 
	camara_actual: Camera2D,
	tiempo_transcicion: float) -> void:
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transcicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	camara_actual.current = true
	$TweenCamara.start()


func _on_TweenCamara_tween_completed(object: Object, _key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position


func _on_RestartTimer_timeout() -> void:
	Eventos.emit_signal("nivel_terminado")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()


func _on_ActualizadorTimer_timeout() -> void:
	tiempo_limite -= 1
	if tiempo_limite == 0:
		destruir_nivel()
