extends RayCast2D

@onready var particlesStart = $ParticlesStart
@onready var line = $Line2D
var isCasting = false
var dmg = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

func shoot(value) -> void:
	dmg = value
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
	

func _physics_process(delta: float) -> void:
	var castPoint:= target_position
	force_raycast_update()
	
	
	if is_colliding():
		print("COLLIDES!")
		castPoint = to_local(get_collision_point())
		var remaining_dmg = get_collider().damage(dmg)
		if remaining_dmg > 0:
			print("try continue", remaining_dmg)
		
	
	line.points[1] = castPoint
	
