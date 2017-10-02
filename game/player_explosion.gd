extends AnimatedSprite

func _on_player_explosion_finished():
	hide()
	set_frame(0)
