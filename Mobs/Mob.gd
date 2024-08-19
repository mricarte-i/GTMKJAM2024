extends CharacterBody2D

@export var SPEED = 90.0

@onready var ticker = get_tree().get_first_node_in_group("worldticker")
@onready var target = get_tree().get_first_node_in_group("player")

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D

var last_pos: Vector2
var isTouchingPlayer = false

@export var MAX_HEALTH = 4
var health = MAX_HEALTH
@export var isBeingHit = false
func disable_collision():
	collider.set_deferred("disabled", true)
func enable_collision():
	collider.set_deferred("disabled", false)

var stopped = false
@export var kind: MobKind:
	set(value):
		if kind == value:
			return
		kind = value
		if is_node_ready():
			_update()

func _update() -> void:
	if kind != null:
		sprite.texture = kind.texture
		SPEED = kind.speed
		MAX_HEALTH = kind.hp
		health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = target.global_position
	ticker.connect("timeout", tick)
	_update()

func tick() -> void:
	if stopped:
		return

	if isTouchingPlayer:
		target.damage(self)

func damage(value):
	if stopped:
		return value

	var diff = health - value
	health -= value
	GlobalManager.display_dmg(value, global_position)
	if diff < 0:
		#start death anim
		anim.play("death")
		return value - health
	else:
		#hit anim
		anim.play("hit")
		return 0

func stop():
	stopped = true

func death():
	GlobalManager.add_xp(kind.hp)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if stopped:
		return
	#var direction = last_pos - position
	var direction = position.direction_to(last_pos)
	velocity = direction * SPEED
	move_and_slide()
	if not target == null:
		last_pos = target.global_position
	else:
		return



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == target:
		isTouchingPlayer = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		isTouchingPlayer = false
