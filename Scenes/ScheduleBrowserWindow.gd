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
#class time container and labels
@onready var class_time_container = $ClassTimeContainer
@onready var _8am = $"ClassTimeContainer/8AM"
@onready var _9am = $"ClassTimeContainer/9AM"
@onready var _10am = $"ClassTimeContainer/10AM"
@onready var _11am = $"ClassTimeContainer/11AM"
@onready var _12pm = $"ClassTimeContainer/12PM"
@onready var _1pm = $"ClassTimeContainer/1PM"
@onready var _2pm = $"ClassTimeContainer/2PM"
@onready var _3pm = $"ClassTimeContainer/3PM"
@onready var _4pm = $"ClassTimeContainer/4PM"
@onready var _5pm = $"ClassTimeContainer/5PM"
#reference_rects representing the beginning of the hour for classes on the schedule
@onready var hour_line_container = $HourLineContainer
@onready var _800_line = $"800Line"
@onready var _900_line = $"HourLineContainer/900Line"
@onready var _1000_line = $"HourLineContainer/1000Line"
@onready var _1100_line = $"HourLineContainer/1100Line"
@onready var _1200_line = $"HourLineContainer/1200Line"
@onready var _1300_line = $"HourLineContainer/1300Line"
@onready var _1400_line = $"HourLineContainer/1400Line"
@onready var _1500_line = $"HourLineContainer/1500Line"
@onready var _1600_line = $"HourLineContainer/1600Line"
@onready var _1700_line = $"HourLineContainer/1700Line"
#reference rects representing the half hour mark for classes on the schedule
@onready var _830_line = $"HalfHourLineContainer/830Line"
@onready var _930_line = $"HalfHourLineContainer/930Line"
@onready var _1030_line = $"HalfHourLineContainer/1030Line"
@onready var _1130_line = $"HalfHourLineContainer/1130Line"
@onready var _1230_line = $"HalfHourLineContainer/1230Line"
@onready var _1330_line = $"HalfHourLineContainer/1330Line"
@onready var _1430_line = $"HalfHourLineContainer/1430Line"
@onready var _1530_line = $"HalfHourLineContainer/1530Line"
@onready var _1630_line = $"HalfHourLineContainer/1630Line"

#monday labels
@onready var m_label_1 = $MLabel1
@onready var m_label_2 = $MLabel2
@onready var m_label_3 = $MLabel3
@onready var m_label_4 = $MLabel4
@onready var m_label_5 = $MLabel5
#tuesday labels
@onready var t_label_1 = $TLabel1
@onready var t_label_2 = $TLabel2
@onready var t_label_3 = $TLabel3
@onready var t_label_4 = $TLabel4
@onready var t_label_5 = $TLabel5
#Wednesday labels
@onready var w_label_1 = $WLabel1
@onready var w_label_2 = $WLabel2
@onready var w_label_3 = $WLabel3
@onready var w_label_4 = $WLabel4
@onready var w_label_5 = $WLabel5
#Thursday container and labels
@onready var th_label_1 = $ThLabel1
@onready var th_label_2 = $ThLabel2
@onready var th_label_3 = $ThLabel3
@onready var th_label_4 = $ThLabel4
@onready var th_label_5 = $ThLabel5
#Friday container and label
@onready var f_label_1 = $FLabel1
@onready var f_label_2 = $FLabel2
@onready var f_label_3 = $FLabel3
@onready var f_label_4 = $FLabel4
@onready var f_label_5 = $FLabel5


var file1 ="res://UniData/StudentData.json"
var file2 = "res://UniData/ClassData.json"
#vars to hold the data from the class and student json files
var studentData
var classData 
#global var for 
var studentIndex
#creates arrays to hold the content of each group of labels 
@onready var monday_label = get_tree().get_nodes_in_group("MondayLabels")
@onready var tuesday_label = get_tree().get_nodes_in_group("TuesdayLabels")
@onready var wednesday_label = get_tree().get_nodes_in_group("WednesdayLabels")
@onready var thursday_label = get_tree().get_nodes_in_group("ThursdayLabels")
@onready var friday_label = get_tree().get_nodes_in_group("FridayLabels")

