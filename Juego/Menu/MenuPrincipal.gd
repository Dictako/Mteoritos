extends Node

export (String, FILE, "*tscn") var primer_nivel = null


func _ready() -> void:
	MusicaJuego.musica_play(MusicaJuego.get_lista_musicas().menu_principal)


func _on_BotonJugar_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().change_scene(primer_nivel)


func _on_BotonSalir_pressed() -> void:
	get_tree().quit()
