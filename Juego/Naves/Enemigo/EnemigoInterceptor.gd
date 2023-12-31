class_name Interceptor
extends EnemigoBase

##Enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

#Atributos export
export var potencia_maxima: float = 8.0

#Atributos
var estado_ia_actual: int = ESTADO_IA.ATACANDOP
var potencia_actual: float = 0.0

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#linear_velocity +=  dir_player.normalized() * potencia_actual * state.get_step()
	pass
	#linear_velocity.x += clamp(linear_velocity.x, -potencia_maxima, potencia_maxima)
	#linear_velocity.y += clamp(linear_velocity.y, -potencia_maxima, potencia_maxima)

func _ready() -> void:
	Eventos.emit_signal("minimapa_objeto_creado")


##Metodos Customs
func controlar_estado(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_puede_disparar(false)
			potencia_actual= 0.0
		ESTADO_IA.ATACANDOQ:
			canion.set_puede_disparar(true)
			potencia_actual= 0.0
		ESTADO_IA.ATACANDOP:
			canion.set_puede_disparar(true)
			potencia_actual= potencia_maxima
		ESTADO_IA.PERSECUCION:
			canion.set_puede_disparar(false)
			potencia_actual= potencia_maxima
		_:
			printerr("Hay un error")
	estado_ia_actual = nuevo_estado



##Señales Internas
func _on_AreaDectectarEnemigo_body_entered(_body: Node) -> void:
	controlar_estado(ESTADO_IA.ATACANDOQ)

func _on_AreaDectectarEnemigo_body_exited(_body: Node) -> void:
	controlar_estado(ESTADO_IA.ATACANDOP)

func _on_AreaDisparo_body_entered(_body: Node) -> void:
	controlar_estado(ESTADO_IA.ATACANDOP)

func _on_AreaDisparo_body_exited(_body: Node) -> void:
	controlar_estado(ESTADO_IA.PERSECUCION)