func _ready():
	_set_time_labels_positions()
	
	#index variable we will pass to set current schedule to tell it which 
	#student needs to have their schedule set
	studentIndex = 0
	
	start(studentIndex)

#calls the set current schedule function 
func start(student:int):
	_set_week_label_x_positions()
	studentData= read_json_file(file1)
	classData = read_json_file(file2)
	_set_Current_Schedule(student)
	
#sets the position of all of the time labels in the browser screen so that they can be properly referenced later
func _set_time_labels_positions():
	_8am.set_position(Vector2i(0,0))
	_9am.set_position(Vector2i(0,60))
	_10am.set_position(Vector2i(0,120))
	_11am.set_position(Vector2i(0,180))
	_12pm.set_position(Vector2i(0,240))
	_1pm.set_position(Vector2i(0,300))
	_2pm.set_position(Vector2i(0,360))
	_3pm.set_position(Vector2i(0,420))
	_4pm.set_position(Vector2i(0,480))

#sets the x position of the labels, with the x position lining up with the appropriate day column
#The x position of a label will never change again after this
func _set_week_label_x_positions():
	for label in monday_label:
		label.set_position(Vector2i(378,0))

	for label in tuesday_label:
		label.set_position(Vector2i(562,0))
		
	for label in wednesday_label:
		label.set_position(Vector2i(744,0))

	for label in thursday_label:
		label.set_position(Vector2i(923,0))
	
	for label in friday_label:
		label.set_position(Vector2i(1109,0))
	
	
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
	#array that holds the rich text labels that will actually hold the data and be displayed on screen
	var day_of_week_label_array = [monday_label,tuesday_label,wednesday_label,thursday_label,friday_label]
	#iterates from 0 to 4 and calls label_assigner with respect to day_of_week, with 0 being monday and 4 being friday
	for day_of_week in range(0,5):
		#calls label_assigner for each day of the week, with 0 being monday and 4 being tuesday
		label_assigner(day_of_week,parent_class_array,day_of_week_label_array)
	
#func that takes the day, number of labels, and the parent array from set_current_schedule
#and assigns the contents of the parent array to labels using match statements 
func label_assigner(day:int, parent_array:Array,day_of_week_group:Array):
	
	var labelText:String = ""
	var checkedResult:Array
	var path:NodePath
	var _12_hr_start_time
	var _12_hr_end_time
	#match statement that checks what day of the week it is, so we can set the correct label(monday == 0, friday == 4)

	var n = 0
	for label in parent_array[day]:
		#waits a fraction of a second because I was having issues with the first schedule not placing correctly and 
		#this seems to fix it 
		await get_tree().create_timer(.01).timeout
		
		#calls check_for_class func and stores the results in an array
		checkedResult = check_for_class(parent_array[day],classData)
		
		#calls sort_by_time, which sorts the classes in checkedResult by their start time
		_sort_by_time(checkedResult)
		#converts the 24 hr start and end times to 12 hr for placement on the text label 
		_12_hr_start_time = _24_to_12_hr_time(int(checkedResult[n].CLASSSTARTTIME)) 
		_12_hr_end_time = _24_to_12_hr_time(int(checkedResult[n].CLASSENDTIME))
		
		#setting the text that will be assigned to the label by calling 
		labelText = checkedResult[n].CLASSNAME + " \n " + checkedResult[n].CLASSLOCATION + " \n " + _12_hr_start_time + "-" + _12_hr_end_time
		path = get_path_to(day_of_week_group[day][n])

		#sets default font and font size
		get_node(path).add_theme_font_override("normal_font",load("res://Assets/Fonts/times.ttf"))
		get_node(path).add_theme_font_size_override("normal_font_size",18)
		
		#adds the text to the label, using bbcode tags to center it 
		get_node(path).append_text("[center]%s[/center]" % labelText)
		#sets the position of the label on the screen by calling label_placer and passing the checkedResult array, 
		#the index we want to be placed, and the current day of week label we want to fill with data
		label_placer(checkedResult,n,day_of_week_group[day][n])
		
		n+=1

