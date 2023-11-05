class_name Mteorito
extends RigidBody2D

##Atributos export
export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var puntos_vida_base:float = 10.0


##Atributos
var puntos_vida: float = 10.0


##Metodos
func _ready() -> void:
	angular_velocity = vel_ang_base


##Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float) -> void:
	position = pos
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x /2.4 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	linear_velocity = vel_lineal_base * dir / tamanio
	angular_velocity = vel_ang_base / tamanio
	puntos_vida = puntos_vida_base * tamanio
	
	
	
	
	
	
