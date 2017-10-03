extends Node

func generate(colour, type):
	var invader = get_node("invaders/%s/%s" % [colour, type]).duplicate()
	return invader