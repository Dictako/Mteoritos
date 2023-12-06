class_name MiniMapa
extends MarginContainer

##Atributos export
export var escala_zoom:float = 4.0

export var tiempo_visible: float = 5.0

##Atributos onready
onready var zona_renderizado:TextureRect = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa
onready var icono_player:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoPlayer
onready var icono_base: Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoBaseEnemiga
onready var icono_estacion:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoEstacion
onready var items_mini_mapa: Dictionary = {}
onready var icono_interceptor: Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoInterceptor
onready var icono_rele: Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoRele
onready var timer_visibilidad: Timer = $TimerVisibilidad
onready var tween_visibilidad:Tween = $TweenVisibilidad

##Atributos
var escala_grilla:Vector2
var player: Player = null
var esta_visible: bool = true setget set_esta_visible

#Setters & Getters
func set_esta_visible(valor:bool) -> void:
	if valor:
		timer_visibilidad.start()
	esta_visible = valor
	
	tween_visibilidad.interpolate_property(
		self,
		"modulate",
		Color(1,1,1, not valor),
		Color(1,1,1, valor),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("minimapa"):
		set_esta_visible(not esta_visible)
##Métodos
func _ready() -> void:
	set_process(false)
	icono_player.position = zona_renderizado.rect_size * 0.5
	escala_grilla = zona_renderizado.rect_size / (get_viewport_rect().size * escala_zoom)
	concetar_seniales()

func _process(_delta:float) -> void:
	if not player:
		return
	modificar_posicion_iconos()
	icono_player.rotation_degrees = player.rotation_degrees + 90

##Métodos Custom
func _on_nave_destruida(nave: NaveBase, _position, _explosiones) -> void:
	if nave is Player:
		player = null

func _on_nivel_iniciado() -> void:
	player = DatosJuegos.get_player_actual()
	obtener_objetos_minimapa()
	set_process (true)

func obtener_objetos_minimapa() -> void:
	var objetos_en_ventana: Array = get_tree().get_nodes_in_group("minimapa")
	for objeto in objetos_en_ventana:
		if not items_mini_mapa.has(objeto):
			var sprite_icono:Sprite
			if objeto is BaseEnemiga:
				sprite_icono = icono_base.duplicate()
			elif objeto is EstacionReacarga:
				sprite_icono = icono_estacion.duplicate()
			elif objeto is Interceptor:
				sprite_icono = icono_interceptor.duplicate()
			elif objeto is ReleDeMassa:
				sprite_icono = icono_rele.duplicate()
			
			items_mini_mapa[objeto] = sprite_icono
			items_mini_mapa[objeto].visible = true
			zona_renderizado.add_child(items_mini_mapa[objeto])
			items_mini_mapa[objeto] = sprite_icono
			items_mini_mapa[objeto].visible = true
			zona_renderizado.add_child(items_mini_mapa[objeto])


func modificar_posicion_iconos() -> void:
	for item in items_mini_mapa:
		var item_icono:Sprite = items_mini_mapa[item] 
		var offset_pos:Vector2 = item.position - player.position
		#var pos_icono:Vector2 = offset_pos * escala_grilla + (zona_renderizado.rect_size() * 0.5)
		var pos_icono:Vector2 = offset_pos * escala_grilla + icono_player.position
		pos_icono.x = clamp(pos_icono.x, 0, zona_renderizado.rect_size.x)
		pos_icono.y = clamp(pos_icono.y, 0, zona_renderizado.rect_size.y)
		item_icono.position= pos_icono

		if zona_renderizado.get_rect().has_point(pos_icono - zona_renderizado.rect_position):
			item_icono.scale = Vector2(0.5, 0.5)
		else:
			item_icono.scale = Vector2(0.3, 0.3)

func concetar_seniales() -> void:
	Eventos.connect("nivel_iniciado",self, "_on_nivel_iniciado")
	Eventos.connect("nave_destruida",self, "_on_nave_destruida")
	Eventos.connect("minimapa_objeto_creado",self, "obtener_objetos_minimapa")
	Eventos.connect("minimpa_objeto_destruido", self, "quitar_icono")



func quitar_icono(objeto:Node2D) -> void:
	if objeto in items_mini_mapa:
		items_mini_mapa[objeto].queue_free()
		items_mini_mapa.erase(objeto)


##Señales Internas
func _on_TimerVisibilidad_timeout() -> void:
	if esta_visible:
		set_esta_visible(false)
