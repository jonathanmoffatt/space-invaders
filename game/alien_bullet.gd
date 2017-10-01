extends Area2D

export var velocity = 700
var vel = Vector2()
onready var bullet_sounds = get_node("bullet_sounds")

func _ready():
	add_to_group("alien_bullets")
	if randi() % 2 == 0:
		vel = Vector2(0, velocity)
		get_node("blue_fast_bullet").show()
	else:
		vel = Vector2(0, velocity / 2)
		get_node("green_slow_bullet").show()
	
func fire(position):
	bullet_sounds.play("laser2")
	set_global_pos(position)
	set_fixed_process(true)
	
func explode():
	# alien bullet has been hit by a player bullet
	queue_free()

func _fixed_process(delta):
	set_pos(get_pos() + delta * vel)
	
func _on_lifetime_timeout():
	queue_free()

func _on_alien_bullet_area_enter( area ):
	if area.get_groups().has("player"):
		queue_free()
		area.explode()
