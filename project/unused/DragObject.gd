extends TextureRect

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = 1
	#var prev = TextureRect.new()
	#prev.texture = texture
	#prev.stretch_mode = stretch_mode
	#prev.texture_filter = texture_filter
	
	var preview = Control.new()
	var tex = TextureRect.new()
	tex.texture = texture
	tex.texture_filter = texture_filter
	tex.stretch_mode = stretch_mode
	tex.layout_mode = layout_mode
	tex.anchors_preset = anchors_preset
	
	#tex.anchor_bottom = anchor_bottom
	#tex.anchor_left = anchor_left
	#tex.anchor_top = anchor_top
	#tex.anchor_right = anchor_right
	
	#tex.offset_bottom = offset_bottom
	#tex.offset_left = offset_left
	#tex.offset_top = offset_top
	#tex.offset_right = offset_right
	tex.size = Vector2(32, 24)
	tex.scale = Vector2(1,1)
	
	#get_parent().add_child(tex)
	#tex.position = Vector2.ZERO
	#set_drag_preview(tex)
	preview.add_child(tex)
	tex.set_deferred("global_position", global_position)
	
	set_drag_preview(preview)
	
	
	return self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
