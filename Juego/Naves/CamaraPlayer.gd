extends CamaraJuego
class_name CamaraPlayer

##Atributos Export
export var variazcion_zoom:float = 0.1
export var zoom_maximo:float = 0.8
export var zoom_minimo:float = 1.5

##Metodos
func _unhandled_input(event: InputEvent) -> void:
	#Control zoom
		if event.is_action_pressed("zoom_alejar"):
			controlar_zoom(variazcion_zoom)
		elif event.is_action_pressed("zoom_acercar"):
			controlar_zoom(-variazcion_zoom)

##Metodos Customs
func controlar_zoom(mod_zoom) -> void:
	zoom.x += clamp(zoom.x + mod_zoom, zoom_minimo, zoom_maximo)
	zoom.y += clamp(zoom.y + mod_zoom, zoom_minimo, zoom_maximo)
