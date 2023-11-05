class_name MteoritoSpawner
extends Position2D

##Atributos export
export var direccion:Vector2 = Vector2(1, 1)
export var rango_tamanio_mteorito:Vector2 = Vector2(0.5, 2.2)

func _ready() -> void:
	yield(owner, "ready")
	spawnear_mteoritos()

func spawnear_mteoritos() -> void:
	Eventos.emit_signal(
		"spawn_mteoritos", 
		global_position, 
		direccion,
		tamanio_mteorito_aleatorio()
		)


func tamanio_mteorito_aleatorio() -> float:
	randomize()
	return rand_range(rango_tamanio_mteorito[0], rango_tamanio_mteorito[1])
