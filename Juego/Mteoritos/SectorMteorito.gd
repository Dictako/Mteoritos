class_name SectorMteorito
extends Node2D

##Atributos export
export var cantidad_mteoritos:int = 10
export var intervalo_tiempo:float = 1.2

##Atributos
var spawners:Array

##Metodos
func _ready() -> void:
	almacenar_spawners()
	$SpawnerTimer.wait_time = intervalo_tiempo
	
##Metodos Customs
func almacenar_spawners() -> void:
	for spawn in $Spawners/SpawnerCentro.get_children():
		spawners.append(spawn)
	for spawn in $Spawners/SpawnerEsquina.get_children():
		spawners.append(spawn)
	for spawn in $Spawners/SpawnerIntermedio/ArribaAbajo.get_children():
		spawners.append(spawn)
	for spawn in $Spawners/SpawnerIntermedio/DerechaIzquierda.get_children():
		spawners.append(spawn)

func randomizar_spawn() -> int:
	randomize()
	return randi() % spawners.size()



func conectar_saniales() -> void:
	for detector in $DetctorFueraZona:
		detector.connect("body_entered", self, "_on_detector_body_entered")
		detector.connect("body_entered", self, "_on_FueraZonaIzquierda_body_entered")
		detector.connect("body_entered", self, "_on_FueraZonaArriba_body_entered")
		detector.connect("body_entered", self, "_on_FueraZonaAbajo_body_entered")

##Señales Internas
func _on_SpawnerTimer_timeout() -> void:
	var prueba = randomizar_spawn()
	if cantidad_mteoritos == 0:
		$SpawnerTimer.stop()
		return
	
	spawners[prueba].spawnear_mteoritos()
	cantidad_mteoritos -= 1


func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)



func _on_FueraZonaIzquierda_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)


func _on_FueraZonaArriba_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)


func _on_FueraZonaAbajo_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)
