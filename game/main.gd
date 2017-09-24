extends Node

var squadron = []

func _ready():
	var invader_template = get_node("invader-template")
	for j in range(5):
		for i in range(8):
			var invader = invader_template.duplicate()
			self.add_child(invader)
			squadron.append(weakref(invader))
			invader.set_pos(Vector2(i*150 + 300, j*120 + 100))
			invader.connect("invader_direction_change", self, "on_direction_change")
	for invader in squadron:
		invader.get_ref().start()
		
func on_direction_change(new_travel):
	for inv in squadron:
		var invader = inv.get_ref()
		if invader:
			invader.change_direction(new_travel)