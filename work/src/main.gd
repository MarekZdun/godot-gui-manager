extends Node


@export var window_manager: Resource
var pause: bool = false


func _ready():
	WindowManager.load(window_manager)

	GuiManager.manager_gui_loaded.connect(_on_gui_on_screen)
	GuiManager.manager_gui_unloaded.connect(_on_gui_off_screen)
	
	await get_tree().create_timer(1).timeout
	
	var gui_0 := GuiManager.add_gui("gui_curtain", 127, {
		"transition_name": "fade",
		"transition_out": false,
		"duration": 1,
		"gui_opacity_start": 0.0,
		"gui_opacity_end": 1.0,
		"transition_type": Tween.TRANS_SINE,
		"easy_type": Tween.EASE_OUT
	})

	await GuiManager.get_gui(gui_0).gui_loaded

	var gui_1 := GuiManager.add_gui_above_top_one("gui_progress", {
		"transition_name": "fade",
		"transition_out": false,
		"duration": 1,
		"gui_opacity_start": 0.0,
		"gui_opacity_end": 1.0
	})

	await GuiManager.get_gui(gui_1).gui_loaded

	GuiManager.destroy_gui(gui_1, {
		"transition_name": "fade",
		"transition_out": true,
		"duration": 1,
		"gui_opacity_start": 1.0,
		"gui_opacity_end": 0.0,
		"transition_type": Tween.TRANS_SINE,
		"easy_type": Tween.EASE_IN
	})

	await GuiManager.get_gui(gui_1).gui_unloaded

	GuiManager.destroy_gui(gui_0, {
		"transition_name": "fade",
		"transition_out": true,
		"duration": 1,
		"gui_opacity_start": 1.0,
		"gui_opacity_end": 0.0
	})



#	var move_1 := GuiManager.add_gui("gui_curtain", 127, {
#		"transition_name": "move",
#		"transition_out": false,
#		"duration": 1,
#		"gui_position_origin": Vector2(100, 0),
#		"gui_position_end": Vector2(0, 0),
#		"transition_type": Tween.TRANS_SINE,
#		"easy_type": Tween.EASE_IN_OUT
#	})

#	await get_tree().create_timer(2).timeout
#
#	var move_2 := GuiManager.add_gui("gui_curtain", 127, {
#		"transition_name": "move",
#		"transition_out": false,
#		"duration": 1,
#		"gui_position_origin": Vector2(100, 0),
#		"gui_position_end": Vector2(0, 0)
#	})
#
#	await get_tree().create_timer(2).timeout
#
#	GuiManager.destroy_all()



#	var move_3 := GuiManager.add_gui("gui_test", 127, {
#		"transition_name": "move",
#		"transition_out": false,
#		"duration": 1,
#		"gui_position_origin": Vector2(100, 0),
#		"gui_position_end": Vector2(0, 0)
#	})
#
#	await get_tree().create_timer(2).timeout
#
#	var move_4 := GuiManager.change_gui_top_one("gui_curtain", {
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
#
#	await get_tree().create_timer(2).timeout
#
#	GuiManager.destroy_gui(move_4, {
#		"transition_name": "move",
#		"transition_out": true,
#		"duration": 1,
#		"gui_position_origin": Vector2(0, 0),
#		"gui_position_end": Vector2(100, 0)
#	})


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause = !pause
		print(pause)
		get_tree().paused = pause
	

func _on_gui_on_screen(gui):
	print("loaded " + gui.id + " " + gui.name)
	
	
func _on_gui_off_screen(gui_id):
	print("unloaded " + gui_id)
