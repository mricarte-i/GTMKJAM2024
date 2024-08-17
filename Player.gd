extends CharacterBody2D


@export var MAX_HEALTH = 3
var health = MAX_HEALTH
@export var SPEED = 300.0
var direction = Vector2.ZERO

func damage(who) -> void:
	print("yeouch!")
	print(who.name)
	health -= 1 #maybe a dmg number?
	if health < 0:
		print("im dead")
		queue_free()

func _process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _physics_process(delta: float) -> void:
	if is_zero_approx(direction.x) and is_zero_approx(direction.y):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity = direction * SPEED

	move_and_slide()
