extends Window
@onready var course_catalogue_window = $CourseCatalogueWindow
@onready var catalogue_taskbar_button = $"../Desktop/Taskbar/TaskbarShortcutContainer/CatalogueTaskbarButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	course_catalogue_window.hide()
	catalogue_taskbar_button.hide()
