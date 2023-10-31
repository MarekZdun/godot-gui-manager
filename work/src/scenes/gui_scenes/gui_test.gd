extends ProxyGui


@export var label_path: NodePath
@export var button_path: NodePath

var label: Label
var button: Button


func _ready():
	button = get_node(button_path)
	button.pressed.connect(_on_Button_pressed)
	
	label = get_node(label_path)
	label.text = self.name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	
func _on_Button_pressed():
	print("button was pressed")
