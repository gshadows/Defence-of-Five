extends Building


func _on_destroyed(by_player: bool) -> void:
	Game.building_down(true, by_player)
