extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = "[L] to "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var i = active_areas.find(area)
	if i != 1:
		active_areas.remove_at(i)
		active_areas.resize(active_areas.size() - 1)

func _process(delta: float) -> void:
	if active_areas.size() > 0 && active_areas[0] != null && can_interact:
		active_areas.sort_custom(sort_by_dist_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x/2
		label.show()
	else:
		label.hide()
		
		
func sort_by_dist_to_player(a1, a2):
	var a1_to_player = player.global_position.distance_to(a1.global_position)
	var a2_to_player = player.global_position.distance_to(a2.global_position)
	return a1_to_player < a2_to_player

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0 && active_areas[0] != null:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			can_interact = true
