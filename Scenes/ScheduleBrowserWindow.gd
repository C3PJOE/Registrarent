extends Window
signal esc_pressed 

var file ="res://StudentData/StudentData.json"
# Called when the node enters the scene tree for the first time.
@onready var pause_menu = $"../../PauseMenu"
@onready var student_name = $StudentInfoContainer/Name
@onready var year = $StudentInfoContainer/Year
@onready var major = $StudentInfoContainer/Major
@onready var minor = $StudentInfoContainer/Minor
@onready var fin_aid = $StudentInfoContainer/FinAid
@onready var account_status = $StudentInfoContainer/AccountStatus
@onready var student_info_container = $StudentInfoContainer
@onready var monday_container = $MondayContainer
@onready var m_label_1 = $MondayContainer/MLabel1





func _ready():
	print(_set_Current_Schedule())

func _set_Current_Schedule():
	var studentData= read_json_file()
	clearLabels()
	print(studentData[0])
	
	student_name.add_text("FULL NAME: " + studentData[0].NAME)
	year.add_text("YEAR: " + studentData[0].YEAR)
	major.add_text("MAJOR: "+ studentData[0].MAJOR)
	minor.add_text("MINOR: "+ studentData[0].MINOR)
	fin_aid.add_text("FINANCIAL AID: "+ studentData[0]["FINANCIAL AID"])
	account_status.add_text("ACCOUNT STATUS: "+ studentData[0]["ACCOUNT STATUS"])
	
	return studentData[0].keys()

func clearLabels():
	student_name.clear()
	year.clear()
	major.clear()
	minor.clear()
	fin_aid.clear()
	account_status.clear()
	
func read_json_file():
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict
	
func _input(event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("esc_pressed")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_esc_pressed():
	if pause_menu.visible == true:
		pause_menu.hide()
	else:
		pause_menu.show()
