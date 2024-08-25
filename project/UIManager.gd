extends CanvasLayer

@onready var xp = $HUD/xp
@onready var hp = $HUD/hp
@onready var mana = $HUD/mana
@onready var time = $HUD/time
@onready var manaBar = $HUD/mana_bar
@onready var mana_hint = $HUD/mana_bar_hint

@onready var sfxH = $heal
@onready var sfxM = $manaregen
@onready var sfxS = $speed
@onready var sfxC = $click
@onready var sfxThanks = $tahnks


@onready var game_over = $"Game Over"
@onready var score = $"Game Over/score"
@onready var final_time = $"Game Over/time"
@onready var restart =$"Game Over/TextureButton"

@onready var pause = $Pause
@onready var cont = $Pause/Continue
@onready var quit = $Pause/Quit


var pauseManager: PauseManager
func _ready():
	pauseManager = PauseManager.create(get_tree().current_scene, get_tree().get_nodes_in_group("ui"))
	game_over.visible = false
	pause.visible = false
	GlobalManager.register_ui(self)
	restart.connect("button_down", restart_click)
	quit.connect("button_down", restart_click)
	cont.connect("button_down", continue_click)


func pause_game():
	pauseManager.pause()
	
func pause_click():
	pause.visible = true
	pauseManager.pause()

func continue_click():
	pause.visible = false
	pauseManager.unpause()

func restart_click():
	pauseManager.unpause()
	sfxC.pitch_scale = randf_range(0.8, 1.2)
	sfxC.play()
	GlobalManager.restart()

func _exit_tree() -> void:
	GlobalManager.unregister_ui()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if not get_tree().paused:
			pause_click()
		else:
			continue_click()


func show_choose_boon():
	var r = randi_range(1,4)
	match r:
		1:
			return mana_regen()
		2:
			return heal()
		3:
			return speed()
		4:
			return extend()

func mana_regen():
	var p = GlobalManager.player
	if p == null:
		return
	p.mana_timer.stop()
	p.mana_timer.wait_time *= 0.9
	p.mana_timer.start()
	GlobalManager.funny_text("MANA REGEN++")
	sfxM.pitch_scale = randf_range(0.8, 1.2)
	sfxM.play()

func heal():
	var p = GlobalManager.player
	if p == null:
		return
	p.health += 1
	GlobalManager.funny_text("HEAL (+1)")
	sfxH.pitch_scale = randf_range(0.8, 1.2)
	sfxH.play()

func extend():
	ExtendedBeamManager.MAX_SPAWNED_BEAMS += 1
	GlobalManager.funny_text("MAX BEAMS++")
	sfxM.pitch_scale = randf_range(0.8, 1.2)
	sfxM.play()

func speed():
	var p = GlobalManager.player
	if p == null:
		return
	p.SPEED += 10
	GlobalManager.funny_text("WALK SPEED++")
	sfxS.pitch_scale = randf_range(0.8, 1.2)
	sfxS.play()


func _process(delta: float) -> void:
	if GlobalManager.game_state == "playing":
		if GlobalManager.player != null:
			hp.text = "HEALTH: " + str(GlobalManager.player.health+1) + "/" + str(GlobalManager.player.MAX_HEALTH+1)
			mana.text = "MANA: " + str(GlobalManager.player.mana) + "/" + str(GlobalManager.player.MAX_MANA)
			#var mana_scaled: int = ceili(GlobalManager.player.mana * (100 / GlobalManager.player.MAX_MANA))
			#manaBar.value = mana_scaled
			
			if GlobalManager.player.mana > manaBar.value and GlobalManager.player.mana >= GlobalManager.player.MAX_MANA:
				mana_hint.parse_bbcode("[wave amp=15 freq=15][center]READY!!!!")
			elif GlobalManager.player.mana < manaBar.value:
				mana_hint.parse_bbcode("[wave amp=15 freq=5][center]RELOADING")
			#mana_hint.text = "READY" if GlobalManager.player.mana >= GlobalManager.player.MAX_MANA else "RELOADING"
			#mana_hint.parse_bbcode("[wave amp=15 freq=15][center]READY" if GlobalManager.player.mana >= GlobalManager.player.MAX_MANA else "[wave amp=15 freq=5][center]RELOADING")
			manaBar.max_value = GlobalManager.player.MAX_MANA
			manaBar.value = GlobalManager.player.mana 
			xp.text = "XP: " + str(GlobalManager.xp)
			var s = GlobalManager.time % 3600 % 60
			var m = floor(GlobalManager.time % 3600 / 60)
			time.text = "TIME: " + ("0" if m < 10 else "") + str(m) + ":" + ("0" if s < 10 else "") + str(s)
		
	if GlobalManager.game_state == "end":
		game_over.visible = true
		sfxThanks.pitch_scale = randf_range(0.8, 1.2)
		sfxThanks.play()
		score.text = "Final Score: " + str(GlobalManager.xp)
		var s = GlobalManager.time % 3600 % 60
		var m = floor(GlobalManager.time % 3600 / 60)
		final_time.text = "Total Time: " + ("0" if m < 10 else "") + str(m) + ":" + ("0" if s < 10 else "") + str(s)
