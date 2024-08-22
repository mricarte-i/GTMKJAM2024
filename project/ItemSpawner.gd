extends Node2D

@onready var fallenItem = preload("res://interaction/FallenItem.tscn")
@export var itemPool: Array[Item] = []
@export var dist = 32

@onready var ticker = get_tree().get_first_node_in_group("worldticker")
@onready var world = get_tree().get_first_node_in_group("world")
var ticks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ticker.connect("timeout", tick)

func tick() -> void:
	ticks +=1
	if ticks % 30 == 0:
		rand_spawn()

func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_action_just_pressed("cheat_spawn_continue"):
		spawn(itemPool[0])
	if Input.is_action_just_pressed("cheat_spawn_branch"):
		spawn(itemPool[1])
	if Input.is_action_just_pressed("cheat_spawn_continue"):
		spawn(itemPool[2])

func spawn(item):
	var fallen = fallenItem.instantiate()
	world.add_child(fallen)
	fallen.item = item
	fallen.global_position = global_position

func rand_spawn():
	var item = itemPool.pick_random()
	var fallen = fallenItem.instantiate()
	world.add_child(fallen)
	fallen.item = item
	var angle = randf()*2*PI
	var xOff = cos(angle)*(dist)
	var yOff = sin(angle)*(dist)
	
	fallen.global_position = global_position + Vector2(xOff, yOff)
