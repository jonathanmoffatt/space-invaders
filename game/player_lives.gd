extends Area2D

var ship_sprites = []

func _ready():
	var screen_size = get_viewport_rect().size
	set_global_pos(Vector2(screen_size.width - 170, screen_size.height - 40))
	ship_sprites.append(get_node("1"))
	ship_sprites.append(get_node("2"))
	ship_sprites.append(get_node("3"))

func set_lives(lives):
	var i = 1
	for ship_sprite in ship_sprites:
		if i <= lives:
			ship_sprite.show()
		else:
			ship_sprite.hide()
		i += 1
