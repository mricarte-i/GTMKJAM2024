extends Node2D

@onready var ticker = get_tree().get_first_node_in_group("worldticker")
@export var difficulty = 1
var ticks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ticker.connect("timeout", tick)

func tick() -> void:
	ticks +=1
	GlobalManager.update_time(ticks)
	if ticks % 60 == 0:
		difficulty +=1 
		difficulty %= 6
		difficulty = 1 if difficulty==0 else difficulty
	if ticks % 5 == 0:
		spawn()

func spawn():
	if GlobalManager.game_state == "end":
		return
	var pattern = get_children().filter(func (obj):
		return obj.name == str(difficulty)).front()
	var matching = pattern if pattern != null else get_child(0)
	matching.spawn()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
