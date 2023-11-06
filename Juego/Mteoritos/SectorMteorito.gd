extends Node2D




func _on_SpawnerTimer_timeout() -> void:
	for spawn in $Spawners/SpawnerCentro.get_children():
		spawn.spawnear_mteoritos()
	for spawn in $Spawners/SpawnerEsquina.get_children():
		spawn.spawnear_mteoritos()
	for spawn in $Spawners/SpawnerIntermedio/ArribaAbajo.get_children():
		spawn.spawnear_mteoritos()
	for spawn in $Spawners/SpawnerIntermedio/DerechaIzquierda.get_children():
		spawn.spawnear_mteoritos()
