class_name Player
extends RigidBody2D


##Atributos export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280 
export var estela_maxima:int = 150

##Atributos simples
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWN

##Enum
enum ESTADO {SPAWN,VIVO,MUERTO,INVENCIBLE}

##Atributos onready
onready var canion:Canion = $CanionBase
onready var laser:Laser = $LaserBeam2D
onready var colisionador_cuerpo:CollisionShape2D = $ColisonadorCuerpo
onready var estela:Estela = $PosicionInicialEstela/Estela
onready var motor_ruido:AudioStreamPlayer = $MotorRuido
onready var animacion:AnimationPlayer = $AnimacionPersonaje

##Metodos
func _ready() -> void:
	controaldor_de_estados(estado_actual)
	
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	apply_central_impulse(empuje.rotated(rotation))
	

func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
		
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
		
	if event.is_action_pressed("Mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_ruido.sonido_on()
	elif event.is_action_pressed("Mover_atras"):
		estela.set_max_points(0)
		motor_ruido.sonido_off()
		
	if event.is_action_released("Mover_adelante"):
		motor_ruido.sonido_off()


func _process(delta: float) -> void:
	player_input()

##Metodos Custom	
func player_input() -> void:
	if not esta_input_activo():
		return
	
	#Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("Mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("Mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
	
	#Rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("Rotar_horario"):
		dir_rotacion += 1
	elif Input.is_action_pressed("Rotar_antihorario"):
		dir_rotacion -= 1
	
	#Disparo
	if Input.is_action_just_pressed("Disparar"):
		canion.set_esta_disparando(true)
		
	if Input.is_action_just_released("Disparar"):
		canion.set_esta_disparando(false)

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
			queue_free()
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador_cuerpo.set_deferred("disabled", false)
		_:
			pass
	estado_actual = estado

func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
		
	return true
	

func me_muero() -> void:
	controaldor_de_estados(ESTADO.MUERTO)


func _on_AnimacionPersonaje_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		controaldor_de_estados(ESTADO.VIVO)
