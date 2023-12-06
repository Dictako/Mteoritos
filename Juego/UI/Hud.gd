extends CanvasLayer



##Atributos onready
onready var info_zona_recarga:ContenedorInformacion = $InfoZonaRecarga
onready var info_mteoritos: ContenedorInformacion = $InfoMteoritos
onready var info_tiempo_restante:ContenedorInformacion = $InfoTiempoRestantes
onready var info_laser:ContenedorInformacionEnergia = $InfoLaser
onready var info_escudo:ContenedorInformacionEnergia = $InfoEscudo


##Metodos
func _ready() -> void:
	conectar_seniales()
	
##Metodos Customs
func conectar_seniales() -> void:
	Eventos.connect("nivel_iniciado", self, "fade_out")
	Eventos.connect("nivel_terminado", self, "fade_in")
	Eventos.connect("deteccion_zona_recarga", self, "_on_deteccion_zona_recarga")
	Eventos.connect("cambio_numero_mteoritos", self, "_on_actualizar_info_mteoritos")
	Eventos.connect("actualizar_tiempo_restante", self, "_on_actualizar_info_tiempo")
	Eventos.connect("cambio_energia_laser", self, "_on_actualizar_energia_laser")
	Eventos.connect("ocultar_energia_laser", self, "ocultar")
	Eventos.connect("cambio_energia_escudo", self, "_on_actualizar_energia_escudo")
	Eventos.connect("ocultar_energia_escudo", self, "ocultar")

func fade_in() -> void:
	$FadeCanvas/AnimationPlayer.play("fade_in")

func fade_out() -> void:
	$FadeCanvas/AnimationPlayer.play_backwards("fade_in")

func _on_deteccion_zona_recarga(en_zona: bool) -> void:
	if en_zona:
		info_zona_recarga.mostrar_suavizado()
	else:
		info_zona_recarga.ocultar_suavizado()

func _on_actualizar_info_mteoritos(numero:int) -> void:
	info_mteoritos.mostrar_suavizado()
	info_mteoritos.cambiar_texto(
		"Mteoritos restantes \n {cantidad}".format({"cantidad":numero})
	)

func _on_actualizar_info_tiempo(tiempo_restante:int) -> void:
#warning_ignore:narrowing_conversion
	var minutos:int = floor(tiempo_restante*0.016666666667)
	var segundos:int = tiempo_restante % 60
	info_tiempo_restante.cambiar_texto(
		"Tiempo restante\n%02d:%02d" % [minutos, segundos]
	)
	
	if tiempo_restante % 10 == 0:
		info_tiempo_restante.mostrar_suavizado()
	
	if tiempo_restante == 1:
		info_tiempo_restante.set_auto_ocultar(false)
	elif tiempo_restante == 0:
		info_tiempo_restante.ocultar()

func _on_actualizar_energia_laser(energia_max:float, energia_actual:float) -> void:
	info_laser.mostrar_suavizado()
	info_laser.actualizar_energia(energia_max, energia_actual)

func _on_actualizar_energia_escudo(energia_max:float, energia_actual:float) -> void:
	info_escudo.mostrar_suavizado()
	info_escudo.actualizar_energia(energia_max, energia_actual)

func _on_nave_destruida(_nave:NaveBase, _posiscion, _explosiones) -> void:
	get_tree().call_group("contenedor_info", "set_esta_activo", false)
	get_tree().call_group("contenedor_info", "ocultar")

