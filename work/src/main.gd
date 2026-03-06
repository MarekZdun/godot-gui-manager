extends Node

@export var window_manager: Resource
@export var transition_config_fade_in_001: TransitionConfigFadeResource
@export var transition_config_fade_in_002: TransitionConfigFadeResource
@export var transition_config_fade_out_001: TransitionConfigFadeResource
@export var transition_config_fade_out_002: TransitionConfigFadeResource
@export var transition_config_move_in_001: TransitionConfigMoveResource
@export var transition_config_move_out_001: TransitionConfigMoveResource

var pause: bool = false


func _ready():
	WindowManager.load(window_manager)

	GuiManager.manager_gui_loaded.connect(_on_gui_on_screen)
	GuiManager.manager_gui_unloaded.connect(_on_gui_off_screen)
	
	await get_tree().create_timer(1).timeout
	
	var gui_0 := GuiManager.add_gui("gui_curtain", 127, transition_config_fade_in_001)

	await GuiManager.get_gui(gui_0).gui_loaded

	var gui_1 := GuiManager.add_gui_above_top_one("gui_progress", transition_config_fade_in_002)

	await GuiManager.get_gui(gui_1).gui_loaded

	GuiManager.destroy_gui(gui_1, transition_config_fade_out_001)

	await GuiManager.get_gui(gui_1).gui_unloaded

	GuiManager.destroy_gui(gui_0, transition_config_fade_out_002)



	#var move_1 := GuiManager.add_gui("gui_curtain", 127, transition_config_move_in_001)
#
	#await get_tree().create_timer(2).timeout
#
	#GuiManager.destroy_all()


	#var move_3 := GuiManager.add_gui("gui_test", 127, transition_config_move_in_001)
#
	#await get_tree().create_timer(2).timeout
#
	#var move_4 := GuiManager.change_gui_top_one("gui_curtain", transition_config_move_in_001, transition_config_move_out_001)
#
	#await get_tree().create_timer(2).timeout
#
	#GuiManager.destroy_gui(move_4, transition_config_move_out_001)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause = !pause
		print(pause)
		get_tree().paused = pause
	

func _on_gui_on_screen(gui):
	print("[LOG] loaded " + gui.id + " " + gui.name)
	
	
func _on_gui_off_screen(gui_id):
	print("[LOG] unloaded " + gui_id)
