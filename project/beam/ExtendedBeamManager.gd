extends Node

@export var holder: Holder = null
func register_holder(new_holder):
	holder = new_holder
func unregister_holder():
	holder = null
	
@export var beamTemp = preload("res://beam/Beam.tscn")
@export var dubBeamTemp = preload("res://beam/DoubleBeam.tscn")

@export var MAX_SPAWNED_BEAMS = 7
@export var spawnedBeams = 0

var onCooldown = false

func _ready() -> void:
	pass

func remove_one():
	spawnedBeams -= 1
	Engine.set_time_scale(1 - spawnedBeams*0.05)
	if spawnedBeams == 0:
		Engine.set_time_scale(1.0)
	

func can_shoot():
	return spawnedBeams < MAX_SPAWNED_BEAMS

func shoot(mana, pos, rot, depth):
	var player = GlobalManager.player
	var world = GlobalManager.world
	if not can_shoot():
		if player == null:
			player.mana += mana
		return
		
	var beam = beamTemp.instantiate() if holder.has_branch() <= depth else dubBeamTemp.instantiate()
	#var beam = beamTemp.instantiate()
	#get_tree().root.get_child(0).add_child(beam)
	world.add_child(beam)
	
	beam.position = pos
	beam.rotation = rot
	spawnedBeams += 1
	if not (holder.has_branch() <= depth):
		spawnedBeams += 1 #double!
	if spawnedBeams == MAX_SPAWNED_BEAMS:
		cooldown()
	beam.shoot(mana, depth + 1)
	#TODO screen shake that adds up with each spawned beam?
	Engine.set_time_scale(1 - spawnedBeams*0.05)

func cooldown():
	onCooldown = true
	await get_tree().create_timer(5).timeout
	onCooldown = false
	
