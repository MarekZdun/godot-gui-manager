extends Node2D

signal window_changed(view)


var manager_data : WindowManagerResource
var window_index : int

const version = "3.2-R1-dev"


func load(data : WindowManagerResource):
	manager_data = data
	_start()


func _process(delta):

	if (!manager_data):
		return

	if (Input.is_action_just_pressed(manager_data.next_size_action)):
		_next_window()

func _start():
	window_index = -1

	if (manager_data.use_default):
		for window in (manager_data.windows):
			window_index += 1
			var w = window as WindowResource
			if (w.default):
				_change_window(w)
				return

func _change_window(view : WindowResource):
	if (view.fullscreen):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (true) else Window.MODE_WINDOWED
	else:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED

	get_window().size = Vector2(view.width, view.height)

	emit_signal("window_changed", view)


func _next_window():
	window_index += 1
	if (window_index > manager_data.windows.size() - 1):
		window_index = 0

	_change_window(manager_data.windows[window_index])


func _ready():
	
	print(" ")
	print("godot-stuff WindowManager")
	print("https://gitlab.com/godot-stuff/gs-window-manager")
	print("Copyright 2018-2020, SpockerDotNet LLC")
	print("Version " + version)
	print(" ")
