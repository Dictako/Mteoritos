class_name BaseEnemiga
extends Node2D

##Atributos export
export var hit_points: float = 160.0

##Atributos onready
onready var impactos_sfx: AudioStreamPlayer = $ImpactoSfx

##Atributos
var esta_destruida: bool = false

##Metodos
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aletoria())


##Metodos Customs
func elegir_animacion_aletoria() -> String:
	randomize()
	var num_anim: int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria: int = randi() % num_anim + 1
	var lista_anim: Array = $AnimationPlayer.get_animation_list()
	
	return lista_anim[indice_anim_aleatoria]


func recibir_danio(danio: int) -> void:
	hit_points -= danio
	if hit_points <= 0.0 and not esta_destruida:
		esta_destruida = true
		queue_free()
	
	impactos_sfx.play()

func destruir() -> void:
	var posicion_partes: Array = [
		$Sprites/parte_estacion1.global_position,
		$Sprites/parte_estacion2.global_position,
		$Sprites/parte_estacion3.global_position,
		$Sprites/parte_estacion4.global_position
	]
	Eventos.emit_signal("base_destruida", posicion_partes)
	queue_free()
	
	
##Señales Internas
func _on_AraeColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
