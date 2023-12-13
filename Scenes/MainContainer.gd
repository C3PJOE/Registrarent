extends Container
signal esc_pressed 
@onready var pause_menu = $PauseMenu
@onready var schedule_browser_parent_window = $ScheduleBrowserParentWindow
@onready var schedule_browser_window = $ScheduleBrowserParentWindow/ScheduleBrowserWindow
@onready var course_catalogue_parent_window = $CourseCatalogueParentWindow
@onready var course_catalogue_window = $CourseCatalogueParentWindow/CourseCatalogueWindow
@onready var browser_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/BrowserTaskbarButton
@onready var catalogue_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/CatalogueTaskbarButton
@onready var registar_manual_parent_window = $RegistarManualParentWindow
@onready var registrar_manual_window = $RegistarManualParentWindow/RegistrarManualWindow
@onready var desktop_shortcut_container = $Desktop/DesktopShortcutContainer
@onready var registrar_manual_desktop_shortcut = $Desktop/DesktopShortcutContainer/RegistrarManualDesktopShortcut
@onready var catalogue_desktop_shortcut = $Desktop/DesktopShortcutContainer/CatalogueDesktopShortcut
@onready var browser_desktop_shortcut = $Desktop/DesktopShortcutContainer/BrowserDesktopShortcut


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _input(event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("esc_pressed")
		
func _on_esc_pressed():
	if pause_menu.visible == true:
		pause_menu.hide()
	else:
		pause_menu.show()

func _on_browser_taskbar_button_pressed():
	if schedule_browser_parent_window.visible == true: 
		schedule_browser_parent_window.hide()
		schedule_browser_window.hide()
	else:
		schedule_browser_parent_window.show()
		schedule_browser_window.show()

func _on_browser_desktop_shortcut_pressed():
	if schedule_browser_parent_window.visible == true:
		pass
	else:
		schedule_browser_parent_window.show()
		schedule_browser_window.show()

func _on_catalogue_desktop_shortcut_pressed():
	if course_catalogue_parent_window.visible == true:
		pass
	else:
		course_catalogue_parent_window.show()
		course_catalogue_window.show()

func _on_catalogue_taskbar_button_pressed():
	if course_catalogue_parent_window.visible == true: 
		course_catalogue_parent_window.hide()
		course_catalogue_window.hide()
	else:
		course_catalogue_parent_window.show()
		course_catalogue_window.show()
	


func _on_registrar_manual_desktop_shortcut_pressed():
	if registar_manual_parent_window.visible == true:
		pass
	else:
		registar_manual_parent_window.show()
		registrar_manual_window.show()
