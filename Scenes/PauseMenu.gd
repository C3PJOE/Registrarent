extends Window
@onready var settings_menu = $SettingsMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
	pass
	
func _on_window_input(_event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		if settings_menu.visible == true:
			settings_menu.hide()
		else:
			hide()

func _on_close_requested():
	if settings_menu.visible == true:
		settings_menu.hide()
	else:
		hide()

func _on_resume_pressed():
	hide()


func _on_focus_entered():
	await get_tree().create_timer(1).timeout
