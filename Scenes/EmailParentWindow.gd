extends Window
@onready var email_parent_window = $"."
@onready var email_window = $EmailWindow
@onready var email_taskbar_button = $"../Desktop/Taskbar/TaskbarShortcutContainer/EmailTaskbarButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	email_window.hide()
	email_taskbar_button.hide()
