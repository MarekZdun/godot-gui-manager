@abstract class_name ProxyGuiTransition
extends Control
"""
ProxyGuiTransition - Abstract base class for GUI transition effects

DESCRIPTION:
ProxyGuiTransition is an abstract base class for all transition effects used by the GUI system. 
It provides a standardized interface for creating smooth appearing/disappearing animations for GUI elements. 
Custom transitions (fade, slide, scale, etc.) are created by extending this class and implementing its abstract methods.

REQUIREMENTS:
- Must override _setup() and _pre_destroy() abstract methods
- Must emit transition_in_ended or transition_out_ended when animation completes

SIGNALS:
- transition_in_ended(gui) - emitted when "appear" transition finishes
- transition_out_ended(gui) - emitted when "disappear" transition finishes

USAGE:
1. Create a new scene:
	- Create a new scene with a Control node as root
	- Save the scene (e.g., fade.tscn)

2. Add the script:
	- Attach a script to the root Control node
	- Make the script extend ProxyGuiTransition

3. Implement transition logic:
	- Override _setup() and _pre_destroy() methods

4. Connect signals:
	- Emit transition_in_ended when "appear" animation finishes
	- Emit transition_out_ended when "disappear" animation finishes
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
