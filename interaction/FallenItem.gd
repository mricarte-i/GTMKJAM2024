extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var holder = get_tree().get_first_node_in_group("wand")
@onready var interactionArea: InteractionArea = $InteractionArea
@onready var sprite = $Icon
@export var item: Item:
	set(value):
		if item == value:
			return
		item = value
		if is_node_ready():
			_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactionArea.interact = Callable(self, "_on_interact")
	_update()

func _on_interact():
	print("IM THE ITEM YOU CLICKED!")
	holder.add_item(item)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update() -> void:
	if item != null:
		sprite.texture = item.texture
		interactionArea.action_name = item.hint
