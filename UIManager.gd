extends CanvasLayer

@onready var xp = $HUD/xp
@onready var hp = $HUD/hp
@onready var mana = $HUD/mana
@onready var time = $HUD/time

@export var show_pause = false
func _ready():
	pass

func _process(delta: float) -> void:
	if GlobalManager.game_state == "playing":
		if GlobalManager.player != null:
			hp.text = "HEALTH: " + str(GlobalManager.player.health) + "/" + str(GlobalManager.player.MAX_HEALTH)
			mana.text = "MANA: " + str(GlobalManager.player.mana) + "/" + str(GlobalManager.player.MAX_MANA)
			xp.text = "XP: " + str(GlobalManager.xp)
			var s = GlobalManager.time % 3600 % 60
			var m = floor(GlobalManager.time % 3600 / 60)
			time.text = "TIME: " + ("0" if m < 10 else "") + str(m) + ":" + ("0" if s < 10 else "") + str(s)
	if GlobalManager.game_state == "end":
		get_tree().quit()