func label_placer(array,array_index,current_label:RichTextLabel):
	var class_start_time = int(array[array_index].CLASSSTARTTIME)
	var class_end_time = int(array[array_index].CLASSENDTIME)
	var label_x_coordinate = current_label.global_position.x
	
	var start_label = which_starting_label(class_start_time)

	current_label.set_position(Vector2i(label_x_coordinate,start_label.global_position.y))
	
	if(array[array_index].CLASSDURATION == 60 || array[array_index].CLASSDURATION == 45):
		current_label.get_theme_stylebox("normal").border_width_bottom = 0
		current_label.get_theme_stylebox("normal").border_width_top = 0
	elif array[array_index].CLASSDURATION == 90:
		current_label.get_theme_stylebox("normal").border_width_bottom = 14
		current_label.get_theme_stylebox("normal").border_width_top = 14
	elif array[array_index].CLASSDURATION == 120:
		current_label.get_theme_stylebox("normal").border_width_bottom = 30
		current_label.get_theme_stylebox("normal").border_width_top = 30
		
	current_label.show()
		

#determines where on the schedue grid the current class should start
func which_starting_label(start_time:int):
	var last_two_digits
	var label:String
	var path
	if(start_time < 1000):
		last_two_digits = str(start_time).substr(1,3)
		label = str(start_time).substr(0,1) + last_two_digits + "Line"
	else:
		last_two_digits = str(start_time).substr(2,4)
		label = str(start_time).substr(0,2) + last_two_digits + "Line"
		
	match last_two_digits:
		"00":
			if start_time == 800:
				path = "/root/Main/MainContainer/ScheduleBrowserParentWindow/ScheduleBrowserWindow/800Line"
			else:
				path = "/root/Main/MainContainer/ScheduleBrowserParentWindow/ScheduleBrowserWindow/HourLineContainer/"+label
		"15":
			path = "/root/Main/MainContainer/ScheduleBrowserParentWindow/ScheduleBrowserWindow/FifteenMinContainer/"+label
		"30":
			path = "/root/Main/MainContainer/ScheduleBrowserParentWindow/ScheduleBrowserWindow/HalfHourLineContainer/"+label
		"45":
			path = "/root/Main/MainContainer/ScheduleBrowserParentWindow/ScheduleBrowserWindow/FortyFiveMinContainer/"+label
		

	var starting_label = get_node(path)
	
	#print(starting_label)
	return starting_label
	
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
	
	#clears mon labels	
	for label in monday_label:
		label.clear()
		label.size.y = 0
		label.get_theme_stylebox("normal").border_width_top = 0
		label.get_theme_stylebox("normal").border_width_bottom = 0
		label.hide()
		
	#clears tues labels	
	for label in tuesday_label:
		label.clear()
		label.get_theme_stylebox("normal").border_width_top = 0
		label.get_theme_stylebox("normal").border_width_bottom = 0
		label.size.y = 0
		label.hide()
		
	#clears wed labels		
	for label in wednesday_label:
		label.clear()
		label.get_theme_stylebox("normal").border_width_top = 0
		label.get_theme_stylebox("normal").border_width_bottom = 0
		label.size.y = 0
		label.hide()
	#clears thurs labels
	for label in thursday_label:
		label.clear()
		label.get_theme_stylebox("normal").border_width_top = 0
		label.get_theme_stylebox("normal").border_width_bottom = 0
		label.size.y = 0
		label.hide()
	#clears friday labels
	for label in friday_label:
		label.clear()
		label.get_theme_stylebox("normal").border_width_top = 0
		label.get_theme_stylebox("normal").border_width_bottom = 0
		label.size.y = 0
		label.hide()
	
#function to read json files and returns them as a dictionary
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict
	
