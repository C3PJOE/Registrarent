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
@onready var monday_container = $WeekContainer/MondayContainer
@onready var m_label_1 = $WeekContainer/MondayContainer/MLabel1
@onready var m_label_2 = $WeekContainer/MondayContainer/MLabel2
@onready var m_label_3 = $WeekContainer/MondayContainer/MLabel3
@onready var m_label_4 = $WeekContainer/MondayContainer/MLabel4
@onready var m_label_5 = $WeekContainer/MondayContainer/MLabel5
@onready var m_spacer_label = $WeekContainer/MondayContainer/MSpacerLabel
#tuesday container and labels
@onready var tuesday_container = $WeekContainer/"Tuesday Container"
@onready var t_label_1 = $WeekContainer/"Tuesday Container/TLabel1"
@onready var t_label_2 = $WeekContainer/"Tuesday Container/TLabel2"
@onready var t_label_3 = $WeekContainer/"Tuesday Container/TLabel3"
@onready var t_label_4 = $WeekContainer/"Tuesday Container/TLabel4"
@onready var t_label_5 = $WeekContainer/"Tuesday Container/TLabel5"
@onready var t_spacer_label = $WeekContainer/"Tuesday Container/TSpacerLabel"
#Wednesday container and labels
@onready var wednesday_container = $WeekContainer/WednesdayContainer
@onready var w_label_1 = $WeekContainer/WednesdayContainer/WLabel1
@onready var w_label_2 = $WeekContainer/WednesdayContainer/WLabel2
@onready var w_label_3 = $WeekContainer/WednesdayContainer/WLabel3
@onready var w_label_4 = $WeekContainer/WednesdayContainer/WLabel4
@onready var w_label_5 = $WeekContainer/WednesdayContainer/WLabel5
@onready var w_spacer_label = $WeekContainer/WednesdayContainer/WSpacerLabel
#Thursday container and labels
@onready var thursday_container = $WeekContainer/ThursdayContainer
@onready var th_label_1 = $WeekContainer/ThursdayContainer/ThLabel1
@onready var th_label_2 = $WeekContainer/ThursdayContainer/ThLabel2
@onready var th_label_3 = $WeekContainer/ThursdayContainer/ThLabel3
@onready var th_label_4 = $WeekContainer/ThursdayContainer/ThLabel4
@onready var th_label_5 = $WeekContainer/ThursdayContainer/ThLabel5
@onready var th_spacer_label = $WeekContainer/ThursdayContainer/ThSpacerLabel
#Friday container and labels
@onready var friday_container = $WeekContainer/FridayContainer
@onready var f_label_1 = $WeekContainer/FridayContainer/FLabel1
@onready var f_label_2 = $WeekContainer/FridayContainer/FLabel2
@onready var f_label_3 = $WeekContainer/FridayContainer/FLabel3
@onready var f_label_4 = $WeekContainer/FridayContainer/FLabel4
@onready var f_label_5 = $WeekContainer/FridayContainer/FLabel5
@onready var f_spacer_label = $WeekContainer/FridayContainer/FSpacerLabel

var file1 ="res://UniData/StudentData.json"
var file2 = "res://UniData/ClassData.json"
#vars to hold the data from the class and student json files
var studentData#= read_json_file(file1)
var classData #= read_json_file(file2)
var studentIndex

func _ready():
	#index variable we will pass to set current schedule to tell it which 
	#student needs to have their schedule set
	studentIndex = 0
	start(studentIndex)
	
#calls the set current schedule function 
func start(student:int):
	studentData= read_json_file(file1)
	classData = read_json_file(file2)
	_set_Current_Schedule(student)
	
func _set_Current_Schedule(student: int):
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
	
	print ("STUDENT INDEX: " ,studentIndex)
	print("STUDENT DATA SIZE: ",studentData.size())
	#iterates from 0 to 4 and calls label_sorter with respect to day_of_week, with 0 being monday and 4 being friday
	for day_of_week in range(0,5):
		#calls label_sorter for each day of the week, with 0 being monday and 4 being tuesday
		label_sorter(day_of_week,parent_class_array[day_of_week].size(),parent_class_array)
	
	#increases the student index once the current student's schedule is set up,
	#so when set_current_schedule is called again it creates the next student's schedule
	
	#return classData.keys()
	#return studentData.keys()
	
