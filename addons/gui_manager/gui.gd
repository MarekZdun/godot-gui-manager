class_name ProxyGui
extends CanvasLayer
"""
Proxy gui

Usage:
-right click on gui.tscn file in File System and choose New Inherited Scene

-right click on GUI node (top one) and choose Extend Script to add additional functionality to your GUI

-add your Control nodes to the node Root 
"""

signal gui_loaded(gui)
signal gui_unloaded(gui)

var id: String
var z_order: int: 
	set(value):
		z_order = value
		layer = z_order
var current_transition: Control
var utils: Utils = Utils.new()

@onready var root: Control = $Root


func load_gui(gui_id: String, _z_order: int, transition_config: Dictionary) -> void:
	id = gui_id
	z_order = _z_order
	root.hide()

	if current_transition:
		destroy_current_transition()

	if transition_config.has("transition_name") and not transition_config.transition_name.is_empty():
		transition_config.root = root
		current_transition = utils.load_scene_instance(transition_config.transition_name, transition_config.transition_scenes_dir)
		
		if current_transition:
			current_transition.transition_in_ended.connect(_on_transition_in_ended, CONNECT_ONE_SHOT)
			add_child(current_transition)
			current_transition.setup(transition_config) 
	else:
		root.show()
		gui_loaded.emit(self)
		
		
func unload_gui(transition_config: Dictionary) -> void:
	if current_transition:
		destroy_current_transition()
	
	if transition_config.has("transition_name") and not transition_config.transition_name.is_empty():
		transition_config.root = root
		current_transition = utils.load_scene_instance(transition_config.transition_name, transition_config.transition_scenes_dir)
		
		if current_transition:
			current_transition.transition_out_ended.connect(_on_transition_out_ended, CONNECT_ONE_SHOT)
			add_child(current_transition)
			current_transition.setup(transition_config) 
	else:
		root.hide()
		gui_unloaded.emit(self)
	
	
func destroy_current_transition() -> void:
	current_transition.pre_destroy()
	current_transition.queue_free()
	current_transition = null
		
		
func _on_transition_in_ended(gui):
	destroy_current_transition()
	gui_loaded.emit(self)
	
	
func _on_transition_out_ended(gui):
	destroy_current_transition()
	gui_unloaded.emit(self)


class Utils extends Resource:
	const SCENETYPE = ['tscn.converted.scn', 'scn', 'tscn']
	
	func load_scene_instance(name: String, dir: String) -> Node:
		var path := ''
		var scene: Node = null

		for ext in SCENETYPE:
			path = '%s/%s.%s' % [dir, name, ext]

			if FileAccess.file_exists(path):
				scene = load(path).instantiate()
				break

		return scene
