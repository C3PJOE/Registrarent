extends Window
signal esc_pressed 

@onready var pause_menu = $"../../PauseMenu"
#student info container and labels
@onready var student_info_container = $StudentInfoContainer
@onready var student_name = $StudentInfoContainer/Name
@onready var year = $StudentInfoContainer/Year
@onready var major = $StudentInfoContainer/Major
@onready var minor = $StudentInfoContainer/Minor
@onready var fin_aid = $StudentInfoContainer/FinAid
@onready var account_status = $StudentInfoContainer/AccountStatus
#monday container and labels
@onready var monday_container = $MondayContainer
@onready var m_label_1 = $MondayContainer/MLabel1
@onready var m_label_2 = $MondayContainer/MLabel2
@onready var m_label_3 = $MondayContainer/MLabel3
@onready var m_label_4 = $MondayContainer/MLabel4
@onready var m_label_5 = $MondayContainer/MLabel5
@onready var m_spacer_label = $MondayContainer/MSpacerLabel
#tuesday container and labels
@onready var tuesday_container = $"Tuesday Container"
@onready var t_label_1 = $"Tuesday Container/TLabel1"
@onready var t_label_2 = $"Tuesday Container/TLabel2"
@onready var t_label_3 = $"Tuesday Container/TLabel3"
@onready var t_label_4 = $"Tuesday Container/TLabel4"
@onready var t_label_5 = $"Tuesday Container/TLabel5"
@onready var t_spacer_label = $"Tuesday Container/TSpacerLabel"
#Wednesday container and labels
@onready var wednesday_container = $WednesdayContainer
@onready var w_label_1 = $WednesdayContainer/WLabel1
@onready var w_label_2 = $WednesdayContainer/WLabel2
@onready var w_label_3 = $WednesdayContainer/WLabel3
@onready var w_label_4 = $WednesdayContainer/WLabel4
@onready var w_label_5 = $WednesdayContainer/WLabel5
@onready var w_spacer_label = $WednesdayContainer/WSpacerLabel
#Thursday container and labels
@onready var thursday_container = $ThursdayContainer
@onready var th_label_1 = $ThursdayContainer/ThLabel1
@onready var th_label_2 = $ThursdayContainer/ThLabel2
@onready var th_label_3 = $ThursdayContainer/ThLabel3
@onready var th_label_4 = $ThursdayContainer/ThLabel4
@onready var th_label_5 = $ThursdayContainer/ThLabel5
@onready var th_spacer_label = $ThursdayContainer/ThSpacerLabel
#Friday container and labels
@onready var friday_container = $FridayContainer
@onready var f_label_1 = $FridayContainer/FLabel1
@onready var f_label_2 = $FridayContainer/FLabel2
@onready var f_label_3 = $FridayContainer/FLabel3
@onready var f_label_4 = $FridayContainer/FLabel4
@onready var f_label_5 = $FridayContainer/FLabel5
@onready var f_spacer_label = $FridayContainer/FSpacerLabel

var file1 ="res://UniData/StudentData.json"
var file2 = "res://UniData/ClassData.json"

var studentData= read_json_file(file1)
var classData = read_json_file(file2)

func _ready():
	#index variable we will pass to set current schedule to tell it which 
	#student needs to have their schedule set
	var studentIndex = 0
	print(start(studentIndex))
	
#calls the set current schedule function 
func start(student:int):
	_set_Current_Schedule(student)
	
