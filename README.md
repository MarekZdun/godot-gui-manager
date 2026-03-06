# GUI Manager(Godot 4.6 version)

A GUI Manager for [Godot Engine](https://godotengine.org/).<br />
Looking for a Godot 3.5 version? [See godot 3.5 branch](https://github.com/MarekZdun/godot-gui-manager/tree/3.5).

## 📄 Features
GuiManager - Manages smooth GUI transitions with ProxyGui integration
(c) Pioneer Games
v 2.0

## 📄 Description
GuiManager handles the addition, removal, and layering of GUI elements with smooth transition effects. 
It works in conjunction with ProxyGui-based scenes and TransitionConfig resources, 
providing a complete GUI management system for games with multiple screens.

## 📄 Requirements:
- Two directories must be set in the Inspector:
	- gui_scenes_dir - directory containing GUI scenes (e.g., res://gui/)
	- gui_transition_scenes_dir - directory containing transition scenes (e.g., res://gui/transitions/)
- All managed GUIs must inherit from ProxyGui
- All transitions must inherit from ProxyGuiTransition
- Transition configurations must use TransitionConfigResource or its derivatives

## 📄 Signals:
- manager_gui_loaded(gui) - emitted when a GUI finishes loading and appears on screen
- manager_gui_unloaded(gui) - emitted after GUI cleanup and removal

## 📄 Usage
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
	var config = TransitionConfigFadeResource.new()
	config.transition_name = "fade"
	config.duration = 1.0
	config.transition_out = false
	config.gui_opacity_start = 0.0
	config.gui_opacity_end = 1.0

	var gui_id = GuiManager.add_gui("gui_main_menu", 100, config)

5. Hide a GUI with transition:
	var config = TransitionConfigFadeResource.new()
	config.transition_name = "fade"
	config.duration = 0.5
	config.transition_out = true
	config.gui_opacity_start = 1.0
	config.gui_opacity_end = 0.0

	GuiManager.destroy_gui(gui_id, config)

6. Layer management:
	var gui_id = GuiManager.add_gui_above_top_one("gui_pause_menu", config)
	var gui_id = GuiManager.add_gui_under_top_one("gui_pause_menu", config)
	var new_id = GuiManager.change_gui_top_one("gui_settings", open_config, close_config)

8. Connect to signals:
	GuiManager.manager_gui_loaded.connect(_on_gui_shown)
	GuiManager.manager_gui_unloaded.connect(_on_gui_hidden)



