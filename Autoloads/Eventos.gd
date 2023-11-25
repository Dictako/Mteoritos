extends Node


signal disparo(proyectil)
signal destruir(posicion)
signal base_destruida(base, posicion)
signal spawn_mteoritos(posicion, direccion, tamanio)
signal mteorito_destruido(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, cant_peligro)
signal nave_destruida(nave, posicion, explosiones)
signal spawn_orbital(orbital)
