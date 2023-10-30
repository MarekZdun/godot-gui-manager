tool
extends EditorPlugin

const GUI_MANAGER_FILEPATH = "res://addons/gui_manager/gui_manager.tscn"
const GUI_MANAGER_AUTLOAD_NAME = "GuiManager"


func enable_plugin():
	add_autoload_singleton(GUI_MANAGER_AUTLOAD_NAME, GUI_MANAGER_FILEPATH)


func disable_plugin():
	remove_autoload_singleton(GUI_MANAGER_AUTLOAD_NAME)
