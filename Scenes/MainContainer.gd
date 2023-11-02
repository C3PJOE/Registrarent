extends Container
signal esc_pressed 
@onready var pause_menu = $PauseMenu
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		print("flarpwindow")
		emit_signal("esc_pressed")
		
func _on_esc_pressed():
	if pause_menu.visible == true:
		pause_menu.hide()
	else:
		pause_menu.show()
