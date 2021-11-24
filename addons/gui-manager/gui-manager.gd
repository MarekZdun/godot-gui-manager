extends Node
"""
Manager whose purpose is to control root of its gui
(c) Pioneer Games
v 1.0

Usage:
-choose gui scenes directory path in GuiManager Inspector

-choose gui transition scenes directory path in GuiManager Inspector

-depending on transition type (transition in or transition out) connect coresponding signal. Ex:
	
	GuiManager.connect("manager_gui_loaded", self, "_on_gui_on_screen") 
	or
	GuiManager.connect("manager_gui_unloaded", self, "_on_gui_off_screen")

-to add gui, call String GuiManager.add_gui(gui_name: String, gui_z_order: int, transition_data: Dictionary). Ex:
	
	var move_1 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})
	
-to destroy gui, call String GuiManager.destroy_gui(gui_id: String, transition_data: Dictionary). Ex:
	
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


export(String, DIR) var gui_scenes_dir: String = "res://src/scenes/gui_scenes"
export(String, DIR) var gui_transition_scenes_dir: String = "res://src/scenes/gui_transition_scenes/"
var gui_container: Dictionary = {}
var utils = Utils.new()


func add_gui(gui_name: String, z_order: int, transition_config: Dictionary) -> String:
	var gui_id = ""
	var gui = utils.load_scene_instance(gui_name, gui_scenes_dir)
	if gui:
		gui_id = utils.create_id()
		gui.connect("gui_loaded", self, "_on_gui_loaded")
		add_child(gui)
		
		transition_config.transition_scenes_dir = gui_transition_scenes_dir
		gui.load_gui(gui_id, z_order, transition_config)
		
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func add_gui_above_top_one(gui_name: String, transition_config: Dictionary) -> String:
	var gui_id = ""
	var gui_top_z_order = 0
	var gui_top = find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		
	var gui = utils.load_scene_instance(gui_name, gui_scenes_dir)
	if gui:
		gui_id = utils.create_id()
		gui.connect("gui_loaded", self, "_on_gui_loaded")
		add_child(gui)
		
		transition_config.transition_scenes_dir = gui_transition_scenes_dir
		gui.load_gui(gui_id, gui_top_z_order + 1, transition_config)
		
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func add_gui_under_top_one(gui_name: String, transition_config: Dictionary) -> String:
	var gui_id = ""
	var gui_top_z_order = 0
	var gui_top = find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		
	var gui = utils.load_scene_instance(gui_name, gui_scenes_dir)
	if gui:
		gui_id = utils.create_id()
		gui.connect("gui_loaded", self, "_on_gui_loaded")
		add_child(gui)
		
		transition_config.transition_scenes_dir = gui_transition_scenes_dir
		gui.load_gui(gui_id, gui_top_z_order - 1, transition_config)
		
		gui_container[gui_id] = gui
	
	return gui_id
	
	
func change_gui_top_one(gui_name: String, transition_config: Dictionary, gui_top_transition_config: Dictionary) -> String:
	var gui_top_z_order = 0
	var gui_top = find_gui_top()
	
	if gui_top:
		gui_top_z_order = gui_top.z_order
		destroy_gui(gui_top.id, gui_top_transition_config)
	
	return add_gui(gui_name, gui_top_z_order, transition_config)
		
		
func destroy_gui(gui_id: String, transition_config: Dictionary) -> void:
	var gui = gui_container[gui_id]
	if gui:
		gui.connect("gui_unloaded", self, "_on_gui_unloaded")
		
		transition_config.transition_scenes_dir = gui_transition_scenes_dir
		gui.unload_gui(transition_config)
		
		
func destroy_all() -> void:
	if not gui_container.empty():
		var gui_array = gui_container.values()
		
		for gui in gui_array:
			destroy_gui(gui.id, {})


func find_gui_top() -> Control:
	var gui_top = null
	if not gui_container.empty():
		var gui_array = gui_container.values()
		gui_top = gui_array[0]
		
		for gui in gui_array:
			if gui.z_order > gui_top.z_order:
				gui_top = gui
		
	return gui_top 


func _on_gui_loaded(gui):
	emit_signal("manager_gui_loaded", gui)
	
	
func _on_gui_unloaded(gui):
	var gui_id = gui.id
	gui.queue_free()
	gui_container.erase(gui.id)
	emit_signal("manager_gui_unloaded", gui_id)


class Utils extends Resource:
	const SCENETYPE: Array = ['tscn.converted.scn', 'scn', 'tscn']
	
	var auto_id: int = 0
	
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
		
	
	func create_id() -> String:
		var auto_id_string = "gui_%s"
		var id = auto_id_string %auto_id
		
		auto_id += 1
		if auto_id > 10000000:
			print_debug("Max auto index count of 10 million reached. Restarting at 0.")
			auto_id = 0
			id = auto_id_string %auto_id
			
		return id
