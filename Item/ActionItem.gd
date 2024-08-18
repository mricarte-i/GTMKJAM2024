extends Node2D

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
	