#dizzy emoji what a mess I gotta stop coding at night my brain thinks of bad solutions
func label_sorter(day:int, label_count:int, parent_array:Array):
	var checkedResult:Array
	#print("LABEL COUNT FOR ", day,": ", label_count)
	match day:
		0:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					m_label_1.add_text(labelText)
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					m_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					m_label_2.add_text(labelText)
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIMEMONDAY + "-" + checkedResult[0].CLASSENDTIMEMONDAY
					m_label_1.append_text("[center]%s[/center]" % labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIMEMONDAY + "-" + checkedResult[1].CLASSENDTIMEMONDAY
					m_label_2.append_text("[center]%s[/center]" % labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIMEMONDAY + "-" + checkedResult[2].CLASSENDTIMEMONDAY
					m_label_3.append_text("[center]%s[/center]" % labelText)
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					m_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					m_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					m_label_3.add_text(labelText)
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION
				_:
					print("labelCount invalid")
		1:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					t_label_1.add_text(labelText)
				2:
					checkedResult = check_for_class(parent_array[day],classData) 
					#print("CR",checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					t_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					t_label_2.add_text(labelText)
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					t_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					t_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					t_label_3.add_text(labelText)
					
					
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					t_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					t_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					t_label_3.add_text(labelText)
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION
				_:
					print("labelCount invalid")
		2:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					w_label_1.add_text(labelText)
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					#print ("CR\n",checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					w_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					w_label_2.add_text(labelText)
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					w_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					w_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					w_label_3.add_text(labelText)
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					w_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					w_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					w_label_3.add_text(labelText)
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION
				_:
					print("labelCount invalid")
		3:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					th_label_1.add_text(labelText)
				2:
					checkedResult = check_for_class(parent_array[day],classData) 
					#print("CR",checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					th_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					th_label_2.add_text(labelText)
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					th_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					th_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					th_label_3.add_text(labelText)
					
					
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					th_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					th_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					th_label_3.add_text(labelText)
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION
				_:
					print("labelCount invalid")
		4:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					f_label_1.add_text(labelText)
				2:
					checkedResult = check_for_class(parent_array[day],classData) 
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					f_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					f_label_2.add_text(labelText)
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					f_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					f_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					f_label_3.add_text(labelText)
					
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION
					f_label_1.add_text(labelText)
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION
					f_label_2.add_text(labelText)
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION
					f_label_3.add_text(labelText)
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION
				_:
					print("labelCount invalid")
					
#function solely dedicated to increasing the student index var,
#because I know without it i will lose track of this variable
func increment_student_index():
	studentIndex += 1
#clears the labels of text 
func clearLabels():
	#clears student info labels
	student_name.clear()
	year.clear()
	major.clear()
	minor.clear()
	fin_aid.clear()
	account_status.clear()
	#clears monday labels
	m_label_1.clear()
	m_label_2.clear()
	m_label_3.clear()
	m_label_4.clear()
	#clears tuesday labels
	t_label_1.clear()
	t_label_2.clear()
	t_label_3.clear()
	t_label_4.clear()
	#clears wednesday labels
	w_label_1.clear()
	w_label_2.clear()
	w_label_3.clear()
	w_label_4.clear()
	#clears thursday labels
	th_label_1.clear()
	th_label_2.clear()
	th_label_3.clear()
	th_label_4.clear()
	#clears friday labels
	f_label_1.clear()
	f_label_2.clear()
	f_label_3.clear()
	f_label_4.clear()
	
#function to read json files and returns them as a dictionary
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict
	
#function that lets us compare the student data dictionary vs the class data dictionary,
#which will be used to fill the labels on the schedules
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
		#print("SDATAINDEX",s_data_index)
		#print("SIZEOFCDATA",cData.size())
		#print("CDATAINDEX",c_data_index)
		#print("Top of loop"," cDataIndex ",c_data_index," cData size ",cData.size())
		
		#if at the end of the class data index there is a match, but not all the student data has been matched yet,
		#add the matching classes to the array & reset the class data index to continue checking 
		if c_data_index == cData.size()-1 and sData[s_data_index]== cData[c_data_index].CLASSNAME and s_data_index != sData.size()-1:
			print("\n MATCH AND RESET")
			smushedTogetherData.insert(s_data_index,cData[c_data_index])
			s_data_index+=1
			c_data_index = -1
		#if the content of the first paremeter (the array of student data) matches the content of the first paremeter's classname key
		elif sData[s_data_index] == cData[c_data_index].CLASSNAME:
			smushedTogetherData.insert(s_data_index,cData[c_data_index])
			s_data_index+=1
		#if at the end of the classData and haven't found a match for the current student class, loop
		#back through from the beginning of the classData
		elif c_data_index == cData.size()-1 and sData[s_data_index]!= cData[c_data_index].CLASSNAME:
			print("\n RESETTING CLASS DATA INDEX")
			#sets to -1 bc the loop always increments it +1 outside of the if statements, and we want the index to restart at 0
			c_data_index = -1
		else:
			pass
		#increments the class data index
		c_data_index+=1
		
	#gets rid of any null elements in the new array
	_trim(smushedTogetherData)
	#print("SMS",smushedTogetherData)
	return smushedTogetherData
	
#function to sort the array of classes in order of which is earliest to which is latest
func _sort_by_time(result_array:Array):
	for n in range(0,result_array.size()):
		var parsed_string1 =0
		var parsed_string2 =0
		#out of bounds check
		if(n+1 == result_array.size()):
			break
		#if the first class' time has AM in it and the second class' time has PM, nothing needs to be done
		if("AM" in result_array[n].CLASSSTARTTIMEMONDAY and "PM" in result_array[n+1].CLASSSTARTTIMEMONDAY):
			pass
		#if the first class' time has PM in it and the second class' time has AM, obviously the second class
		#needs to be swapped with the first
		elif("PM" in result_array[n].CLASSSTARTTIMEMONDAY and "AM" in result_array[n+1].CLASSSTARTTIMEMONDAY):
			#saves the classes at n and n+1 into temp variables, which will be used to swap their positions below
			var temp = result_array[n+1]
			var temp2 = result_array[n]
			#removes the class at index n+1
			result_array.remove_at(n+1)
			#replaces it with the stored temp2 variable
			result_array.insert(n+1,temp2)
			#removes the class at index n
			result_array.remove_at(n)
			#replaces it with the stored temp variable,completing the swap
			result_array.insert(n,temp)
		#if both classes are in the afternoon, we'll have to put actual effort in to determine what to do
		elif("PM" in result_array[n].CLASSSTARTTIMEMONDAY and "PM" in result_array[n+1].CLASSSTARTTIMEMONDAY):
			#stores the class times into integers for comparison
			parsed_string1 = int(result_array[n].CLASSSTARTTIMEMONDAY)
			parsed_string2 = int(result_array[n+1].CLASSSTARTTIMEMONDAY)
			#if the first class's time is later than the second class, we'll swap their places
			if parsed_string1 > parsed_string2:
				var temp = result_array[n+1]
				var temp2 = result_array[n]
				result_array.remove_at(n+1)
				result_array.insert(n+1,temp2)
				result_array.remove_at(n)
				result_array.insert(n,temp)
		#if both classes are in the morning, we'll have to put actual effort in to determine what to do
		elif("AM" in result_array[n].CLASSSTARTTIMEMONDAY and "AM" in result_array[n+1].CLASSSTARTTIMEMONDAY):
			#stores the class times into integers for comparison
			parsed_string1 = int(result_array[n].CLASSSTARTTIMEMONDAY)
			parsed_string2 = int(result_array[n+1].CLASSSTARTTIMEMONDAY)
			#if the first class's time is later than the second class, we'll swap their places
			if parsed_string1 > parsed_string2:
				var temp = result_array[n+1]
				var temp2 = result_array[n]
				result_array.remove_at(n+1)
				result_array.insert(n+1,temp2)
				result_array.remove_at(n)
				result_array.insert(n,temp)

#trims null elements of passed array
func _trim(input_array:Array):
	#goes through the array from the end and erases null elements
	for n in range(input_array.size(),0,-1):
		input_array.erase(null)
			
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
		
#when the yes button is pressed
func _on_yes_button_pressed():
	#prevents button spam from crashing the game by constantly calling set_current_schedule
	if studentIndex == studentData.size()-1:
		pass
	else:
		increment_student_index()
		_set_Current_Schedule(studentIndex)

#when the no button is pressed
func _on_no_button_pressed():
	#prevents button spam from crashing the game by constantly calling set_current_schedule
	if studentIndex == studentData.size()-1:
		pass
	else:
		increment_student_index()
		_set_Current_Schedule(studentIndex)
