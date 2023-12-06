class_name NaveBase
extends RigidBody2D


##Atributos export
export var vida_maxima: float = 100.0
export var cant_explosiones: int = 3


##Atributos simples
var estado_actual:int = ESTADO.SPAWN

##Enum
enum ESTADO {SPAWN,VIVO,MUERTO,INVENCIBLE}

##Atributos onready
onready var colisionador_cuerpo:CollisionShape2D = $ColisonadorCuerpo
onready var indicador_danio:AudioStreamPlayer = $IndicadorDanio
onready var canion:Canion = $CanionBase
onready var barra_salud: ProgressBar = $BarraSalud
##Metodos
func _ready() -> void:
	controaldor_de_estados(estado_actual)
	barra_salud.max_value = vida_maxima
	barra_salud.value = vida_maxima
		

##Metodos Custom	
func controaldor_de_estados(estado:int) -> void:
	match estado:
		ESTADO.SPAWN:
			colisionador_cuerpo.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			canion.set_puede_disparar(true)
			colisionador_cuerpo.set_deferred("disabled", false)
		ESTADO.MUERTO:
			colisionador_cuerpo.set_deferred("disabled", true)
			Eventos.emit_signal("destruir", global_position)
			Eventos.emit_signal("nave_destruida", self, global_position, cant_explosiones)
			queue_free()
			canion.set_puede_disparar(false)
		ESTADO.INVENCIBLE:
			colisionador_cuerpo.set_deferred("disabled", false)
		_:
			pass
	estado_actual = estado
	

func me_muero() -> void:
	controaldor_de_estados(ESTADO.MUERTO)

func recibir_danio(danio: int) -> void:
	vida_maxima -= danio
	if vida_maxima <= 0.0:
		me_muero()
	indicador_danio.play()
	barra_salud.controlar_barra(vida_maxima, true)
	barra_salud.value = vida_maxima


##Señales Internas
func _on_AnimacionPersonaje_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		controaldor_de_estados(ESTADO.VIVO)


func _on_Player_body_entered(body: Node) -> void:
	if body is Mteorito:
		body.destruirse()
		me_muero()


