extends TextureRect


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.get_parent().remove_child(data)
	data.position = Vector2(0, 8)
	data.size = Vector2(32,8)
	data.scale = Vector2(0.5, 0.5)
	add_child(data)

func _get_drag_data(at_position: Vector2) -> Variant:
	return get_child(0)._get_drag_data(at_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
