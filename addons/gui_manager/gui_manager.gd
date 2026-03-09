extends Node
"""
GuiManager - Manages smooth GUI transitions with ProxyGui integration

(c) Pioneer Games
v 2.0

DESCRIPTION:
GuiManager handles the addition, removal, and layering of GUI elements with smooth transition effects. 
It works in conjunction with ProxyGui-based scenes and TransitionConfig resources, 
providing a complete GUI management system for games with multiple screens.

REQUIREMENTS:
- Two directories must be set in the Inspector:
	- gui_scenes_dir - directory containing GUI scenes (e.g., res://gui/)
	- gui_transition_scenes_dir - directory containing transition scenes (e.g., res://gui/transitions/)
- All managed GUIs must inherit from ProxyGui
- All transitions must inherit from ProxyGuiTransition
- Transition configurations must use TransitionConfigResource or its derivatives

SIGNALS - Monitor GUI lifecycle:
- manager_gui_loaded(gui) - emitted when a GUI finishes loading and appears on screen
- manager_gui_unloaded(gui) - emitted after GUI cleanup and removal

USAGE:
1. Setup GuiManager:
	- Set gui_scenes_dir and gui_transition_scenes_dir in Inspector

2. Create GUI scenes:
	- Create a new inherited GUI scene:
		- Right-click on gui.tscn in the FileSystem dock
		- Select "New Inherited Scene"
		- Save the new scene (e.g., gui_main_menu.tscn)
	- Add custom logic (optional):
		- Right-click on the root node of your new scene
		- Select "Extend Script"
	- Design your GUI:
		- Add your UI controls (buttons, panels, labels) as children of the $Root node
		- The $Root node is automatically available in every ProxyGui

3. Create transition configurations:
	- Create custom configs by extending TransitionConfigResource

4. Show a GUI with transition:
	# Create fade transition config
	var config = TransitionConfigFadeResource.new()
	config.transition_name = "fade"
	config.duration = 1.0
	config.transition_out = false
	config.gui_opacity_start = 0.0
	config.gui_opacity_end = 1.0
	# Show GUI
	var gui_id = GuiManager.add_gui("gui_main_menu", 100, config)

5. Hide a GUI with transition:
	# Create exit transition config
	var config = TransitionConfigFadeResource.new()
	config.transition_name = "fade"
	config.duration = 0.5
	config.transition_out = true
	config.gui_opacity_start = 1.0
	config.gui_opacity_end = 0.0
	# Hide GUI
	GuiManager.destroy_gui(gui_id, config)

6. Layer management:
	# Add GUI above current top (highest z_order + 1)
	var gui_id = GuiManager.add_gui_above_top_one("gui_pause_menu", config)

	# Add GUI under current top (highest z_order - 1)
	var gui_id = GuiManager.add_gui_under_top_one("gui_pause_menu", config)

	# Replace top GUI with a new one
	var new_id = GuiManager.change_gui_top_one("gui_settings", open_config, close_config)

7. Connect to signals:
	GuiManager.manager_gui_loaded.connect(_on_gui_shown)
	GuiManager.manager_gui_unloaded.connect(_on_gui_hidden)
"""

signal manager_gui_loaded(gui)
signal manager_gui_unloaded(gui)

@export_dir var gui_scenes_dir: String = "res://src/scenes/gui_scenes"
@export_dir var gui_transition_scenes_dir: String = "res://src/scenes/gui_transition_scenes"

var gui_container: Dictionary[String, ProxyGui] = {}
var utils: Utils = Utils.new()


