extends Area2D

export var velocity = 700

var vel = Vector2()
var container

func _ready():
	vel = Vector2(0, velocity)
	
func fire(position):
	set_global_pos(position)
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_pos(get_pos() + delta * vel)
	
func _on_lifetime_timeout():
	queue_free()

func _on_alien_bullet_area_enter( area ):
	if area.get_groups().has("player"):
		queue_free()
		area.explode()