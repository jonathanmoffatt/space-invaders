extends Area2D

export var velocity = 150
export var margin_side = 100
export var margin_top = 100
export var step_down = 50

var screen_size
var pos = Vector2()
var direction = Vector2(1, 0)
var pos_at_turn = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	pos.x = margin_side
	pos.y = margin_top
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	pos += velocity * delta * direction
	if pos.x > (screen_size.width - margin_side):
		pos.x = screen_size.width - margin_side
		direction = Vector2(0, 1)
		velocity *= 0.5
		pos_at_turn = pos
	if pos.x < margin_side:
		pos.x = margin_side
		direction = Vector2(0, 1)
		velocity *= 0.5
		pos_at_turn = pos
	if direction.y != 0 && pos.y > pos_at_turn.y + step_down:
		if pos.x == margin_side:
			direction = Vector2(1, 0)
		else:
			direction = Vector2(-1, 0)
		velocity *= 2
	set_pos(pos)