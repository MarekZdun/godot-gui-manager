class_name TransitionConfigResource
extends Resource

@export var transition_name: String = ""
@export var duration: float = 1.0
@export var transition_out: bool = false


func _init(p_transition_name: String = "", p_duration: float = 1.0, p_transition_out: bool = false) -> void:
	transition_name = p_transition_name
	duration = p_duration
	transition_out = p_transition_out
