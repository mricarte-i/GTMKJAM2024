extends RayCast2D

@onready var line = $Line2D
var isCasting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

func shoot() -> void:
	setIsCasting(true)
func end() -> void:
	setIsCasting(false)

func setIsCasting(cast: bool) -> void:
	isCasting = cast
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
		castPoint = to_local(get_collision_point())
	
	line.points[1] = castPoint
	
