class_name EnemigoBase
extends NaveBase

##Atributos
var player_objetivo:Player = null
var dir_player:Vector2

##Atributos export
export var nave_destruida: bool

func _ready() -> void:
	player_objetivo = DatosJuegos.get_player_actual()
	Eventos.connect("nave_destruida", self, "on_nave_destruida")

func _physics_process(_delta: float) -> void:
	rotar_hacia_player()

##Metodos customs
func rotar_hacia_player() -> void:
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()

func _on_nave_destruida(nave:NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		player_objetivo = null


##Señales Internas
func _on_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.me_muero()
		me_muero()
