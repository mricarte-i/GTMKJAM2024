extends Node2D

@onready var area = $Area2D
@export var fallenItem = load("res://interaction/FallenItem.tscn")
@onready var sprite = $Icon
@onready var end = $End
@export var item: Item:
	set(value):
		if item == value:
			return
		item = value
		if is_node_ready():
			_update()

var base_rotation = rotation
func _ready():
	_update()

func _update() -> void:
	if item != null:
		sprite.texture = item.texture
	

func remove_last_action():
	if end.get_child_count() > 0:
		end.get_child(0).remove_last_action()
	var fallen = fallenItem.instantiate()
	get_tree().root.add_child(fallen)
	fallen.global_position = global_position + Vector2(randf()*64, randf()*64)
	fallen.item = item
	queue_free()

func sort_by_dist(a1, a2):
	var a1_to = global_position.distance_to(a1.global_position)
	var a2_to = global_position.distance_to(a2.global_position)
	return a1_to < a2_to

func _physics_process(delta: float) -> void:
	var new_rotation = base_rotation
	if item.name == "AUTOAIM" and area.has_overlapping_bodies():
		var enemies = area.get_overlapping_bodies()
		enemies.sort_custom(sort_by_dist)
		var facing = to_local(enemies[0].global_position) - position
		#rotation = facing.angle() #lerp_angle(global_rotation, facing.angle(), 0.8)
		new_rotation = facing.angle()

	rotation = lerp_angle(rotation, new_rotation, 0.5)
