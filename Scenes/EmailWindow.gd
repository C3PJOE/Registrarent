extends Window
signal esc_pressed
@onready var emails_container = $EmailContent/EmailsContainer
@onready var email_1 = $EmailContent/EmailsContainer/Email1
@onready var email_2 = $EmailContent/EmailsContainer/Email2
@onready var email_3 = $EmailContent/EmailsContainer/Email3
@onready var email_4 = $EmailContent/EmailsContainer/Email4
@onready var email_5 = $EmailContent/EmailsContainer/Email5
@onready var email_6 = $EmailContent/EmailsContainer/Email6
@onready var email_7 = $EmailContent/EmailsContainer/Email7
@onready var email_8 = $EmailContent/EmailsContainer/Email8
@onready var email_9 = $EmailContent/EmailsContainer/Email9
@onready var email_10 = $EmailContent/EmailsContainer/Email10
@onready var email_11 = $EmailContent/EmailsContainer/Email11
@onready var email_taskbar_button = $"../Desktop/Taskbar/TaskbarShortcutContainer/EmailTaskbarButton"
@onready var pause_menu = $"../PauseMenu"

var emails_container_children

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_email_1_button_pressed():
	if email_1.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_1.show()


func _on_email_2_button_pressed():
	if email_2.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_2.show()


func _on_email_3_button_pressed():
	if email_3.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_3.show()


func _on_email_4_button_pressed():
	if email_4.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_4.show()


func _on_email_5_button_pressed():
	if email_5.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_5.show()


func _on_email_6_button_pressed():
	if email_6.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_6.show()


func _on_email_7_button_pressed():
	if email_7.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_7.show()


func _on_email_8_button_pressed():
	if email_8.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_8.show()

func _on_email_9_button_pressed():
	if email_9.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_9.show()
	
func _on_email_10_button_pressed():
	if email_10.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_10.show()

func _on_email_11_button_pressed():
	if email_11.visible == true:
		pass
	else:
		for n in range(0,emails_container.get_child_count()):
			emails_container.get_child(n).hide()
		email_11.show()
		
func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	email_taskbar_button.hide()
	
func _input(event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("esc_pressed")

func _on_esc_pressed():
	if pause_menu.visible == true:
		pause_menu.hide()
	else:
		pause_menu.show()
