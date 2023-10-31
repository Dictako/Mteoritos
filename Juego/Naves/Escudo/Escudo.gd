class_name Escudo
extends Area2D

##Atributos onready
onready var animacion: AnimationPlayer = $Animation
onready var colision:CollisionShape2D = $Colisonador

##Atributos Export
export var energia: float = 3
export var radio_desgaste: float = -1.6

##Atributos
var esta_activo:bool = false setget ,get_esta_activo

#Metodos
func _process(delta: float) -> void:
	energia += radio_desgaste * delta
	
	if energia <= 0.0:
		desactivar()

func _ready() -> void:
	set_process(false)
	controlar_colisionador(true)

##Setter y Getters
func get_esta_activo() -> bool:
	return esta_activo
	

##Metodos Customs
func controlar_colisionador(esta_desactivado:bool) -> void:
	colision.set_deferred("disabled", esta_desactivado)
	
func activar() -> void:
	if energia <= 0.0:	
		return
	
	esta_activo = true
	controlar_colisionador(false)
	animacion.play("Activandose")
	
func desactivar() -> void:
	print("hola")
	set_process(false)
	esta_activo = false
	controlar_colisionador(true)
	animacion.play_backwards("Activandose")

func _on_AnimationEscudo_animation_finished(anim_name: String) -> void:
	if anim_name == "Activandose" and esta_activo:
		animacion.play("Activo")
		set_process(true)
		


func _on_Escudo_area_entered(area: Area2D) -> void:
	if area.has_method("destruir") and area is Proyectil:
		area.destruir()
