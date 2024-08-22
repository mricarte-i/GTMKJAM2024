extends CanvasLayer

@onready var xp = $HUD/xp
@onready var hp = $HUD/hp
@onready var mana = $HUD/mana
@onready var time = $HUD/time

@onready var sfxH = $heal
@onready var sfxM = $manaregen
@onready var sfxS = $speed
@onready var sfxC = $click
@onready var sfxThanks = $tahnks


@onready var pause = $"Pause Menu"
@onready var score = $"Pause Menu/score"
@onready var final_time = $"Pause Menu/time"
@onready var restart =$"Pause Menu/TextureButton"

func _ready():
	pause.visible = false
	GlobalManager.register_ui(self)
	restart.connect("button_down", restart_click)

func restart_click():
	sfxC.pitch_scale = randf_range(0.8, 1.2)
	sfxC.play()
	GlobalManager.restart()

func _exit_tree() -> void:
	GlobalManager.unregister_ui()

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
			xp.text = "XP: " + str(GlobalManager.xp)
			var s = GlobalManager.time % 3600 % 60
			var m = floor(GlobalManager.time % 3600 / 60)
			time.text = "TIME: " + ("0" if m < 10 else "") + str(m) + ":" + ("0" if s < 10 else "") + str(s)
		
	if GlobalManager.game_state == "end":
		pause.visible = true
		sfxThanks.pitch_scale = randf_range(0.8, 1.2)
		sfxThanks.play()
		score.text = "Final Score: " + str(GlobalManager.xp)
		var s = GlobalManager.time % 3600 % 60
		var m = floor(GlobalManager.time % 3600 / 60)
		final_time.text = "Total Time: " + ("0" if m < 10 else "") + str(m) + ":" + ("0" if s < 10 else "") + str(s)
