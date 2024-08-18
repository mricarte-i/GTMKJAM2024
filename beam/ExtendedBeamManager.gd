extends Node

@onready var player = get_tree().get_first_node_in_group("player")
@onready var holder = get_tree().get_first_node_in_group("wand")
@export var beamTemp = preload("res://beam/Beam.tscn")
@export var dubBeamTemp = preload("res://beam/DoubleBeam.tscn")

func shoot(mana, pos, rot):
	var beam = beamTemp.instantiate() if not holder.has_branch() else dubBeamTemp.instantiate()
	#var beam = beamTemp.instantiate()
	get_tree().root.get_child(0).add_child(beam)
	
	beam.position = pos
	beam.rotation = rot
	beam.shoot(mana)
