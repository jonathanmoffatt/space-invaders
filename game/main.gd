extends Node

onready var invader1 = get_node("first-invader")
onready var invader2 = get_node("second-invader")

var invader3

func _ready():
	invader1.connect("invader_direction_change", self, "on_direction_change")
	invader2.connect("invader_direction_change", self, "on_direction_change")
	invader1.set_pos(Vector2(100, 100))
	invader2.set_pos(Vector2(400, 100))
	invader1.start()
	invader2.start()
	invader3 = invader1.duplicate()
	self.add_child(invader3)
	invader3.set_pos(Vector2(700, 100))
	invader3.connect("invader_direction_change", self, "on_direction_change")
	invader3.start()
	
func on_direction_change(new_travel):
	invader1.change_direction(new_travel)
	invader2.change_direction(new_travel)
	invader3.change_direction(new_travel)