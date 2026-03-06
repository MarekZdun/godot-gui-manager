extends Node
"""
A manager that allows for smooth addition, removal, and modification of Control nodes.
(c) Pioneer Games
v 1.2

Usage:
-choose the GUI scenes directory path for GuiManager in the Inspector panel

-choose the GUI transition scenes directory path for GuiManager in the Inspector panel

-depending on the transition type (transition in or transition out) connect the corresponding signal. Ex:
	
	GuiManager.manager_gui_loaded.connect(_on_gui_on_screen)
	or
	GuiManager.manager_gui_unloaded.connect(_on_gui_off_screen)

-to add a GUI, call String GuiManager.add_gui(gui_name: String, gui_z_order: int, transition_data: Dictionary) method. Ex:
	
	var gui_1 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})
	
-to destroy a GUI, call String GuiManager.destroy_gui(gui_id: String, transition_data: Dictionary) method. Ex:
	
	GuiManager.destroy_gui(move_1, {
		"transition_name": "move",
		"transition_out": true,
		"duration": 1,
		"gui_position_origin": Vector2(0, 0),
		"gui_position_end": Vector2(100, 0)
	})
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
