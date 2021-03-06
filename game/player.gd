extends Area2D

signal exploded

export var velocity = 700
export (PackedScene) var bullet

onready var bullet_container = get_node("bullet_container")
onready var muzzle = get_node("muzzle")
onready var bullet_sounds = get_node("bullet_sounds")

var screen_size
var left_limit
var right_limit
var pos = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	var player_width = get_node("ship").get_texture().get_width()
	left_limit = global.margin_side - player_width/2
	right_limit = screen_size.width - global.margin_side + player_width/2
	
func start():
	pos.x = screen_size.width / 2
	pos.y = screen_size.height - 100
	set_pos(pos)
	add_to_group("player")
	show()
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("player_fire"):
		if bullet_container.get_child_count() == 0:
			fire()
	if Input.is_action_pressed("player_left"):
		pos.x -= velocity * delta
	if Input.is_action_pressed("player_right"):
		pos.x += velocity * delta
	if pos.x <= left_limit:
		pos.x = left_limit
	if pos.x >= right_limit:
		pos.x = right_limit
	
	set_pos(pos)

func fire():
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(muzzle.get_global_pos())
	bullet_sounds.play("laser1")

func explode():
	emit_signal("exploded", self)
	queue_free()
