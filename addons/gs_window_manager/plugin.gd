@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("WindowManager", "res://addons/gs_window_manager/window_manager.tscn")
	
	
func _exit_tree():
	remove_autoload_singleton("WindowManager")
