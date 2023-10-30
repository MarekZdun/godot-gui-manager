extends ProxyGui


@export var label_path: NodePath
var label: Label

@export var button_path: NodePath
var button: Button


func _ready():
	button = get_node(button_path)
	button.connect("pressed", Callable(self, "_on_Button_pressed"))
	
	label = get_node(label_path)
	label.text = self.name
	label.align = 1
	
	
func _on_Button_pressed():
	print("button was pressed")
