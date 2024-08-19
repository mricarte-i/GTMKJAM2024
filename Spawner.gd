extends Node2D

@onready var world = get_tree().get_first_node_in_group("world")

@onready var mob = preload("res://Mobs/Mob.tscn")
@export var mobKinds: Array[MobKind] = []

func spawn():
	var i = 0
	while i < mobKinds.size():
		var pos = get_child(i)
		var spawned = mob.instantiate()
		world.add_child(spawned)
		spawned.global_position = pos.global_position
		spawned.kind = mobKinds[i]
		i += 1
