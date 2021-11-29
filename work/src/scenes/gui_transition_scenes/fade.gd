extends "res://addons/gui_manager/transition.gd"


var gui_opacity_start: float
var gui_opacity_end: float
var tween: Tween


func _ready():
	tween = Tween.new()
	add_child(tween)
	
	
func _setup(transition_config: Dictionary) -> void:
	gui_opacity_start = transition_config.gui_opacity_start
	gui_opacity_end = transition_config.gui_opacity_end
		
	root.modulate.a = gui_opacity_start
	root.show()

	var tween_callback = "_on_tween_out_ended" if transition_out else "_on_tween_in_ended"   
	tween.connect("tween_completed", self, tween_callback)

	tween.interpolate_property(root, "modulate:a", null, gui_opacity_end, duration)
	tween.start()
	
	
func _pre_destroy() -> void:
	tween.remove_all()
	
	
func _on_tween_in_ended(object: Object, key: NodePath):
	emit_signal("transition_in_ended", object.get_parent())
	
	
func _on_tween_out_ended(object: Object, key: NodePath):
	emit_signal("transition_out_ended", object.get_parent())
