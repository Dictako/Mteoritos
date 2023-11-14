extends Area2D

##Atributos expor
export (String, "Vacio", "Mteorito", "Enemigo") var tipo_peligro
export var numero_peligros: int = 10


##Señales Internas
func _on_SectorDePeligro_body_entered(_body: Node) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.1), "timeout")
	enviar_seniales()


func enviar_seniales()-> void:
	Eventos.emit_signal(
		"nave_en_sector_peligro",
		$PosicionCentroSector.global_position,
		tipo_peligro,
		numero_peligros)
	queue_free()
