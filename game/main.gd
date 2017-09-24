extends Node

var squadron = []
var horizontal_count = 11
var row_count = 5
var travelling = Travelling.RIGHT
var current_row = 0
var initial_row_wait_time = 0.2
var last_message

onready var movement_timer = get_node("movement_timer")

enum Travelling {
	LEFT,
	RIGHT,
	DOWN
}

func _ready():
	var invader_template = get_node("invader-template")
	for j in range(row_count):
		var row = []
		for i in range(horizontal_count):
			var invader = invader_template.duplicate()
			self.add_child(invader)
			row.append(weakref(invader))
			invader.set_pos(Vector2(i*150 + 150, j*120 + 100))
		squadron.append(row)
	start()
	
func start():	
	for invader in get_all_invaders():
		invader.start()
	start_wave()

func start_wave():
	current_row = 0
	if travelling == Travelling.LEFT && is_on_left_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.RIGHT && is_on_right_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.DOWN:
		travelling = Travelling.RIGHT if is_on_left_limit() else Travelling.LEFT
	var wait_time = initial_row_wait_time * get_proportion_remaining()
	movement_timer.set_wait_time(wait_time)
	for invader in get_all_invaders():
		invader.velocity_adjustment = 1 / get_proportion_remaining()
	movement_timer.start()
				
func get_all_invaders():
	var all = []
	for row in squadron:
		for inv in row:
			var invader = inv.get_ref()
			if invader:
				all.append(invader)
	return all
	
func get_invaders_by_row(row):
	var invaders = []
	for inv in squadron[row]:
		var invader = inv.get_ref()
		if invader:
			invaders.append(invader)
	return invaders

func get_invader_count():
	return get_all_invaders().size()

func is_on_left_limit():
	for invader in get_all_invaders():
		if invader.is_at_left_limit():
			return true
	return false

func is_on_right_limit():
	for invader in get_all_invaders():
		if invader.is_at_right_limit():
			return true
	return false

func get_proportion_remaining():
	var number_remaining = get_invader_count()
	var total = horizontal_count * row_count
	var number_of_rows_remaining = ceil(float(number_remaining) / horizontal_count)
	var proportion = number_of_rows_remaining / row_count if number_remaining > 6 else float(number_remaining) / total
	global.print_debounce("get_proportion_remaining", "number_remaining=%s; proportion=%s" % [number_remaining, proportion])
	return proportion

func _on_movement_timer_timeout():
	var row_index = current_row if travelling != Travelling.DOWN else row_count - current_row - 1
	for invader in get_invaders_by_row(row_index):
		if travelling == Travelling.LEFT:
			invader.blip_left()
		if travelling == Travelling.RIGHT:
			invader.blip_right()
		if travelling == Travelling.DOWN:
			invader.blip_down()
	current_row += 1
	if current_row < row_count:
		movement_timer.start()
	else:
		start_wave()
