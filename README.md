# godot-gui-manager

Manager whose purpose is to control guis
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
