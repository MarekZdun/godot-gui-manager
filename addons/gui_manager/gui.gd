extends CanvasLayer
"""
Gui base

Usage:
-right click on gui.tscn file in File System and choose New Inherited Scene

-right click on Gui node (top one) and choose Extend Script to add additional funcionality to your gui

-add your Control nodes to node Root 
"""


signal gui_loaded(gui)
signal gui_unloaded(gui)


var id: String
var z_order: int
var current_transition: Control
var utils = Utils.new()

onready var root: Control = $Root


func load_gui(gui_id: String, _z_order: int, transition_config: Dictionary):
	id = gui_id
	z_order = _z_order
	layer = z_order
	root.hide()

	if current_transition:
		destroy_current_transition()

	if transition_config.has("transition_name") and not transition_config.transition_name.empty():
		transition_config.root = root
		current_transition = utils.load_scene_instance(transition_config.transition_name, transition_config.transition_scenes_dir)
		
		if current_transition:
			current_transition.connect("transition_in_ended", self, "_on_transition_in_ended")
			add_child(current_transition)
			current_transition.setup(transition_config) 
	else:
		root.show()
		emit_signal("gui_loaded", self)
		
		
func unload_gui(transition_config: Dictionary):
	if current_transition:
		destroy_current_transition()
	
	if transition_config.has("transition_name") and not transition_config.transition_name.empty():
		transition_config.root = root
		current_transition = utils.load_scene_instance(transition_config.transition_name, transition_config.transition_scenes_dir)
		
		if current_transition:
			current_transition.connect("transition_out_ended", self, "_on_transition_out_ended")
			add_child(current_transition)
			current_transition.setup(transition_config) 
	else:
		root.hide()
		emit_signal("gui_unloaded", self)
	
	
func destroy_current_transition():
	current_transition.pre_destroy()
	current_transition.queue_free()
	current_transition = null
		
		
func _on_transition_in_ended(gui):
	destroy_current_transition()
	emit_signal("gui_loaded", self)
	
	
func _on_transition_out_ended(gui):
	destroy_current_transition()
	emit_signal("gui_unloaded", self)


class Utils extends Resource:
	const SCENETYPE = ['tscn.converted.scn', 'scn', 'tscn']
	
	func load_scene_instance(name: String, dir: String) -> Control:
	    var file = File.new()
	    var path = ''
	    var scene = null

	    for ext in SCENETYPE:
	        path = '%s/%s.%s' % [dir, name, ext]

	        if file.file_exists(path):
	            scene = load(path).instance()
	            break

	    return scene
