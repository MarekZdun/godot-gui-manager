extends ProxyGui


@export var label_path: NodePath
@export var button_path: NodePath

@onready var label: Label = get_node(label_path)
@onready var button: Button = get_node(button_path)


func _ready():
	button.pressed.connect(_on_Button_pressed)
	
	label.text = self.name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	
func _on_Button_pressed():
	print("button was pressed")
