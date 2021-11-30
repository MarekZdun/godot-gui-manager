extends "res://addons/gui_manager/gui.gd"


export(NodePath) var label_path
var label: Label

export(NodePath) var button_path
var button: Button


func _ready():
	button = get_node(button_path)
	button.connect("pressed", self, "_on_Button_pressed")
	
	label = get_node(label_path)
	label.text = self.name
	label.align = 1
	
	
func _on_Button_pressed():
	print("button was pressed")
