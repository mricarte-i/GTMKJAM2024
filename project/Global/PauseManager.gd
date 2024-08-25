@tool
class_name PauseManager
extends Node

var exception_nodes: Array[Node] = []
var backup_process_modes: Array[ProcessMode] = []

static func create(scene: Node, exception_nodes: Array[Node]) -> PauseManager:
	var instance: PauseManager = PauseManager.new()
	
	instance.exception_nodes = exception_nodes
	for node in exception_nodes:
		instance.backup_process_modes.append(node.process_mode)
	
	scene.add_child.call_deferred(instance)
	
	return instance

func pause() -> void:
	for node in exception_nodes:
		node.process_mode= Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true

func unpause() -> void:
	for i in range(len(exception_nodes)):
		exception_nodes[i].process_mode = backup_process_modes[i]
	
	get_tree().paused = false
