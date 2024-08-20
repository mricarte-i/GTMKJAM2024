extends CharacterBody2D

@onready var world = get_tree().get_first_node_in_group("world")
@onready var ticker = get_tree().get_first_node_in_group("worldticker")

@export var MAX_HEALTH = 2
var health = MAX_HEALTH

@onready var mana_timer = $ManaRegen
@export var MAX_MANA = 3
var mana = MAX_MANA
@onready var holder = $Holder

@export var SPEED = 300.0

var direction = Vector2.ZERO
var facing = Vector2(1.0, 0.0)
var isHoldingDir = false

func _ready() -> void:
	ticker.connect("timeout", tick)
	GlobalManager.register_player(self)
	GlobalManager.register_world(world)

func tick() -> void:
	if mana == MAX_MANA:
		holder.shoot(mana)
		mana = 0

func damage(who) -> void:
	health -= who.kind.damage #maybe a dmg number?
	GlobalManager.display_dmg(who.kind.damage, global_position, true)
	if health < 0:
		GlobalManager.unregister_player()
		GlobalManager.unregister_world()
		print("im dead")
		GlobalManager.game_over()
		queue_free()

func _process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_just_pressed("hold_direction"):
		isHoldingDir = !isHoldingDir

	if not (is_zero_approx(direction.x) and is_zero_approx(direction.y)) and not isHoldingDir:
		facing = direction

	holder.rotation = lerp_angle(holder.rotation, facing.angle(), 0.2)

func _physics_process(delta: float) -> void:
	if is_zero_approx(direction.x) and is_zero_approx(direction.y):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity = direction * SPEED

	move_and_slide()


func _on_mana_regen_timeout() -> void:
	mana += 1
	mana = min(mana, MAX_MANA)
