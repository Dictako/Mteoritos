class_name EnemigoBase
extends NaveBase

##Atributos
var player_objetivo:Player = null
var dir_player:Vector2
var frame_actual: int = 0

##Atributos export
export var nave_destruida: bool

func _ready() -> void:
	player_objetivo = DatosJuegos.get_player_actual()
	Eventos.connect("nave_destruida", self, "on_nave_destruida")

func _physics_process(_delta: float) -> void:
	frame_actual += 1
	if frame_actual % 3 == 0:
		rotar_hacia_player()

##Metodos customs
func rotar_hacia_player() -> void:
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()

func _on_nave_destruida(nave:NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		player_objetivo = null
	if nave.is_in_group("minimapa"):
		Eventos.emit_signal("minimpa_objeto_destruido", self)

##Señales Internas
func _on_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.me_muero()
		me_muero()
