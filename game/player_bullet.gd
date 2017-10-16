extends Area2D

export var velocity = 1000

var vel = Vector2()

func _ready():
	vel = Vector2(0, velocity)
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_pos(get_pos() - delta * vel)
	var is_offscreen = get_global_pos().y < 0
	if is_offscreen:
		queue_free()
	
func start_at(position):
	set_pos(position)

func _on_player_bullet_area_enter( area ):
	var g = area.get_groups()
	if g.has("invaders") || g.has("alien_bullets"):
		queue_free()
		area.explode()
