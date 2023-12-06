extends ProgressBar
class_name BarraSalud

##Atributos export
export var siemre_visible:bool = false


##Atributos onready
onready var tween_visibilidad: Tween = $TweenVisibilidad
##Métodos
func _ready() -> void:
	modulate = Color(1,1,1,siemre_visible)

##Métodos Custom
func set_valores(hit_points) -> void:
	max_value = hit_points
	value = hit_points

func set_hit_points_actual(hit_points:float) -> void:
	value = hit_points



func controlar_barra(hit_points_nave :float, mostrar: bool) -> void:
	value = hit_points_nave
	if not tween_visibilidad.is_active() and modulate.a !=  int(mostrar):
		tween_visibilidad.interpolate_property(
			self,
			"modulate",
			Color(1,1,1, not mostrar),
			Color(1,1,1, mostrar),
			1.0,
				Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween_visibilidad.start()
	

##Señales Internas
func _on_TweenVisibilidad_tween_all_completed() -> void:
		if modulate.a == 1.0:
			controlar_barra(value, false)
