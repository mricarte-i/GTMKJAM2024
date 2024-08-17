extends CharacterBody2D

@export var SPEED = 100.0
@onready var ticker = %WorldTicker
@onready var target = %Player
var last_pos: Vector2
var isTouchingPlayer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = target.global_position
	ticker.connect("timeout", tick)

func tick() -> void:
	if isTouchingPlayer:
		print("HIT YA!")
		target.damage(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#var direction = last_pos - position
	var direction = position.direction_to(last_pos)
	velocity = direction * SPEED
	move_and_slide()
	if not target == null:
		last_pos = target.global_position
	else: 
		return



func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body == target:
		isTouchingPlayer = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	print(body.name)
	if body == target:
		isTouchingPlayer = false
