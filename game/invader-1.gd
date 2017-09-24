extends Area2D

export var velocity = 150
export var margin_side = 280
export var step_down = 50

signal invader_direction_change

enum Travelling {
	LEFT,
	RIGHT,
	DOWN_THEN_RIGHT,
	DOWN_THEN_LEFT
}

var screen_size
var pos = Vector2()
var currently_travelling = Travelling.RIGHT
var direction = Vector2(1, 0)
var velocity_adjustment = 1.0
var pos_at_turn = Vector2()

func _ready():
	add_to_group("invaders")
	screen_size = get_viewport_rect().size
	
func start():
	pos = get_pos()
	pos_at_turn = get_pos()
	set_process(true)
	
func _process(delta):
	pos += velocity * velocity_adjustment * delta * direction
	var right_limit = screen_size.width - margin_side
	var finished_going_down = pos.y > pos_at_turn.y + step_down
	set_pos(pos)
	if pos.x > right_limit && currently_travelling == Travelling.RIGHT:
		emit_signal("invader_direction_change", Travelling.DOWN_THEN_LEFT)			
	if pos.x < margin_side && currently_travelling == Travelling.LEFT:
		emit_signal("invader_direction_change", Travelling.DOWN_THEN_RIGHT)
	if finished_going_down && currently_travelling == Travelling.DOWN_THEN_RIGHT:
		emit_signal("invader_direction_change", Travelling.RIGHT)
	if finished_going_down && currently_travelling == Travelling.DOWN_THEN_LEFT:
		emit_signal("invader_direction_change", Travelling.LEFT)

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
	pos_at_turn = get_pos()
		
func explode():
	queue_free()
