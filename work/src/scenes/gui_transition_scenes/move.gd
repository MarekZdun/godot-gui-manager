extends "res://addons/gui-manager/transition.gd"


var mode: String = ProjectSettings.get_setting("display/window/stretch/mode")
var aspect: String = ProjectSettings.get_setting("display/window/stretch/aspect")
var gui_position_origin: Vector2
var gui_position_end: Vector2
var tween: Tween


func _ready():
	tween = Tween.new()
	add_child(tween)


func _setup(transition_config: Dictionary):
	gui_position_origin = transition_config.gui_position_origin
	gui_position_end = transition_config.gui_position_end
	
	root.rect_global_position = remap_position_to_screen(gui_position_origin)
	root.show()
	
	self.connect("resized", self, "_on_resized")
	
	var tween_callback = "_on_tween_out_ended" if transition_out else "_on_tween_in_ended"   
	tween.connect("tween_completed", self, tween_callback)
	
	tween.interpolate_property(root, "rect_global_position", null, remap_position_to_screen(gui_position_end), duration)
	tween.start()


func remap_position_to_screen(position: Vector2) -> Vector2:
	var gui_size_origin = root.get_global_rect().size
	var x = range_lerp(position.x, 0, 100, 0, gui_size_origin.x) 
	var y = range_lerp(position.y, 0, 100, 0, gui_size_origin.y)
	return Vector2(x, y)
	
	
func _pre_destroy():
	tween.remove_all()
	
	
func _on_resized():
	if (
			mode == "disabled" or
			((mode == "2d" or mode == "viewport") and 
			(aspect == "keep_width" or aspect == "keep_height" or aspect == "expand")) 
	):
		tween.remove(root, "rect_global_position")
		tween.interpolate_property(root, "rect_global_position", remap_position_to_screen(gui_position_origin), remap_position_to_screen(gui_position_end), duration)


func _on_tween_in_ended(object: Object, key: NodePath):
	emit_signal("transition_in_ended", object.get_parent())
	
	
func _on_tween_out_ended(object: Object, key: NodePath):
	emit_signal("transition_out_ended", object.get_parent())


