class_name Beam
extends RayCast2D

@onready var sfx = $AudioStreamPlayer2D
@onready var area = $Area2D
@onready var player = get_tree().get_first_node_in_group("player")

@onready var particlesStart = $ParticlesStart
@onready var line = $Line2D
var isCasting = false
var dmg = 0
var hasAimed = false
var depth = 0
var rem_mana = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

func shoot(value, plus: int = 0) -> void:
	dmg = value
	depth = plus
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
	sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.play()
	

func dissapear():
	var tween = get_tree().create_tween()
	tween.tween_property(line, "width", 0.0, 0.1)
	return_mana()
	if depth > 0:
		ExtendedBeamManager.remove_one()
	
	queue_free()

func return_mana():
	if player == null:
		return
	#print("ret",rem_mana)
	player.mana += rem_mana

func sort_by_dist(a1, a2):
	var a1_to = global_position.distance_to(a1.global_position)
	var a2_to = global_position.distance_to(a2.global_position)
	return a1_to < a2_to

func _physics_process(delta: float) -> void:
	var holder: Holder = ExtendedBeamManager.holder
	
	if depth > 0 and !hasAimed and holder != null and holder.has_autoaim() and area.has_overlapping_bodies():
		var enemies = area.get_overlapping_bodies()
		enemies.sort_custom(sort_by_dist)
		var facing = enemies[0].global_position - global_position
		global_rotation = facing.angle() #lerp_angle(global_rotation, facing.angle(), 0.8)
		hasAimed = true

	var castPoint:= target_position
	force_raycast_update()


	if is_colliding():
		castPoint = to_local(get_collision_point())
		var remaining_dmg = get_collider().damage(dmg)
		enabled = false #shoot once, don't wait until the end of the anim!
		if remaining_dmg > 0 && holder != null && holder.has_continue() > depth && ExtendedBeamManager.can_shoot():
			ExtendedBeamManager.shoot(
				remaining_dmg,
				get_collision_point(),
				global_rotation,
				depth
				)
			remaining_dmg = 0

		rem_mana = remaining_dmg
	
	#line.points[1] = castPoint
	line.set_point_position(1, castPoint)
