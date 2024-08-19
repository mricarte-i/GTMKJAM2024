extends RayCast2D

@onready var area = $Area2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var holder = get_tree().get_first_node_in_group("wand")
@onready var particlesStart = $ParticlesStart
@onready var line = $Line2D
var isCasting = false
var dmg = 0
var hasAimed = false

var rem_mana = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

func shoot(value) -> void:
	dmg = value
	rem_mana = value
	#print("got",rem_mana)
	setIsCasting(true)

func end() -> void:
	setIsCasting(false)

func setIsCasting(cast: bool) -> void:
	isCasting = cast
	particlesStart.emitting = isCasting
	if isCasting:
		appear()
	else:
		dissapear()
	set_physics_process(isCasting)

func appear():
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 10.0, 0.2)
	tween.tween_callback(end)

func dissapear():
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 0.0, 0.1)
	return_mana()
	queue_free()

func return_mana():
	if player == null:
		return
	#print("ret",rem_mana)
	player.mana += rem_mana

func _physics_process(delta: float) -> void:
	if !hasAimed and holder != null and holder.has_autoaim() and area.has_overlapping_bodies():
		var enemies = area.get_overlapping_bodies()
		enemies.sort_custom(InteractionManager.sort_by_dist_to_player)
		var facing = enemies[0].global_position - global_position
		global_rotation = facing.angle() #lerp_angle(global_rotation, facing.angle(), 0.8)
		hasAimed = true

	var castPoint:= target_position
	force_raycast_update()


	if is_colliding():
		castPoint = to_local(get_collision_point())
		var remaining_dmg = get_collider().damage(dmg)
		if remaining_dmg > 0 && holder.has_continue():
			ExtendedBeamManager.shoot(
				remaining_dmg,
				get_collision_point(),
				global_rotation
				)
			remaining_dmg = 0

		rem_mana = remaining_dmg

	line.points[1] = castPoint
