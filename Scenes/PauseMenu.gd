extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass
	
func _on_window_input(event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		hide()


func _on_close_requested():
	hide()

func _on_resume_pressed():
	hide()
