extends CanvasLayer

@onready var sfx = $AudioStreamPlayer2D

func _on_texture_button_pressed() -> void:
	sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.play()
	GlobalManager.start_game()
