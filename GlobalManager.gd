extends Node

# menu, playing, end
@export var game_state = "playing"
@export var xp = 0
const Lvls = {
	10: 1,
	25: 2,
	50: 3,
	80: 4,
	115: 5,
	160: 6,
	210: 7,
}
@export var lvl = 0

@export var player = null
func register_player(new_player):
	player = new_player
func unregister_player():
	player = null
	
@export var camera = null
func register_camera(new_camera):
	camera = new_camera
func unregister_camera():
	camera = null
	
@export var ui = null
func register_ui(new_ui):
	ui = new_ui
func unregister_ui():
	ui = null

	
var time = 0
func update_time(value):
	if game_state == "end":
		return
	time = value
	if time == 420:
		game_over()
	
func add_xp(value):
	if player == null:
		return
	
	xp += value
	if xp in range(10, 25) and lvl < 1:
		lvl = 1
		player.MAX_MANA = 4
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.95, 0.95), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(25, 50) and lvl < 2:
		lvl = 2
		player.MAX_MANA = 6
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.9, 0.9), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(50, 80) and lvl < 3:
		lvl = 3
		player.MAX_MANA = 8
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.8, 0.8), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(80, 160) and lvl < 4:
		lvl = 4
		player.MAX_MANA = 16
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.75, 0.75), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(160, 400) and lvl < 5:
		lvl = 5
		player.MAX_MANA = 32
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.7, 0.7), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(400, 1000) and lvl < 6:
		lvl = 6
		player.MAX_MANA = 64
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.65, 0.65), 0.5
		).set_ease(Tween.EASE_OUT)
		ui.show_choose_boon()
	elif xp in range(1000, 9999) and lvl < 7:
		lvl = 7
		player.MAX_MANA = 128
		print("WINNER IS U")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.6, 0.6), 0.5
		).set_ease(Tween.EASE_OUT)
		#game_over()
	return
	

func game_start():
	game_state = "playing"

func restart():
	get_tree().quit()

func game_over():
	game_state = "end"
	print("rip")

func funny_text(text):
	if player != null:
		display_text(text, player.global_position)

func display_text(text: String, pos: Vector2, is_critical: bool = false):
	var number = Label.new()
	number.global_position = pos
	number.text = text
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if is_critical:
		color = "#B22"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 24
	number.label_settings.outline_color = "#000"
	if is_critical:
		number.label_settings.outline_color = "#FFF"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
		).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
		).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	await tween.finished
	number.queue_free()

func display_dmg(value: int, pos: Vector2, is_critical: bool = false):
	var number = Label.new()
	number.global_position = pos
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if is_critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 18
	number.label_settings.outline_color = "#000"
	if is_critical:
		number.label_settings.outline_color = "#FFF"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
		).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
		).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	await tween.finished
	number.queue_free()
