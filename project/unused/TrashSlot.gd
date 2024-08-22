extends TextureRect


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("POOF")
	return
	data.get_parent().remove_child(data)
	data.position = Vector2(0, 8)
	data.size = Vector2(32,8)
	data.scale = Vector2(0.5, 0.5)
	add_child(data)
	
