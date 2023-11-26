class_name Player
extends NaveBase


##Atributos export
export var potencia_motor:int = 18
export var potencia_rotacion:int = 280 
export var estela_maxima:int = 150
##Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
##Atributos onready
onready var escudo:Escudo = $Escudo setget ,get_escudo
onready var laser:Laser = $LaserBeam2D setget ,get_laser
onready var estela:Estela = $PosicionInicialEstela/Estela
onready var motor_ruido: Motor = $MotorRuido
onready var animacion:AnimationPlayer = $AnimacionPersonaje

##Setters & Getters
func get_laser() -> Laser:
	return laser

func get_escudo() -> Escudo:
	return escudo

##Metodos
func _ready() -> void:
	DatosJuegos.set_player_actual(self)

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
	#Control Escudo
	if event.is_action_pressed("activar_desactivar_escudo") and not escudo.get_esta_activo():
		escudo.activar()

func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	apply_central_impulse(empuje.rotated(rotation))


func _process(_delta: float) -> void:
	player_input()

##Metodos Customs
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


	
func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
		
	return true

func desactivar_controles() -> void:
	controaldor_de_estados(ESTADO.SPAWN)
	empuje = Vector2.ZERO
	motor_ruido.sonido_off()
	laser.set_is_casting(false)

func recibir_danio(_danio: int) -> void:
	animacion.play("Recibir_danio")

