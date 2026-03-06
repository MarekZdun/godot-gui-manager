class_name ProxyGui
extends CanvasLayer
"""
ProxyGui - Abstract base class for GUI elements used by GuiManager

DESCRIPTION:
ProxyGui is a base class that GuiManager uses to manage various GUI screens. 
Every GUI that needs to be shown/hidden with smooth transitions must inherit from this class. This includes:
- Main menus
- Settings screens
- Pause menus

The class provides essential methods and signals that GuiManager relies on to control GUI lifecycle with transition effects.

USAGE:
1. Create a new inherited GUI scene:
	- Right-click on gui.tscn in the FileSystem dock
	- Select "New Inherited Scene"
	- Save the new scene (e.g., gui_main_menu.tscn)
	
2. Add custom logic (optional):
	- Right-click on the root node of your new scene
	- Select "Extend Script"

3. Design your GUI:
	- Add your UI controls (buttons, panels, labels) as children of the $Root node
	- The $Root node is automatically available in every ProxyGui
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
