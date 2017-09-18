extends Node

# this will be changed to use a factory 
onready var invader1 = get_node("first-invader")
onready var invader2 = get_node("second-invader")

func _ready():
	invader1.connect("invader_direction_change", self, "on_direction_change")
	invader2.connect("invader_direction_change", self, "on_direction_change")
	
func on_direction_change(new_travel):
	invader1.change_direction(new_travel)
	invader2.change_direction(new_travel)