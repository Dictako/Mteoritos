class_name Proyectil
extends Area2D


##Atributos
var velocidad:Vector2 = Vector2.ZERO
var danio:int = 40

##Metodos
func _physics_process(delta: float) -> void:
	position += velocidad * delta

func daniar(otro_cuerpo: CollisionObject2D) ->void:
	print(otro_cuerpo.name)
	if otro_cuerpo.has_method("recibir_danio"):
		
		otro_cuerpo.recibir_danio(danio)
		
	queue_free()



##Constructor
func crear(pos: Vector2, dir:float, vel:int, danio_p:int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_ProyectilBase_body_entered(body: Node) -> void:
	daniar(body)


func _on_ProyectilBase_area_entered(area: Area2D) -> void:
	daniar(area)
