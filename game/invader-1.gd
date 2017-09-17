extends Area2D

export var velocity = 150
export var margin_side = 100
export var margin_top = 100

var screen_size
var pos = Vector2()
var direction = 1

func _ready():
	screen_size = get_viewport_rect().size
	pos.x = margin_side
	pos.y = margin_top
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	pos.x += velocity * delta * direction
	if pos.x > (screen_size.width - margin_side):
		pos.x = screen_size.width - margin_side
		direction = -direction
	if pos.x < margin_side:
		pos.x = margin_side
		direction = -direction
	set_pos(pos)