#function that lets us compare the student data dictionary vs the class data dictionary,
#which will be used to fill the labels on the schedules
func check_for_class(sData:Array, cData:Array):
	#creates an array and sets its size to that of the passed student data array
	var matching_Data = []
	matching_Data.resize(sData.size())
	#two index trackers we will use to iterate through the loop comparing these two arrays
	var s_data_index = 0
	var c_data_index = 0
	#iterates through both arrays and compares them
	while s_data_index < sData.size() and c_data_index < cData.size():
		#if at the end of the class data index there is a match, but not all the student data has been matched yet,
		#add the matching classes to the array & reset the class data index to continue checking 
		if c_data_index == cData.size()-1 and sData[s_data_index]== cData[c_data_index].CLASSNAME and s_data_index != sData.size()-1:
			print("\n MATCH AND RESET")
			matching_Data.insert(s_data_index,cData[c_data_index])
			s_data_index+=1
			c_data_index = -1
		#if the content of the first paremeter (the array of student data) matches the content of the first paremeter's classname key
		elif sData[s_data_index] == cData[c_data_index].CLASSNAME:
			matching_Data.insert(s_data_index,cData[c_data_index])
			s_data_index+=1
		#if at the end of the classData and haven't found a match for the current student class, loop
		#back through from the beginning of the classData
		elif c_data_index == cData.size()-1 and sData[s_data_index]!= cData[c_data_index].CLASSNAME:
			#sets to -1 bc the loop always increments it +1 outside of the if statements, and we want the index to restart at 0
			c_data_index = -1
		else:
			pass
		#increments the class data index
		c_data_index+=1
		
	#gets rid of any null elements in the new array
	_trim(matching_Data)
	return matching_Data
#function that converts the 24 hr time passed into 12 hr time and returns it
func _24_to_12_hr_time(class_time)-> String:
	var _12_hr_time:String
	var _last_two_digits
	if 	class_time < 1000:
		_last_two_digits = str(class_time).substr(1,3)
		_12_hr_time = str(class_time).substr(0,1) + ":" + _last_two_digits + " AM"
	elif class_time >= 1000 and class_time <1200:
		_last_two_digits = str(class_time).substr(2,4)
		_12_hr_time = str(class_time).substr(0,2) + ":" + _last_two_digits + " AM"
	elif class_time >= 1200 and class_time <1300:
		_last_two_digits = str(class_time).substr(2,4)
		_12_hr_time = str(class_time).substr(0,2) + ":" + _last_two_digits + " PM"
	elif class_time>=1300:
		_last_two_digits = str(class_time).substr(2,4)
		class_time = class_time-1200
		_12_hr_time = str(class_time).substr(0,1) + ":" + _last_two_digits + " PM"
	
	return _12_hr_time
#function to sort the array of classes in order of which is earliest to which is latest
func _sort_by_time(result_array:Array):
	for n in range(0,result_array.size()):
		var parsed_string1 =0
		var parsed_string2 =0
		#out of bounds check
		if(n+1 == result_array.size()):
			break
			
		var _24_hr_time_current = result_array[n].CLASSSTARTTIME
		var _24_hr_time_next = result_array[n+1].CLASSSTARTTIME
		var _12_hr_current_start = _24_to_12_hr_time(int(_24_hr_time_current))
		var _12_hr_next_start = _24_to_12_hr_time(int(_24_hr_time_next))
		
		#if the first class' time has AM in it and the second class' time has PM, nothing needs to be done
		if("AM" in _12_hr_current_start and "PM" in _12_hr_next_start):
			pass
		#if the first class' time has PM in it and the second class' time has AM, obviously the second class
		#needs to be swapped with the first
		elif("PM" in _12_hr_current_start and "AM" in _12_hr_next_start):
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
		elif("PM" in _12_hr_current_start and "PM" in _12_hr_next_start):
			#stores the class times into integers for comparison
			parsed_string1 = int(result_array[n].CLASSSTARTTIME)
			parsed_string2 = int(result_array[n+1].CLASSSTARTTIME)
			#if the first class's time is later than the second class, we'll swap their places
			if parsed_string1 > parsed_string2:
				var temp = result_array[n+1]
				var temp2 = result_array[n]
				result_array.remove_at(n+1)
				result_array.insert(n+1,temp2)
				result_array.remove_at(n)
				result_array.insert(n,temp)
		#if both classes are in the morning, we'll have to put actual effort in to determine what to do
		elif("AM" in _12_hr_current_start and "AM" in _12_hr_next_start):
			#stores the class times into integers for comparison
			parsed_string1 = int(result_array[n].CLASSSTARTTIME)
			parsed_string2 = int(result_array[n+1].CLASSSTARTTIME)
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