func _set_Current_Schedule(student: int):
	
	#var to hold stored result of check for class function
	var checkedResult
	clearLabels()
	
	#fills label with correct student info 
	student_name.add_text("FULL NAME: " + studentData[student].NAME)
	year.add_text("YEAR: " + studentData[student].YEAR)
	major.add_text("MAJOR: "+ studentData[student].MAJOR)
	minor.add_text("MINOR: "+ studentData[student].MINOR)
	fin_aid.add_text("FINANCIAL AID: "+ studentData[student]["FINANCIAL AID"])
	account_status.add_text("ACCOUNT STATUS: "+ studentData[student]["ACCOUNT STATUS"])
	
	#separates the monday classes into indeces in an array 
	var mon:String = studentData[student].MONDAY
	var mon_class_array = mon.rsplit(",", true, 5)
	print("\n")
	print(mon_class_array[0])
	#separates the tuesday classes into indeces in an array 
	var tues:String = studentData[student].TUESDAY
	var tues_class_array = tues.rsplit(",",true,5)
	#separates the wednesday classes into indeces in an array
	var wed:String = studentData[student].WEDNESDAY
	var wed_class_array = wed.rsplit(",",true,5)
	#separates the thursday classes into indeces in an array
	var thurs:String = studentData[student].THURSDAY
	var thurs_class_array = thurs.rsplit(",",true,5)
	#separates the friday classes into indeces in an array
	var fri:String = studentData[student].FRIDAY
	var fri_class_array = fri.rsplit(",",true,5)
	#array that holds the classes for every day of the week, as set above
	var parent_class_array = [mon_class_array,tues_class_array,wed_class_array,thurs_class_array,fri_class_array]
	
	#iterates through each item in the parent_class_array
	for day_of_week in parent_class_array.size():
		#checks which day of the week it is(monday being 0, friday being 4)
		match day_of_week:
			0:
				label_sorter(0,parent_class_array[day_of_week].size(),parent_class_array)

			1:
				pass
			2:
				pass
			3:
				pass
			4:
				pass
			
	#return classData[0].keys()
	#return studentData[0].keys()

#dizzy emoji what a mess I gotta stop coding at night my brain thinks of bad solutions
func label_sorter(day:int, label_count:int, parent_array:Array):
	var checkedResult:Array
	print(label_count)
	match day:
		0:
			match label_count:
				0:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + " " + checkedResult[0].CLASSLOCATION
					m_label_1.add_text(labelText)
					print("I GOT HERE")
				1:
					pass
				2:
					pass
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					m_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					m_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					m_label_3.add_text(labelText)
					
					
					print("I GOT HERE")
				4:
					pass
				_:
					print("labelCount invalid")
		1:
			match label_count:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				_:
					print("labelCount invalid")
		2:
			match label_count:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				_:
					print("labelCount invalid")
		3:
			match label_count:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				_:
					print("labelCount invalid")
		4:
			match label_count:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				_:
					print("labelCount invalid")
func clearLabels():
	student_name.clear()
	year.clear()
	major.clear()
	minor.clear()
	fin_aid.clear()
	account_status.clear()
	
	m_label_1.clear()
	m_label_2.clear()
	m_label_3.clear()
	
#function to read json files and returns them as a dictionary
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict
	
#WILL NEED TO CHECK STUDENT'S SCHEDULE OF CLASSES AGAINST
#UNIVERSITY CLASSDATA TO DETERMINE LOCATION + TIME OF CLASS, 
#EXAMPLE: BOB HAS CS 101. WE HAVE THAT IMPORTED IN VAR STUDENTDATA,
#SO WE WILL GO THROUGH THE IMPORTED CLASS DATA UNTIL WE FIND CS 101. 
#FROM THERE, WE CAN USE THE CLASS DATA TO ASCERTAIN TIME, LOCATION, DURATION, ETC FROM THE CLASS 
#AND THEN FILL THE CORRESPONDING LABEL ON THE SCHEDULE 
#compares the two passed arrays and returns an array of all the matching results
func check_for_class(sData:Array, cData :Array):
	#creates an array and sets its size to that of the passed student data array
	var smushedTogetherData = []
	smushedTogetherData.resize(sData.size())
	#two index trackers we will use to iterate through the loop comparing these two arrays
	var s_data_index = 0
	var c_data_index = 0
	#iterates through both arrays and compares them
	while s_data_index < sData.size() and c_data_index < cData.size():
		#print("\n S",s_data_index," ",sData[s_data_index])
		#print("\n C",c_data_index," ",cData[c_data_index])
		#if the content of the first paremeter (the array of student data) matches the content of the first paremeter's classname key
		if sData[s_data_index] == cData[c_data_index].CLASSNAME:
			smushedTogetherData.insert(s_data_index,cData[c_data_index])
			s_data_index+=1
		else:
			pass
		#increments the class data index
		c_data_index+=1

	return smushedTogetherData
	
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
