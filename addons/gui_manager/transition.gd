@abstract class_name ProxyGuiTransition
extends Control
"""
ProxyGuiTransition

Usage:
-right click on transition.tscn file in File System and choose New Inherited Scene

-right click on Transition node (top one) and choose Extend Script to add additional funcionality to your transition

-add AnimatioPlayer/Tween as child of Transition node if you want to use smooth transitions

-override _setup(transition_config: Dictionary) and _pre_destroy() virtual functions

-don't forget about emitting signal transition_in_ended/transition_out_ended after transition is done 
"""

signal transition_in_ended(gui)
signal transition_out_ended(gui)


var root: Control
var duration: float
var transition_out: bool


func setup(p_root: Control, transition_config: TransitionConfigResource) -> void:
	root = p_root
	duration = transition_config.duration
	transition_out = transition_config.transition_out
	_setup(transition_config)
	
	
func pre_destroy() -> void:
	_pre_destroy()


@abstract func _setup(transition_config: TransitionConfigResource) -> void
	
@abstract func _pre_destroy() -> void
