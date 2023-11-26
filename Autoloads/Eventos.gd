extends Node


signal disparo(proyectil)
signal destruir(posicion)
signal base_destruida(base, posicion)
signal spawn_mteoritos(posicion, direccion, tamanio)
signal mteorito_destruido(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, cant_peligro)
signal nave_destruida(nave, posicion, explosiones)
signal spawn_orbital(orbital)
#HUD
signal nivel_iniciado()
signal nivel_terminado()
signal deteccion_zona_recarga(entrando)
signal cambio_numero_mteoritos(numero)
signal actualizar_tiempo_restante(tiempo_restante)
signal cambio_energia_laser(energia_max, energia_actual)
signal ocultar_energia_laser()
signal cambio_energia_escudo(energia_max, energia_actual)
signal ocultar_energia_escudo()
