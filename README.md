# GUI Manager(Godot 4.1 version)

A GUI Manager for [Godot Engine](https://godotengine.org/).<br />
Looking for a Godot 3.5 version? [See godot 3.5 branch](https://github.com/MarekZdun/godot-gui-manager/tree/3.5).

## 📄 Features
A manager that allows for smooth addition, removal, and modification of Control nodes.

## 📄 Usage
➡️ choose the GUI scenes directory path for GuiManager in the Inspector panel

➡️ choose the GUI transition scenes directory path for GuiManager in the Inspector panel
	
➡️ depending on the transition type (transition in or transition out) connect the corresponding signal. Ex:
	
	GuiManager.manager_gui_loaded.connect(_on_gui_on_screen)
	or
	GuiManager.manager_gui_unloaded.connect(_on_gui_off_screen)
	
➡️ to add a GUI, call the String GuiManager.add_gui(gui_name: String, gui_z_order: int, transition_data: Dictionary) method. Ex:
	
	var gui_1 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})

 ➡️ to add a GUI above top one, call the String GuiManager.add_gui_above_top_one(gui_name: String, transition_data: Dictionary) method. Ex:

 	var gui_1 := GuiManager.add_gui_above_top_one("gui_progress", {
		"transition_name": "fade",
		"transition_out": false,
		"duration": 1,
		"gui_opacity_start": 0.0,
		"gui_opacity_end": 1.0
	})

  ➡️ to add a GUI under top one, call the String GuiManager.add_gui_under_top_one(gui_name: String, transition_data: Dictionary) method. Ex:

 	var gui_1 := GuiManager.add_gui_under_top_one("gui_progress", {
		"transition_name": "fade",
		"transition_out": false,
		"duration": 1,
		"gui_opacity_start": 0.0,
		"gui_opacity_end": 1.0
	})

   ➡️ to change from top one GUI to another, call the String GuiManager.change_gui_top_one(gui_name: String, transition_config: Dictionary, gui_top_transition_config: Dictionary) method. Ex:

	var gui_1 := GuiManager.change_gui_top_one("gui_curtain", {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	}, {
		"transition_name": "move",
		"transition_out": true,
		"duration": 1,
		"gui_position_origin": Vector2(0, 0),
		"gui_position_end": Vector2(100, 0)
	})

  ➡️ to destroy a GUI, call the String GuiManager.destroy_gui(gui_id: String, transition_data: Dictionary) method. Ex:
	
	GuiManager.destroy_gui(move_1, {
		"transition_name": "move",
		"transition_out": true,
		"duration": 1,
		"gui_position_origin": Vector2(0, 0),
		"gui_position_end": Vector2(100, 0)
	})

  ➡️ to destroy all GUIs, call the String GuiManager.func destroy_all() method.
