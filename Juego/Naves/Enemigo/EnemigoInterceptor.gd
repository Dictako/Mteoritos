class_name Interceptor
extends EnemigoBase

##Enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATANCANDOP, PERSECUCION}

#Atributos
var estado_ia_actual: int = ESTADO_IA.IDLE

##Metodos Customs
func controlar_estado(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
		ESTADO_IA.ATANCANDOP:
			canion.set_esta_disparando(true)
		ESTADO_IA.PERSECUCION:
			canion.set_esta_disparando(false)
		_:
			printerr("Hay un error")
	estado_ia_actual = nuevo_estado
##Señales Internas
func _on_AreaDectectarEnemigo_body_entered(body: Node) -> void:
	controaldor_de_estados(ESTADO_IA.ATANCANDOQ)

func _on_AreaDectectarEnemigo_body_exited(body: Node) -> void:
	controaldor_de_estados(ESTADO_IA.ATACANDOP)

func _on_AreaDisparo_body_entered(body: Node) -> void:
	controaldor_de_estados(ESTADO_IA.ATANCANDOP)

func _on_AreaDisparo_body_exited(body: Node) -> void:
	controaldor_de_estados(ESTADO_IA.PERSECUCION)
