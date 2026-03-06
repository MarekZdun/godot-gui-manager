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
var current_transition: ProxyGuiTransition

@onready var root: Control = $Root


func load_gui(gui_id: String, _z_order: int, transition_config: TransitionConfigResource) -> void:
	id = gui_id
	z_order = _z_order
	root.hide()

	if current_transition:
		destroy_current_transition()

	if  transition_config and not transition_config.transition_name.is_empty():
		current_transition = GuiManager.create_transition(transition_config)
		
		if current_transition:
			current_transition.transition_in_ended.connect(_on_transition_in_ended, CONNECT_ONE_SHOT)
			add_child(current_transition)
			current_transition.setup(root, transition_config) 
	else:
		root.show()
		gui_loaded.emit(self)
		
		
func unload_gui(transition_config: TransitionConfigResource) -> void:
	if current_transition:
		destroy_current_transition()
	
	if transition_config and not transition_config.transition_name.is_empty():
		current_transition = GuiManager.create_transition(transition_config)
		
		if current_transition:
			current_transition.transition_out_ended.connect(_on_transition_out_ended, CONNECT_ONE_SHOT)
			add_child(current_transition)
			current_transition.setup(root, transition_config) 
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
