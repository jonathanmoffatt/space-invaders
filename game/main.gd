extends Node

var squadron = []
var horizontal_count = 11
var vertical_count = 5

func _ready():
	var invader_template = get_node("invader-template")
	for j in range(vertical_count):
		var row = []
		for i in range(horizontal_count):
			var invader = invader_template.duplicate()
			self.add_child(invader)
			row.append(weakref(invader))
			invader.set_pos(Vector2(i*150 + 150, j*120 + 100))
			invader.connect("invader_direction_change", self, "on_direction_change")
		squadron.append(row)
	start()
	
func start():	
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
			
func on_direction_change(new_travel):
	for invader in get_all_invaders():
		invader.change_direction(new_travel)