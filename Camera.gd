extends Camera2D

@onready var target = $"../CharacterBody2D"
@export var weight = 1.1

var last_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = target.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, last_pos, weight)
	if not target == null:
		last_pos = target.global_position
