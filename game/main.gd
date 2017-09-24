extends Node

var squadron = []
var horizontal_count = 11
var row_count = 5
var go_continuous_count = 0
var travelling = Travelling.RIGHT
var continuous = false
var current_row = 0
var initial_row_wait_time = 0.2

onready var move_across_timer = get_node("move_across_timer")
onready var move_down_timer = get_node("move_down_timer")

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
			invader.row_number = j
			invader.column_number = i
			invader.show()
		squadron.append(row)
	start()
	
func start():	
	for invader in get_all_invaders():
		invader.start()
	start_wave()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("tester_nuke") && !event.is_echo():
		var destroy = get_invader_count() / 2
		print("destroying %s" % destroy)
		var destroyed = 0
		for invader in get_all_invaders():
			invader.explode()
			destroyed += 1
			print(destroyed)
			if destroyed >= destroy:
				return

func start_wave():
	current_row = 0
	if travelling == Travelling.LEFT && is_on_left_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.RIGHT && is_on_right_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.DOWN && is_on_left_limit():
		travelling = Travelling.RIGHT
	elif travelling == Travelling.DOWN && is_on_right_limit():
		travelling = Travelling.LEFT
	var wait_time = initial_row_wait_time * get_proportion_remaining()
	move_across_timer.set_wait_time(wait_time)
	for invader in get_all_invaders():
		invader.velocity_adjustment = 1 / get_proportion_remaining()
	continuous = get_invader_count() < go_continuous_count
	move_across_timer.start()

func go_continuous():
	for invader in get_all_invaders():
		if travelling == Travelling.LEFT:
			invader.continuous_left()
		if travelling == Travelling.RIGHT:
			invader.continuous_right()
		if travelling == Travelling.DOWN:
			invader.blip_down()
	move_down_timer.start()
		
func _on_move_across_timer_timeout():
	if continuous:
		go_continuous()
	else:
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
			move_across_timer.start()
		elif travelling == Travelling.DOWN:
			# need to let the top row finish moving down before we change direction and start the next wave 
			move_down_timer.start()
		else:
			start_wave()

func _on_move_down_timer_timeout():
	if any_invader_is_stationary() && continuous:
		start_wave()
	elif all_invaders_are_stationary() && !continuous:
		start_wave()
	else:
		move_down_timer.start()

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

func all_invaders_are_stationary():
	for invader in get_all_invaders():
		if !invader.is_stationary():
			return false
	return true

func any_invader_is_stationary():
	for invader in get_all_invaders():
		if invader.is_stationary():
			return true
	return false

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
	if number_remaining > go_continuous_count:
		return number_of_rows_remaining / row_count  
	else:
		return float(number_remaining) / total

