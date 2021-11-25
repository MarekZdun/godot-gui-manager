extends Control
"""
Transition base

Usage:
-right click on transition.tscn file in File System and choose New Inherited Scene

-right click on Transition node (top one) and choose Extend Script to add additional funcionality to your transition

-add AnimatioPlayer/Tween as child of Transition node

-override _setup(transition_config: Dictionary) and _pre_destroy() virtual functions

-don't forget about emitting signal transition_in_ended/transition_out_ended after transition is done 
"""


signal transition_in_ended(gui)
signal transition_out_ended(gui)


var root: Control
var duration: float
var transition_out: bool


func setup(transition_config: Dictionary) -> void:
	root = transition_config.root
	duration = transition_config.duration
	transition_out = transition_config.transition_out
	
	_setup(transition_config)
	
	
func pre_destroy() -> void:
	_pre_destroy()


func _setup(transition_config: Dictionary) -> void:
	assert(false, "Override activate in subtypes")
	
	
func _pre_destroy() -> void:
	assert(false, "Override activate in subtypes")
