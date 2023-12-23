extends Container
signal esc_pressed 
@onready var pause_menu = $PauseMenu
@onready var schedule_browser_parent_window = $ScheduleBrowserParentWindow
@onready var schedule_browser_window = $ScheduleBrowserParentWindow/ScheduleBrowserWindow
@onready var course_catalogue_window = $CourseCatalogueWindow
@onready var registrar_manual_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/RegistrarManualTaskbarButton
@onready var browser_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/BrowserTaskbarButton
@onready var catalogue_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/CatalogueTaskbarButton
@onready var registrar_manual_window = $RegistrarManualWindow
@onready var desktop_shortcut_container = $Desktop/DesktopShortcutContainer
@onready var registrar_manual_desktop_shortcut = $Desktop/DesktopShortcutContainer/RegistrarManualDesktopShortcut
@onready var catalogue_desktop_shortcut = $Desktop/DesktopShortcutContainer/CatalogueDesktopShortcut
@onready var browser_desktop_shortcut = $Desktop/DesktopShortcutContainer/BrowserDesktopShortcut
@onready var email_window = $EmailWindow
@onready var email_taskbar_button = $Desktop/Taskbar/TaskbarShortcutContainer/EmailTaskbarButton
@onready var settings_menu = $PauseMenu/SettingsMenu
@onready var option_button = $PauseMenu/SettingsMenu/ResolutionDropdown/OptionButton
@onready var check_box = $PauseMenu/SettingsMenu/FullscreenCheckbox/CheckBox


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
		browser_taskbar_button.show()
		schedule_browser_parent_window.show()
		schedule_browser_window.show()

func _on_catalogue_desktop_shortcut_pressed():
	if course_catalogue_window.visible == true:
		pass
	else:
		catalogue_taskbar_button.show()
		course_catalogue_window.show()

func _on_catalogue_taskbar_button_pressed():
	if course_catalogue_window.visible == true: 
		course_catalogue_window.hide()
	else:
		course_catalogue_window.show()


func _on_registrar_manual_desktop_shortcut_pressed():
	if registrar_manual_window.visible == true:
		pass
	else:
		registrar_manual_taskbar_button.show()
		registrar_manual_window.show()


func _on_registrar_manual_taskbar_button_pressed():
	if registrar_manual_window.visible == true:
		registrar_manual_window.hide()
	else:
		registrar_manual_window.show()
		
func _on_email_taskbar_button_pressed():
	if email_window.visible == true:
		email_window.hide()
	else:
		email_window.show()


func _on_u_mail_pressed():
	if email_window.visible == true:
		pass
	else:
		email_taskbar_button.show()
		email_window.show()

func _on_settings_button_pressed():
	settings_menu.show()


func _on_settings_menu_close_requested():
	settings_menu.hide()
	pause_menu.show()

#controls changing the resolution of the game window based on the selected dropdown item
func _on_option_button_item_selected(index):
	var resolution = option_button.get_item_text(index)
	match resolution:
		"1920x1080":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1920,1080))
			DisplayServer.window_set_position(Vector2i(0,0))
		"1280x720":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280,720))

#controls changing whether or not the window is borderless based on if the checkbox is checked or not
func _on_check_box_toggled(button_pressed):
	var doink = DisplayServer.window_get_size()
	if button_pressed == true:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(doink)
		DisplayServer.window_set_position(Vector2i(0,0))
	elif button_pressed == false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(doink)
		
