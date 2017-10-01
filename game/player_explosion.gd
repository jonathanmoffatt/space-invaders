extends AnimatedSprite

func _on_player_explosion_finished():
	queue_free()
