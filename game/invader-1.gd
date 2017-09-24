extends Area2D

export var velocity = 150
export var margin_side = 280
export var step_down = 50
export var side_step = 40

signal invader_direction_change

enum Travelling {
	LEFT,
	RIGHT,
	DOWN,
	STATIONARY
}

var screen_size
var pos = Vector2()
var currently_travelling = Travelling.RIGHT
var direction = Vector2(1, 0)
var velocity_adjustment = 1.0
var pos_at_blip = Vector2()

func _ready():
	add_to_group("invaders")
	screen_size = get_viewport_rect().size
	
func start():
	pos = get_pos()
	
func _process(delta):
	pos += velocity * velocity_adjustment * delta * direction
	set_pos(pos)
	if currently_travelling == Travelling.RIGHT || currently_travelling == Travelling.LEFT:
		var distance = (pos - pos_at_blip).abs().x
		if distance >= side_step:
			set_process(false)
			currently_travelling = Travelling.STATIONARY
	

	# var right_limit = screen_size.width - margin_side
	# var finished_going_down = pos.y > pos_at_blip.y + step_down
	# set_pos(pos)
	# if pos.x > right_limit && currently_travelling == Travelling.RIGHT:
	# 	emit_signal("invader_direction_change", Travelling.DOWN_THEN_LEFT)			
	# if pos.x < margin_side && currently_travelling == Travelling.LEFT:
	# 	emit_signal("invader_direction_change", Travelling.DOWN_THEN_RIGHT)
	# if finished_going_down && currently_travelling == Travelling.DOWN_THEN_RIGHT:
	# 	emit_signal("invader_direction_change", Travelling.RIGHT)
	# if finished_going_down && currently_travelling == Travelling.DOWN_THEN_LEFT:
	# 	emit_signal("invader_direction_change", Travelling.LEFT)

func blip_left():
	print("blip_left")
	currently_travelling = Travelling.LEFT
	direction = Vector2(-1, 0)
	pos_at_blip = get_pos()
	set_process(true)

func blip_right():
	print("blip_right")
	currently_travelling = Travelling.RIGHT
	direction = Vector2(1, 0)
	pos_at_blip = get_pos()
	set_process(true)

func change_direction(new_travel):
	if new_travel == Travelling.RIGHT:
		direction = Vector2(1, 0)
		velocity_adjustment = 1.0
	if new_travel == Travelling.LEFT:
		direction = Vector2(-1, 0)
		velocity_adjustment = 1.0
	if new_travel == Travelling.DOWN_THEN_LEFT || new_travel == Travelling.DOWN_THEN_RIGHT:
		direction = Vector2(0, 1)
		velocity_adjustment = 0.5
	currently_travelling = new_travel
	pos_at_blip = get_pos()
		
func explode():
	queue_free()
