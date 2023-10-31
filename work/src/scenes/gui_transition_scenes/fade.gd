extends ProxyGuiTransition


var gui_opacity_start: float
var gui_opacity_end: float
var transition_type: int
var easy_type: int
var tween: Tween
	
	
func _setup(transition_config: Dictionary) -> void:
	gui_opacity_start = transition_config.gui_opacity_start
	gui_opacity_end = transition_config.gui_opacity_end
	transition_type = transition_config.transition_type if transition_config.has("transition_type") else Tween.TRANS_LINEAR 
	easy_type = transition_config.easy_type if transition_config.has("easy_type") else Tween.EASE_IN_OUT
		
	root.modulate.a = gui_opacity_start
	root.show()

	tween = create_tween()
	var tween_callback := "_on_tween_out_ended" if transition_out else "_on_tween_in_ended"
	tween.finished.connect(Callable(self, tween_callback).bind(root), CONNECT_ONE_SHOT)
	tween.tween_property(root, "modulate:a", gui_opacity_end, duration).set_trans(transition_type).set_ease(easy_type)
	
	
func _pre_destroy() -> void:
	if tween.is_valid():
		tween.kill()
	
	
func _on_tween_in_ended(object: Object):
	transition_in_ended.emit(object)
	
	
func _on_tween_out_ended(object: Object):
	transition_out_ended.emit(object)
