class_name Holder
extends Node2D

@export var slots = []

#@onready var world = get_tree().get_first_node_in_group("world")

@export var fallenItem = preload("res://interaction/FallenItem.tscn")
@export var actionItem = preload("res://Item/ActionItem.tscn")
@export var beamTemp = preload("res://beam/Beam.tscn")
@export var dubBeamTemp = preload("res://beam/DoubleBeam.tscn")
@onready var end = $end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ExtendedBeamManager.register_holder(self)

func _exit_tree() -> void:
	ExtendedBeamManager.unregister_holder()
	
func shoot(mana):
	var beam = beamTemp.instantiate() if has_branch() == 0 else dubBeamTemp.instantiate()
	#var beam = beamTemp.instantiate()
	GlobalManager.world.add_child(beam)
	var pos = end
	if slots.size() > 0 && end.get_child_count() > 0:
		var last_slot_end = find_last_end(end.get_child(0))
		pos = last_slot_end
	beam.position = pos.global_position
	beam.rotation = pos.global_rotation
	beam.shoot(mana)

func find_last_end(node):
	if node == null:
		push_error("uh")
	if node.end.get_child_count() == 0:
		return node.end
	return find_last_end(node.end.get_child(0))

func add_item(item: Item):
	var pos = end
	if slots.size() > 0 && end.get_child_count() > 0:
		var last_slot_end = find_last_end(end.get_child(0))
		pos = last_slot_end
	slots.append(item)
	
	var heldItem = actionItem.instantiate()
	pos.add_child(heldItem)
	heldItem.item = item

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_all"):
		rec_drop_all()

func rec_drop_all():
	if end.get_child_count() > 0:
		end.get_child(0).remove_last_action()
	slots.resize(0)
	return
	
func has_continue():
	if slots.size() == 0:
		return 0
	var matching = slots.filter(func (obj):
		return obj.name == "CONTINUE")
	return matching.size()
	
func has_branch():
	if slots.size() == 0:
		return 0
	var matching = slots.filter(func (obj):
		return obj.name == "BRANCH")
	return matching.size()

func has_autoaim():
	if slots.size() == 0:
		return false
	var matching = slots.filter(func (obj):
		return obj.name == "AUTOAIM").front()
	return true if matching != null else false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
