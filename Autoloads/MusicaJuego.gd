extends Node

##Atributos export
export var tiempo_transicion: float = 4.0
export (float, -50.0, -20.0, 5.0) var volumen_apagado = -40


##Atributos onready
onready var musica_nivel:AudioStreamPlayer = $MusicaNivel
onready var musica_peligro:AudioStreamPlayer = $MusicaPeligro
onready var tween_on: Tween = $TweenMusicaOn
onready var tween_off: Tween = $TweenMusicaOff
onready var lista_musicas: Dictionary = {
	"menu_principal": $MusicaMenuPrincipal
	} setget ,get_lista_musicas

##Atributos
var vol_original_musica_off: float = 0.0

##Setters & Getters
func get_lista_musicas() -> Dictionary:
	return lista_musicas
##Metodso Custom
func set_streams(stream_musica:AudioStream, stream_peligro:AudioStream) -> void:
	musica_nivel.stream = stream_musica
	musica_peligro.stream = stream_peligro

func play_boton() -> void:
	$MenuBoton.play()


func play_musica_nivel() -> void:
	stop_todo()
	musica_nivel.play()

func stop_todo() -> void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()

func musica_play(musica:AudioStreamPlayer) -> void:
	stop_todo()
	musica.play()

func transcision_musica() -> void:
	if musica_nivel.playing:
		fade_in(musica_peligro)
		fade_out(musica_nivel)
	else:
		fade_in(musica_nivel)
		fade_out(musica_peligro)

func fade_in(musica_fade_in:AudioStreamPlayer) -> void:
	var volumen_original = musica_fade_in.volume_db
	musica_fade_in.volume_db = volumen_apagado
	musica_fade_in.play()
	tween_on.interpolate_property(
		musica_fade_in,
		"volume_db",
		volumen_apagado,
		volumen_original,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_on.start()


func fade_out(musica_fade_out:AudioStreamPlayer) -> void:
	vol_original_musica_off = musica_fade_out.volume_db
	tween_on.interpolate_property(
		musica_fade_out,
		"volume_db",
		musica_fade_out.volume_db,
		volumen_apagado,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_on.start()



func _on_TweenMusicaOff_tween_completed(object: Object, _key: NodePath) -> void:
	object.stop()
	object.volume_db = vol_original_musica_off
