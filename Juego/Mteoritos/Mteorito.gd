class_name Mteorito
extends RigidBody2D

##Atributos export
export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var puntos_vida_base:float = 10.0

##Atributos onready
onready var impacto_sfx:AudioStreamPlayer = $AudioDestruir

##Atributos
var puntos_vida: float = 10.0
var esta_en_sector: bool = true setget set_esta_en_sector
var pos_spawn_original:Vector2
var vel_spawn_original:Vector2
var esta_destruido: bool = false


##Metodos
func _ready() -> void:
	angular_velocity = vel_ang_base

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
	
	var mi_transform:=state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector = true

##Setters & Getters
func set_esta_en_sector(valor: bool) -> void:
	esta_en_sector = valor

##Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float) -> void:
	position = pos
	pos_spawn_original = position
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x /2.4 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad()
	vel_spawn_original = linear_velocity
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
	puntos_vida = puntos_vida_base * tamanio


func recibir_danio(danio: float)-> void:
	puntos_vida -= danio
	if puntos_vida <= 0 and not esta_destruido:
		esta_destruido = true
		destruirse()
	impacto_sfx.play()

func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)

func destruirse()-> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("mteorito_destruido", global_position)
	queue_free()

