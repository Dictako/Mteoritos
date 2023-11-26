class_name ReleDeMassa
extends Node2D

##Metodos Customs
func atraer_player(body: Node) -> void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	
	$Tween.start()

##Señales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		$AnimationPlayer.play("Activado")


func _on_DetectorPlayer_body_entered(body: Node) -> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("SuperActivado")
	body.desactivar_controles()
	atraer_player(body)


func _on_Tween_tween_all_completed() -> void:
	print("sos un capo")
