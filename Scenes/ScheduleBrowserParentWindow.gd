extends Window
@onready var schedule_browser_window = $ScheduleBrowserWindow
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	schedule_browser_window.hide()

