extends Node2D

@export var value: int
@export var plus: int
@export var shot = false

@onready var beamScene: PackedScene = load("res://beam/Beam.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_shoot(value, plus)

func shoot(new_value, new_plus: int = 0) -> void:
	if new_value == value and new_plus == plus:
		return
	value = new_value
	plus = new_plus
	if is_node_ready():
		_shoot(value, plus)


func _shoot(value, plus: int = 0) -> void:
	var beam1 = beamScene.instantiate()
	add_child(beam1)
	
	var beam2 = beamScene.instantiate()
	add_child(beam2)
	
	beam1.call_deferred("rotate", -45)
	beam2.call_deferred("rotate", 45)

	beam1.call_deferred("shoot", ceil(value/2), plus) 
	beam2.call_deferred("shoot", ceil(value/2), plus)
