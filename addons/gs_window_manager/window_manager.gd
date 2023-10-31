extends Node2D

signal window_changed(view)


var manager_data : WindowManagerResource
var window_index : int

const VERSION = "4.x"


func load(data : WindowManagerResource):
	manager_data = data
	_start()


func _process(delta):

	if (!manager_data):
		return

	if (Input.is_action_just_pressed(manager_data.next_size_action)):
		_next_window()

func _start():
	
#	Logger.trace("[WindowManager] _start")

	window_index = -1

	if (manager_data.use_default):
		for window in (manager_data.windows):
			window_index += 1
			var w = window as WindowResource
			if (w.default):
				_change_window(w)
				return

func _change_window(view : WindowResource):
	
#	Logger.trace("[WindowManager] _change_window")

	if (view.fullscreen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	DisplayServer.window_set_size(Vector2(view.width, view.height))

	emit_signal("window_changed", view)


func _next_window():

#	Logger.trace("[WindowManager] _next_window")

	window_index += 1

#	Logger.debug("- window index is : {0}".format([window_index]))

	if (window_index > manager_data.windows.size() - 1):
		window_index = 0

	_change_window(manager_data.windows[window_index])


func _init():
	
	print()
	print("godot-stuff WindowManager")
	print("https://gitlab.com/godot-stuff/gs-window-manager")
	print("Copyright 2018-2023, SpockerDotNet LLC. All rights reserved.")
	print("Version " + VERSION)
	print()

func _ready():
	
	pass
