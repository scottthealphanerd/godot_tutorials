extends Area2D

var bullet = preload("res://scenes/enemy_bullet.tscn")

onready var paths = get_node("enemy_paths")
onready var bullet_container = get_node("bullet_container")
onready var shoot_timer = get_node("shoot_timer")
onready var sounds = get_node("sounds")

var path
var follow
var remote
var speed = 150
var target = null

func _ready():
	set_process(true)
	randomize()
	path = paths.get_children()[randi() % paths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	remote = Node2D.new()
	follow.add_child(remote)
	shoot_timer.set_wait_time(1.5)  # vary by level
	shoot_timer.start()

func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)
	set_pos(remote.get_global_pos())
	if follow.get_unit_offset() > 1:
		queue_free()

func shoot1():
	sounds.play("enemy_laser")
	var dir = get_global_pos() - target.get_global_pos()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(dir.angle(), get_global_pos())

func shoot3():
	var dir = get_global_pos() - target.get_global_pos()
	for a in [-0.2, 0, 0.2]:
		sounds.play("enemy_laser")
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.start_at(dir.angle() + a, get_global_pos())

func _on_shoot_timer_timeout():
	shoot3()
