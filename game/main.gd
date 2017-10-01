extends Node

var invader_combinations = [
	["green-2", "green-2", "green-3", "green-3", "green-1"],
	["blue-2", "blue-2", "blue-3", "blue-3", "blue-1"],
	["black-2", "black-2", "black-3", "black-3", "black-1"],
	["red-2", "red-2", "red-3", "red-3", "red-1"]
]
var invader_puff_colours = [
	Color(0.755845, 0.855469, 0.735168, 1),
	Color(0.457184, 0.7554, 0.824219, 0.772549),
	Color(0.934662, 0.956011, 0.960938, 0.772549),
	Color(0.796875, 0.537735, 0.348633, 1)
]
var invader_bullet_delays = [
	0.7,
	0.5,
	0.3,
	0.2
]

export (PackedScene) var invader_bullet

var squadron = []
var horizontal_count = 11
var row_count = 5
var speed_up_threshold = 6
var travelling = global.Travelling.RIGHT
var current_row = 0
var initial_row_wait_time = 0.2
var current_level = 0

onready var move_across_timer = get_node("move_across_timer")
onready var move_down_timer = get_node("move_down_timer")
onready var explosion_sounds = get_node("explosion_sounds")
onready var puff = get_node("puff")
onready var invader_bullet_container = get_node("invader_bullet_container")
onready var invader_bullet_timer = get_node("invader_bullet_timer")

func _ready():
	start_level()

func start_level():
	squadron = []
	travelling = global.Travelling.RIGHT
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
			invader.connect("exploded", self, "invader_exploded")
			var invader_type = get_level_setting(invader_combinations)[row_count-j-1]
			invader.setup(invader_type, get_level_setting(invader_bullet_delays), invader_bullet_container)
		squadron.append(row)
	start_invader_bullet_timer()
	start_wave()
	set_process_input(true)

func start_wave():
	if get_invader_count() > 0:
		current_row = 0
		if travelling == global.Travelling.LEFT && is_on_left_limit():
			travelling = global.Travelling.DOWN
		elif travelling == global.Travelling.RIGHT && is_on_right_limit():
			travelling = global.Travelling.DOWN
		elif travelling == global.Travelling.DOWN && is_on_left_limit():
			travelling = global.Travelling.RIGHT
		elif travelling == global.Travelling.DOWN && is_on_right_limit():
			travelling = global.Travelling.LEFT
		var wait_time = initial_row_wait_time * get_proportion_remaining()
		global.print_debounce("start_wave", "wait_time=%s" % wait_time)
		move_across_timer.set_wait_time(wait_time)
		for invader in get_all_invaders():
			invader.velocity_adjustment = max(5, 1 / get_proportion_remaining())
		global.print_debounce("velocity_adjustment", 1 / get_proportion_remaining())
		move_across_timer.start()
	else:
		current_level += 1
		start_level()

func _on_move_across_timer_timeout():
	var row_index = current_row if travelling != global.Travelling.DOWN else row_count - current_row - 1
	for invader in get_invaders_by_row(row_index):
		if travelling == global.Travelling.LEFT:
			invader.blip_left()
		if travelling == global.Travelling.RIGHT:
			invader.blip_right()
		if travelling == global.Travelling.DOWN:
			invader.blip_down()
	current_row += 1
	if current_row < row_count:
		move_across_timer.start()
	elif travelling == global.Travelling.DOWN:
		# need to let the top row finish moving down before we change direction and start the next wave 
		move_down_timer.start()
	else:
		start_wave()

func _on_move_down_timer_timeout():
	if all_invaders_are_stationary():
		start_wave()
	else:
		move_down_timer.start()

func _input(event):
	if event.is_action_pressed("tester_nuke") && !event.is_echo():
		for invader in get_all_invaders():
			if randi() % 2 == 0:
				invader.explode()

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

func get_random_invader():
	var invaders = get_all_invaders()
	return invaders[randi() % invaders.size()]

func get_invader_count():
	return get_all_invaders().size()

func all_invaders_are_stationary():
	for invader in get_all_invaders():
		if !invader.is_stationary():
			return false
	return true

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
	if number_remaining > speed_up_threshold:
		return number_of_rows_remaining / row_count  
	else:
		return float(number_remaining) / total

func invader_exploded(invader):
	var invader_debris = puff.duplicate()
	self.add_child(invader_debris)
	invader_debris.set_global_pos(invader.get_global_pos())
	invader_debris.set_color(get_level_setting(invader_puff_colours))
	invader_debris.set_emitting(true)
	explosion_sounds.play("expl2")

func get_level_setting(setting_array):
	var index = current_level % setting_array.size()
	return setting_array[index]

func start_invader_bullet_timer():
	var time_until_next_bullet = rand_range(0, get_level_setting(invader_bullet_delays))
	invader_bullet_timer.set_wait_time(time_until_next_bullet)
	invader_bullet_timer.start()
	
func _on_invader_bullet_timer_timeout():
	var invader = get_random_invader()
	if invader:
		invader.fire_bullet()
		start_invader_bullet_timer()
