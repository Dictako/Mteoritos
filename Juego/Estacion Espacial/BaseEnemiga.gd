class_name BaseEnemiga
extends Node2D

##Atributos export
export var hit_points: float = 160.0
export var orbital:PackedScene = null
export var numero_orbitales:int = 10
export var intervalo_spawn:float = 0.8

##Atributos onready
onready var impactos_sfx: AudioStreamPlayer = $ImpactoSfx
onready var ruta_enemigo: Path2D = $RutaEnemiga
onready var timer_spawn:Timer = $TimerSpawnearEnemigos
onready var barra_salud:BarraSalud = $BarraSalud

##Atributos
var esta_destruida: bool = false
var posicion_spawn:Vector2 = Vector2.ZERO


##Metodos
func _ready() -> void:
	timer_spawn.wait_time = intervalo_spawn
	barra_salud.set_valores(hit_points)
	$AnimationPlayer.play(elegir_animacion_aletoria())


func _process(_delta: float) -> void:
	var player_objetivo:Player = DatosJuegos.get_player_actual()
	if not player_objetivo:
		pass
	
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
##Metodos Customs
func elegir_animacion_aletoria() -> String:
	randomize()
	var num_anim: int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria: int = randi() % num_anim + 1
	var lista_anim: Array = $AnimationPlayer.get_animation_list()
	
	return lista_anim[indice_anim_aleatoria]


func recibir_danio(danio: int) -> void:
	hit_points -= danio
	if hit_points <= 0.0 and not esta_destruida:
		esta_destruida = true
		queue_free()
	barra_salud.set_hit_points_actual(hit_points)
	impactos_sfx.play()

func destruir() -> void:
	var posicion_partes: Array = [
		$Sprites/parte_estacion1.global_position,
		$Sprites/parte_estacion2.global_position,
		$Sprites/parte_estacion3.global_position,
		$Sprites/parte_estacion4.global_position
	]
	Eventos.emit_signal("base_destruida", self, posicion_partes)
	Eventos.emit_signal("minimpa_objeto_destruido", self)
	queue_free()
	

func spawnear_orbital() -> void:
	numero_orbitales -= 1
	ruta_enemigo.global_position = global_position
	var new_orbital: EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + posicion_spawn,
		self,
		ruta_enemigo
	)
	Eventos.emit_signal("spawn_orbital", new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo: Player = DatosJuegos.get_player_actual()
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		#Player netra por este
		ruta_enemigo.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		#Player netra por oeste
		ruta_enemigo.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		#Player entra por arriba o por abajo
		if sign(angulo_player) > 0:
			#Player netra por anajo
			ruta_enemigo.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			#Player netra por arriba
			ruta_enemigo.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position
##Señales Internas
func _on_AraeColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawnear_orbital()
	timer_spawn.start()


func _on_TimerSpawnearEnemigos_timeout() -> void:
	if numero_orbitales == 0:
		timer_spawn.stop()
		return
	spawnear_orbital()
