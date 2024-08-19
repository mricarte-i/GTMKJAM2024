extends Node2D

@onready var beam1 = $Beam
@onready var beam2 = $Beam2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shoot(value, plus: bool = false) -> void:
	beam1.shoot(value/2, plus)
	beam2.shoot(value/2, plus)
