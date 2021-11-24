extends Node


export var window_manager: Resource


func _ready():
	WindowManager.load(window_manager)

	GuiManager.connect("manager_gui_loaded", self, "_on_gui_on_screen")
	GuiManager.connect("manager_gui_unloaded", self, "_on_gui_off_screen")
	
	yield(get_tree().create_timer(1), "timeout")
	

	var move_1 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})
	
	yield(get_tree().create_timer(2), "timeout")
	
	var move_2 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})
	
	yield(get_tree().create_timer(2), "timeout")
	
	var move_3 = GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "move",
		"transition_out": false,
		"duration": 1,
		"gui_position_origin": Vector2(100, 0),
		"gui_position_end": Vector2(0, 0)
	})
	
	yield(get_tree().create_timer(2), "timeout")
	
	GuiManager.destroy_all()
	
#	var move_2 = GuiManager.change_gui_top_one("gui_curtain", {
#		"transition_name": "move",
#		"transition_out": false,
#		"duration": 1,
#		"gui_position_origin": Vector2(100, 0),
#		"gui_position_end": Vector2(0, 0)
#	}, {
#		"transition_name": "move",
#		"transition_out": true,
#		"duration": 1,
#		"gui_position_origin": Vector2(0, 0),
#		"gui_position_end": Vector2(100, 0)
#	})

#	yield(get_tree().create_timer(2), "timeout")
#
#	GuiManager.destroy_gui(move_1, {
#		"transition_name": "move",
#		"transition_out": true,
#		"duration": 1,
#		"gui_position_origin": Vector2(0, 0),
#		"gui_position_end": Vector2(100, 0)
#	})
	



func _on_gui_on_screen(gui):
	print("loaded " + gui.id + " " + gui.name)
	
	
func _on_gui_off_screen(gui_id):
	print("unloaded " + gui_id)
