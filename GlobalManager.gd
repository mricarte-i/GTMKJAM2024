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
	elif xp in range(25, 50) and lvl < 2:
		lvl = 2
		player.MAX_MANA = 6
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.9, 0.9), 0.5
		).set_ease(Tween.EASE_OUT)
	elif xp in range(50, 80) and lvl < 3:
		lvl = 3
		player.MAX_MANA = 8
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.8, 0.8), 0.5
		).set_ease(Tween.EASE_OUT)
	elif xp in range(80, 115) and lvl < 4:
		lvl = 4
		player.MAX_MANA = 16
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.75, 0.75), 0.5
		).set_ease(Tween.EASE_OUT)
	elif xp in range(115, 160) and lvl < 5:
		lvl = 5
		player.MAX_MANA = 32
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.7, 0.7), 0.5
		).set_ease(Tween.EASE_OUT)
	elif xp in range(160, 210) and lvl < 6:
		lvl = 6
		player.MAX_MANA = 64
		print("LVL.UP")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.65, 0.65), 0.5
		).set_ease(Tween.EASE_OUT)
	elif xp in range(210, 9999) and lvl < 7:
		lvl = 7
		player.MAX_MANA = 128
		print("WINNER IS U")
		var tween = get_tree().create_tween()
		tween.tween_property(
			camera, "zoom", Vector2(0.6, 0.6), 0.5
		).set_ease(Tween.EASE_OUT)
		game_over()
	return
	var matching = Lvls.find_key(xp)
	var player = get_tree().get_first_node_in_group("player")
	if matching != null and player != null:
		print("LVL.UP")
		player.MAX_MANA += 1
		if matching == 7:
			print("THE WINNER IS YOU")
			game_over()
	

func game_start():
	game_state = "playing"
	get_tree().paused = false

func toggle_pause():
	get_tree().paused = !get_tree().paused

func game_over():
	game_state = "end"
	get_tree().paused = true
	#show end sceen
	print("rip")

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
