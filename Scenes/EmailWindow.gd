extends Window
@onready var emails_container = $EmailContent/EmailsContainer
@onready var email_1 = $EmailContent/EmailsContainer/Email1
@onready var email_2 = $EmailContent/EmailsContainer/Email2

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