func add_gui(gui_name: String, z_order: int, transition_config: TransitionConfigResource) -> String:
	var gui_id := ""
	var gui: ProxyGui = utils.load_scene_instance(gui_name, gui_scenes_dir) as ProxyGui
	if gui:
		gui_id = utils.create_id()
		gui.gui_loaded.connect(_on_gui_loaded, CONNECT_ONE_SHOT)
		add_child(gui)
		gui.load_gui(gui_id, z_order, transition_config)
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func add_gui_above_top_one(gui_name: String, transition_config: TransitionConfigResource) -> String:
	var gui_id := ""
	var gui_top_z_order := 0
	var gui_top := find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		
	var gui := utils.load_scene_instance(gui_name, gui_scenes_dir) as ProxyGui
	if gui:
		gui_id = utils.create_id()
		gui.gui_loaded.connect(_on_gui_loaded, CONNECT_ONE_SHOT)
		add_child(gui)
		gui.load_gui(gui_id, gui_top_z_order + 1, transition_config)
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func add_gui_under_top_one(gui_name: String, transition_config: TransitionConfigResource) -> String:
	var gui_id := ""
	var gui_top_z_order := 0
	var gui_top := find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		
	var gui := utils.load_scene_instance(gui_name, gui_scenes_dir) as ProxyGui
	if gui:
		gui_id = utils.create_id()
		gui.gui_loaded.connect(_on_gui_loaded, CONNECT_ONE_SHOT)
		add_child(gui)
		gui.load_gui(gui_id, gui_top_z_order - 1, transition_config)
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func change_gui_top_one(gui_name: String, transition_config: TransitionConfigResource, gui_top_transition_config: TransitionConfigResource) -> String:
	var gui_top_z_order := 0
	var gui_top := find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		destroy_gui(gui_top.id, gui_top_transition_config)
	
	return add_gui(gui_name, gui_top_z_order, transition_config)
		
		
func destroy_gui(gui_id: String, transition_config: TransitionConfigResource) -> void:
	var gui: ProxyGui = gui_container.get(gui_id)
	if is_instance_valid(gui):
		gui.gui_unloaded.connect(_on_gui_unloaded, CONNECT_ONE_SHOT)
		gui.unload_gui(transition_config)
		
		
func destroy_all() -> void:
	if not gui_container.is_empty():
		var gui_array := gui_container.values()
		
		for gui in gui_array:
			destroy_gui(gui.id, null)


func find_gui_top() -> ProxyGui:
	var gui_top: ProxyGui = null
	if not gui_container.is_empty():
		var gui_array := gui_container.values()
		gui_top = gui_array[0]
		
		for gui in gui_array:
			if gui.z_order > gui_top.z_order:
				gui_top = gui
		
	return gui_top 
	
	
func get_gui(gui_id: String) -> ProxyGui:
	return gui_container.get(gui_id)
	
	
func create_transition(config: TransitionConfigResource) -> ProxyGuiTransition:
	var transition := utils.load_scene_instance(config.transition_name, gui_transition_scenes_dir) as ProxyGuiTransition
	if not transition:
		push_error("Failed to load transition: ", config.transition_name)
	return transition


func _on_gui_loaded(gui: ProxyGui):
	manager_gui_loaded.emit(gui)
	
	
func _on_gui_unloaded(gui: ProxyGui):
	var gui_id := gui.id
	gui.queue_free()
	gui_container.erase(gui_id)
	manager_gui_unloaded.emit(gui_id)


class Utils extends Resource:
	const SCENETYPE: Array = ['tscn.converted.scn', 'scn', 'tscn']
	
	var auto_id: int = 0
	
	func load_scene_instance(name: String, dir: String) -> Node:
		var path := ''
		var scene: Node = null

		for ext in SCENETYPE:
			path = '%s/%s.%s' % [dir, name, ext]

			if FileAccess.file_exists(path):
				scene = load(path).instantiate()
				break
				
		if not scene:
			push_error("GuiManager.Utils.load_scene_instance: Failed to load scene '%s' from directory '%s'" % [name, dir])
			return null

		return scene
		
	
	func create_id() -> String:
		var auto_id_string := "gui_%s"
		var id := auto_id_string % auto_id
		
		auto_id += 1
		if auto_id > 10000000:
			print_debug("Max auto index count of 10 million reached. Restarting at 0.")
			auto_id = 0
			id = auto_id_string % auto_id
			
		return id
