extends Area2D

export var velocity = 700
export (PackedScene) var bullet

onready var bullet_container = get_node("bullet_container")
onready var bullet_timer = get_node("bullet_timer")

var screen_size
var pos = Vector2()
var vel = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	pos.x = screen_size.width / 2
	pos.y = screen_size.height - 50
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("player_fire"):
		if get_node("bullet_timer").get_time_left() == 0:
			fire()
	if Input.is_action_pressed("player_left"):
		pos.x -= velocity * delta
	if Input.is_action_pressed("player_right"):
		pos.x += velocity * delta
	if pos.x <= 0:
		pos.x = 0
	if pos.x >= screen_size.width:
		pos.x = screen_size.width
	
	set_pos(pos)

func fire():
	bullet_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_pos())