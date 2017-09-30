extends Area2D

signal exploded

var velocity = 150
var velocity_adjustment = 1.0
var row_number = -1
var column_number = -1
var invader_type

enum Travelling {
	LEFT,
	RIGHT,
	DOWN,
	STATIONARY
}

var screen_size
var pos = Vector2()
var left_blip = Vector2(-global.side_step, 0)
var right_blip = Vector2(global.side_step, 0)
var down_blip = Vector2(0, global.down_step)
var currently_travelling = Travelling.RIGHT
var direction = Vector2(1, 0)
var target_pos = Vector2()

func _ready():
	add_to_group("invaders")
	screen_size = get_viewport_rect().size
	
func setup(type):
	invader_type = type
	get_node(type).show()
	pos = get_pos()
	
func _process(delta):
	pos += velocity * velocity_adjustment * delta * direction
	if currently_travelling == Travelling.RIGHT:
		if pos.x > target_pos.x:
			pos.x = target_pos.x
			currently_travelling = Travelling.STATIONARY
	if currently_travelling == Travelling.LEFT:
		if pos.x < target_pos.x:
			pos.x = target_pos.x
			currently_travelling = Travelling.STATIONARY
	if currently_travelling == Travelling.DOWN:
		if pos.y > target_pos.y:
			pos.y = target_pos.y
			currently_travelling = Travelling.STATIONARY
	if currently_travelling == Travelling.STATIONARY:			
		set_process(false)
	set_pos(pos)

func blip_left():
	currently_travelling = Travelling.LEFT
	direction = Vector2(-1, 0)
	target_pos = get_pos() + left_blip
	set_process(true)

func blip_right():
	currently_travelling = Travelling.RIGHT
	direction = Vector2(1, 0)
	target_pos = get_pos() + right_blip
	set_process(true)

func blip_down():
	currently_travelling = Travelling.DOWN
	direction = Vector2(0, 1)
	target_pos = get_pos() + down_blip
	set_process(true)

func continuous_right():
	if currently_travelling != Travelling.RIGHT:
		currently_travelling = Travelling.RIGHT
		direction = Vector2(1, 0)
		target_pos = Vector2(screen_size.width - global.margin_side, get_pos().y)
		set_process(true)
	
func continuous_left():
	if currently_travelling != Travelling.LEFT:
		currently_travelling = Travelling.LEFT
		direction = Vector2(-1, 0)
		target_pos = Vector2(global.margin_side, get_pos().y)
		set_process(true)
	
func is_at_left_limit():
	return pos.x <= global.margin_side

func is_at_right_limit():
	var right_limit = screen_size.width - global.margin_side
	return pos.x >= right_limit

func is_stationary():
	return currently_travelling == Travelling.STATIONARY

func explode():
	emit_signal("exploded", self)
	queue_free()
