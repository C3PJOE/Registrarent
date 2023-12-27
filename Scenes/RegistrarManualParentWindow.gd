extends Window
@onready var registrar_manual_window = $RegistrarManualWindow
@onready var registrar_manual_taskbar_button = $"../Desktop/Taskbar/TaskbarShortcutContainer/RegistrarManualTaskbarButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	registrar_manual_window.hide()
	registrar_manual_taskbar_button.hide()
