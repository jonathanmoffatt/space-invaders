extends Node

var squadron = []
var horizontal_count = 11
var row_count = 5
var travelling = Travelling.RIGHT
var current_row = 0

onready var row_movement_timer = get_node("row_movement_timer")
onready var wave_movement_timer = get_node("wave_movement_timer")

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
	wave_movement_timer.start()
	for invader in get_all_invaders():
		invader.start()

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

func _on_row_movement_timer_timeout():
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
		row_movement_timer.start()
	else:
		wave_movement_timer.start()

func _on_wave_movement_timer_timeout():
	current_row = 0
	if travelling == Travelling.LEFT && is_on_left_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.RIGHT && is_on_right_limit():
		travelling = Travelling.DOWN
	elif travelling == Travelling.DOWN:
		travelling = Travelling.RIGHT if is_on_left_limit() else Travelling.LEFT
	row_movement_timer.start()
