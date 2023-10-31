extends ProxyGuiTransition


var mode: String = ProjectSettings.get_setting("display/window/stretch/mode")
var aspect: String = ProjectSettings.get_setting("display/window/stretch/aspect")
var gui_position_origin: Vector2
var gui_position_end: Vector2
var transition_type: int
var easy_type: int
var tween: Tween


func _setup(transition_config: Dictionary) -> void:
	gui_position_origin = transition_config.gui_position_origin
	gui_position_end = transition_config.gui_position_end
	transition_type = transition_config.transition_type if transition_config.has("transition_type") else Tween.TRANS_LINEAR 
	easy_type = transition_config.easy_type if transition_config.has("easy_type") else Tween.EASE_IN_OUT
	
	root.global_position = remap_position_to_screen(gui_position_origin)
	root.show()
	
	resized.connect(_on_resized)
	
	tween = create_tween()
	var tween_callback := "_on_tween_out_ended" if transition_out else "_on_tween_in_ended"   
	tween.finished.connect(Callable(self, tween_callback).bind(root), CONNECT_ONE_SHOT)
	tween.tween_property(root, "global_position", remap_position_to_screen(gui_position_end), duration).set_trans(transition_type).set_ease(easy_type)


func remap_position_to_screen(position: Vector2) -> Vector2:
	var gui_size_origin := root.get_global_rect().size
	var x := remap(position.x, 0, 100, 0, gui_size_origin.x) 
	var y := remap(position.y, 0, 100, 0, gui_size_origin.y)
	return Vector2(x, y)
	
	
func _pre_destroy() -> void:
	if tween.is_valid():
		tween.kill()
	
	
func _on_resized():
	if (
			mode == "disabled" or
			((mode == "2d" or mode == "viewport") and 
			(aspect == "keep_width" or aspect == "keep_height" or aspect == "expand")) 
	):
		if tween.is_valid():
			tween.kill()
			var gui_position_origin_remaped := remap_position_to_screen(gui_position_origin)
			var gui_position_end_remaped := remap_position_to_screen(gui_position_end)
			tween.tween_property(root, "global_position", gui_position_end_remaped, duration).from(gui_position_origin_remaped).set_trans(transition_type).set_ease(easy_type)


func _on_tween_in_ended(object: Object):
	transition_in_ended.emit(object)
	
	
func _on_tween_out_ended(object: Object):
	transition_out_ended.emit(object)


