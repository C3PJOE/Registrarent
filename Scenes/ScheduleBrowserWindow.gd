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
#reference_rects
@onready var _800_line = $"800Line"
@onready var _830_line = $"830Line"
@onready var _930_line = $"930Line"
@onready var _1030_line = $"1030Line"
@onready var _1130_line = $"1130Line"
@onready var _1230_line = $"1230Line"
@onready var _130_line = $"130Line"
@onready var _230_line = $"230Line"
@onready var _330_line = $"330Line"
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
	_set_time_labels_positions()
	_set_week_label_x_positions("Monday")
	_set_week_label_x_positions("Tuesday")
	_set_week_label_x_positions("Wednesday")
	_set_week_label_x_positions("Thursday")
	_set_week_label_x_positions("Friday")
	_set_Current_Schedule(student)
	
#sets the position of all of the time labels in the browser screen so that they can be properly referenced later
func _set_time_labels_positions():
	_8am.set_position(Vector2i(0,0))
	_9am.set_position(Vector2i(0,64))
	_10am.set_position(Vector2i(0,128))
	_11am.set_position(Vector2i(0,192))
	_12pm.set_position(Vector2i(0,256))
	_1pm.set_position(Vector2i(0,320))
	_2pm.set_position(Vector2i(0,384))
	_3pm.set_position(Vector2i(0,448))
	_4pm.set_position(Vector2i(0,512))

#sets the x position of the labels, with the x position lining up with the appropriate day column
#The x position of a label will never change again after this
func _set_week_label_x_positions(day:String):
	var day_of_week = get_tree().get_nodes_in_group(day +"Labels")
	match day:
		"Monday":
			for label in day_of_week:
				label.position.x = 378
		"Tuesday":
			for label in day_of_week:
				label.position.x = 562
		"Wednesday":
			for label in day_of_week:
				label.position.x = 744
		"Thursday":
			for label in day_of_week:
				label.position.x = 923
		"Friday":
			for label in day_of_week:
				label.position.x = 1109
		_:
			pass
	
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
	
	#iterates from 0 to 4 and calls label_assigner with respect to day_of_week, with 0 being monday and 4 being friday
	for day_of_week in range(0,5):
		#calls label_assigner for each day of the week, with 0 being monday and 4 being tuesday
		label_assigner(day_of_week,parent_class_array[day_of_week].size(),parent_class_array)
	
	#return classData.keys()
	#return studentData.keys()
	
#func that takes the day, number of labels, and the parent array from set_current_schedule
#and assigns the contents of the parent array to labels using match statements 
func label_assigner(day:int, label_count:int, parent_array:Array):
	var checkedResult:Array
	#match statement that checks what day of the week it is, so we can set the correct label(monday == 0, friday == 4)
	match day:
		0:
			#match statement that checks the number of labels passed when the function was called,
			#which will equal the number of classes. The code pretty much does the same thing, with the 
			#only difference being how many labels are being set and assigned data 
			match label_count:
				0:
					pass
				1:
					#calls check_for_class func and stores the results in an array
					checkedResult = check_for_class(parent_array[day],classData)
					#calls sort_by_time, which sorts the classes in checkedResult by their start time
					_sort_by_time(checkedResult)
					#setting the text that will be assigned to the label by calling 
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					#calling duration_padding function and storing return value in var to use in adjusting border width
					var padding_amount:int = duration_padding(checkedResult,0)
					#shows the label 
					m_label_1.show()
					#adds the text to the label, using bbcode tags to center it 
					m_label_1.append_text("[center]%s[/center]" % labelText)
					#sets the border width on the top and bottom of the label's stylebox,
					# allowing it to more closely line up with the
					m_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					#sets the position of the label on the screen by calling label_placer(which returns vector2i) and passing the checkedResult array, 
					#the index we want to be placed, and the label's current x position, which should never change 
					m_label_1.set_position(label_placer(checkedResult,0,m_label_1.position.x))
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					m_label_1.show()
					m_label_1.append_text("[center]%s[/center]" % labelText)
					m_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_1.set_position(label_placer(checkedResult,0,m_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					m_label_2.show()
					m_label_2.append_text("[center]%s[/center]" % labelText)
					m_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_2.set_position(label_placer(checkedResult,1,m_label_2.position.x))
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					m_label_1.show()
					m_label_1.append_text("[center]%s[/center]" % labelText)
					m_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_1.set_position(label_placer(checkedResult,0,m_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					m_label_2.show()
					m_label_2.append_text("[center]%s[/center]" % labelText)
					m_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_2.set_position(label_placer(checkedResult,1,m_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					m_label_3.show()
					m_label_3.append_text("[center]%s[/center]" % labelText)
					m_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_3.set_position(label_placer(checkedResult,2,m_label_3.position.x))
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					m_label_1.show()
					m_label_1.append_text("[center]%s[/center]" % labelText)
					m_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_1.set_position(label_placer(checkedResult,0,m_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					m_label_2.show()
					m_label_2.append_text("[center]%s[/center]" % labelText)
					m_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_2.set_position(label_placer(checkedResult,1,m_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					m_label_3.show()
					m_label_3.append_text("[center]%s[/center]" % labelText)
					m_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_3.set_position(label_placer(checkedResult,2,m_label_3.position.x))
					
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION + "\n" + checkedResult[3].CLASSSTARTTIME + "-" + checkedResult[3].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,3)
					
					m_label_4.show()
					m_label_4.append_text("[center]%s[/center]" % labelText)
					m_label_4.get_theme_stylebox("normal").border_width_top = padding_amount
					m_label_4.get_theme_stylebox("normal").border_width_bottom = padding_amount
					m_label_4.set_position(label_placer(checkedResult,3,m_label_4.position.x))
				_:
					print("labelCount invalid")
		1:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					t_label_1.show()
					t_label_1.append_text("[center]%s[/center]" % labelText)
					t_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_1.set_position(label_placer(checkedResult,0,t_label_1.position.x))
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					t_label_1.show()
					t_label_1.append_text("[center]%s[/center]" % labelText)
					t_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_1.set_position(label_placer(checkedResult,0,t_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					t_label_2.show()
					t_label_2.append_text("[center]%s[/center]" % labelText)
					t_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_2.set_position(label_placer(checkedResult,1,t_label_2.position.x))
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					t_label_1.show()
					t_label_1.append_text("[center]%s[/center]" % labelText)
					t_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_1.set_position(label_placer(checkedResult,0,t_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					t_label_2.show()
					t_label_2.append_text("[center]%s[/center]" % labelText)
					t_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_2.set_position(label_placer(checkedResult,1,t_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					t_label_3.show()
					t_label_3.append_text("[center]%s[/center]" % labelText)
					t_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_3.set_position(label_placer(checkedResult,2,t_label_3.position.x))
					
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					t_label_1.show()
					t_label_1.append_text("[center]%s[/center]" % labelText)
					t_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_1.set_position(label_placer(checkedResult,0,t_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					t_label_2.show()
					t_label_2.append_text("[center]%s[/center]" % labelText)
					t_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_2.set_position(label_placer(checkedResult,1,t_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					t_label_3.show()
					t_label_3.append_text("[center]%s[/center]" % labelText)
					t_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_3.set_position(label_placer(checkedResult,2,t_label_3.position.x))
					
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION + "\n" + checkedResult[3].CLASSSTARTTIME + "-" + checkedResult[3].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,3)
					
					t_label_4.show()
					t_label_4.append_text("[center]%s[/center]" % labelText)
					t_label_4.get_theme_stylebox("normal").border_width_top = padding_amount
					t_label_4.get_theme_stylebox("normal").border_width_bottom = padding_amount
					t_label_4.set_position(label_placer(checkedResult,3,t_label_4.position.x))
				_:
					print("labelCount invalid")
		2:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					w_label_1.show()
					w_label_1.append_text("[center]%s[/center]" % labelText)
					w_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_1.set_position(label_placer(checkedResult,0,w_label_1.position.x))
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					w_label_1.show()
					w_label_1.append_text("[center]%s[/center]" % labelText)
					w_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_1.set_position(label_placer(checkedResult,0,w_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					w_label_2.show()
					w_label_2.append_text("[center]%s[/center]" % labelText)
					w_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_2.set_position(label_placer(checkedResult,1,w_label_2.position.x))
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					w_label_1.show()
					w_label_1.append_text("[center]%s[/center]" % labelText)
					w_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_1.set_position(label_placer(checkedResult,0,w_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					w_label_2.show()
					w_label_2.append_text("[center]%s[/center]" % labelText)
					w_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_2.set_position(label_placer(checkedResult,1,w_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					w_label_3.show()
					w_label_3.append_text("[center]%s[/center]" % labelText)
					w_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_3.set_position(label_placer(checkedResult,2,w_label_3.position.x))
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					w_label_1.show()
					w_label_1.append_text("[center]%s[/center]" % labelText)
					w_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_1.set_position(label_placer(checkedResult,0,w_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					w_label_2.show()
					w_label_2.append_text("[center]%s[/center]" % labelText)
					w_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_2.set_position(label_placer(checkedResult,1,w_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					w_label_3.show()
					w_label_3.append_text("[center]%s[/center]" % labelText)
					w_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_3.set_position(label_placer(checkedResult,2,w_label_3.position.x))
					
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION + "\n" + checkedResult[3].CLASSSTARTTIME + "-" + checkedResult[3].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,3)
					
					w_label_4.show()
					w_label_4.append_text("[center]%s[/center]" % labelText)
					w_label_4.get_theme_stylebox("normal").border_width_top = padding_amount
					w_label_4.get_theme_stylebox("normal").border_width_bottom = padding_amount
					w_label_4.set_position(label_placer(checkedResult,3,w_label_4.position.x))
				_:
					print("labelCount invalid")
		3:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					th_label_1.show()
					th_label_1.append_text("[center]%s[/center]" % labelText)
					th_label_1.set_position(label_placer(checkedResult,0,th_label_1.position.x))
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					th_label_1.show()
					th_label_1.append_text("[center]%s[/center]" % labelText)
					th_label_1.set_position(label_placer(checkedResult,0,th_label_1.position.x))
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					th_label_2.show()
					th_label_2.append_text("[center]%s[/center]" % labelText)
					th_label_2.set_position(label_placer(checkedResult,1,th_label_2.position.x))
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					th_label_1.show()
					th_label_1.append_text("[center]%s[/center]" % labelText)
					th_label_1.set_position(label_placer(checkedResult,0,th_label_1.position.x))
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					th_label_2.show()
					th_label_2.append_text("[center]%s[/center]" % labelText)
					th_label_2.set_position(label_placer(checkedResult,1,th_label_2.position.x))
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					th_label_3.show()
					th_label_3.append_text("[center]%s[/center]" % labelText)
					th_label_3.set_position(label_placer(checkedResult,2,th_label_3.position.x))
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					th_label_1.show()
					th_label_1.append_text("[center]%s[/center]" % labelText)
					th_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					th_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					th_label_1.set_position(label_placer(checkedResult,0,th_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					th_label_2.show()
					th_label_2.append_text("[center]%s[/center]" % labelText)
					th_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					th_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					th_label_2.set_position(label_placer(checkedResult,1,th_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					th_label_3.show()
					th_label_3.append_text("[center]%s[/center]" % labelText)
					th_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					th_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					th_label_3.set_position(label_placer(checkedResult,2,th_label_3.position.x))
					
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION + "\n" + checkedResult[3].CLASSSTARTTIME + "-" + checkedResult[3].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,3)
					
					th_label_4.show()
					th_label_4.append_text("[center]%s[/center]" % labelText)
					th_label_4.get_theme_stylebox("normal").border_width_top = padding_amount
					th_label_4.get_theme_stylebox("normal").border_width_bottom = padding_amount
					th_label_4.set_position(label_placer(checkedResult,3,th_label_4.position.x))
				_:
					print("labelCount invalid")
		4:
			match label_count:
				0:
					pass
				1:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					f_label_1.show()
					f_label_1.append_text("[center]%s[/center]" % labelText)
					f_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_1.set_position(label_placer(checkedResult,0,f_label_1.position.x))
				2:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					f_label_1.show()
					f_label_1.append_text("[center]%s[/center]" % labelText)
					f_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_1.set_position(label_placer(checkedResult,0,f_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					f_label_2.show()
					f_label_2.append_text("[center]%s[/center]" % labelText)
					f_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_2.set_position(label_placer(checkedResult,1,f_label_2.position.x))
				3:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					f_label_1.show()
					f_label_1.append_text("[center]%s[/center]" % labelText)
					f_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_1.set_position(label_placer(checkedResult,0,f_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					f_label_2.show()
					f_label_2.append_text("[center]%s[/center]" % labelText)
					f_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_2.set_position(label_placer(checkedResult,1,f_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					f_label_3.show()
					f_label_3.append_text("[center]%s[/center]" % labelText)
					f_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_3.set_position(label_placer(checkedResult,2,f_label_3.position.x))
				4:
					checkedResult = check_for_class(parent_array[day],classData)
					_sort_by_time(checkedResult)
					var labelText:String = checkedResult[0].CLASSNAME + "\n" + checkedResult[0].CLASSLOCATION + "\n" + checkedResult[0].CLASSSTARTTIME + "-" + checkedResult[0].CLASSENDTIME
					var padding_amount:int = duration_padding(checkedResult,0)
					
					f_label_1.show()
					f_label_1.append_text("[center]%s[/center]" % labelText)
					f_label_1.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_1.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_1.set_position(label_placer(checkedResult,0,f_label_1.position.x))
					
					labelText = checkedResult[1].CLASSNAME + "\n" + checkedResult[1].CLASSLOCATION + "\n" + checkedResult[1].CLASSSTARTTIME + "-" + checkedResult[1].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,1)
					
					f_label_2.show()
					f_label_2.append_text("[center]%s[/center]" % labelText)
					f_label_2.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_2.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_2.set_position(label_placer(checkedResult,1,f_label_2.position.x))
					
					labelText = checkedResult[2].CLASSNAME + "\n" + checkedResult[2].CLASSLOCATION + "\n" + checkedResult[2].CLASSSTARTTIME + "-" + checkedResult[2].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,2)
					
					f_label_3.show()
					f_label_3.append_text("[center]%s[/center]" % labelText)
					f_label_3.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_3.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_3.set_position(label_placer(checkedResult,2,f_label_3.position.x))
					
					labelText = checkedResult[3].CLASSNAME + "\n" + checkedResult[3].CLASSLOCATION + "\n" + checkedResult[3].CLASSSTARTTIME + "-" + checkedResult[3].CLASSENDTIME
					padding_amount = duration_padding(checkedResult,3)
					
					f_label_4.show()
					f_label_4.append_text("[center]%s[/center]" % labelText)
					f_label_4.get_theme_stylebox("normal").border_width_top = padding_amount
					f_label_4.get_theme_stylebox("normal").border_width_bottom = padding_amount
					f_label_4.set_position(label_placer(checkedResult,3,f_label_4.position.x))
				_:
					print("labelCount invalid")

#returns an integer(number of pixels to pad the label) based on how long the class is
func duration_padding(array:Array,array_index:int)-> int:
	var duration:int = array[array_index].CLASSDURATION
	match duration:
		90:
			return 11
		120:
			return 30
		60:
			return 0
		45:
			return 0
		_:
			return 0
	print(array[array_index].CLASSDURATION)
#function that matches the class start times of the passed array & returns the correct starting time's y position,
#so that class can be properly aligned on the screen 
func label_placer(array:Array,array_index:int,label_x_coordinate)->Vector2i:
	match array[array_index].CLASSSTARTTIME:
		"8:00 AM":
			return Vector2i(label_x_coordinate,_800_line.position.y)
		"8:15 AM":
			#offsets the y coordinate by +10 px of the _8am label y position so that it more closely aligns with 8:15
			return Vector2i(label_x_coordinate,_800_line.position.y+10)
		"8:30 AM":
			return Vector2i(label_x_coordinate,_8am.global_position.y+10)
		"8:45 AM":
			#offsets the y coordinate by +30 px of the _8am label y position so that it more closely aligns with 8:45
			return Vector2i(label_x_coordinate,_8am.global_position.y+30)
		"9:00 AM":
			return Vector2i(label_x_coordinate,_830_line.position.y)
		"9:15 AM":
			return Vector2i(label_x_coordinate,_830_line.position.y+10)
		"9:30 AM":
			return Vector2i(label_x_coordinate,_9am.global_position.y+10)
		"9:45 AM":
			return Vector2i(label_x_coordinate,_9am.global_position.y+30)
		"10:00 AM":
			return Vector2i(label_x_coordinate,_930_line.position.y-2)
		"10:30 AM":
			return Vector2i(label_x_coordinate,_10am.global_position.y+10)
		"10:45 AM":
			return Vector2i(label_x_coordinate,_10am.global_position.y+30)
		"11:00 AM":
			return Vector2i(label_x_coordinate,_1030_line.position.y)
		"11:15 AM":
			return Vector2i(label_x_coordinate,_1030_line.position.y+10)
		"11:30 AM":
			return Vector2i(label_x_coordinate,_11am.global_position.y+10)
		"11:45 AM":
			return Vector2i(label_x_coordinate,_11am.global_position.y+30)
		"12:00 PM":
			return Vector2i(label_x_coordinate,_1130_line.position.y)
		"12:15 PM":
			return Vector2i(label_x_coordinate,_1130_line.position.y+10)
		"12:30 PM":
			return Vector2i(label_x_coordinate,_12pm.global_position.y+10)
		"12:45 PM":
			return Vector2i(label_x_coordinate,_12pm.global_position.y+30)
		"1:00 PM":
			return Vector2i(label_x_coordinate,_1230_line.position.y)
		"1:15 PM":
			return Vector2i(label_x_coordinate,_1230_line.position.y+10)
		"1:30 PM":
			return Vector2i(label_x_coordinate,_1pm.global_position.y+10)
		"1:45 PM":
			return Vector2i(label_x_coordinate,_1pm.global_position.y+20)
		"2:00 PM":
			return Vector2i(label_x_coordinate,_130_line.position.y)
		"2:15 PM":
			return Vector2i(label_x_coordinate,_130_line.position.y+10)
		"2:30 PM":
			return Vector2i(label_x_coordinate,_2pm.global_position.y+10)
		"2:45 PM":
			return Vector2i(label_x_coordinate,_2pm.global_position.y+20)
		"3:00 PM":
			return Vector2i(label_x_coordinate,_230_line.position.y)
		"3:15 PM":
			return Vector2i(label_x_coordinate,_230_line.position.y+10)
		"3:30 PM":
			return Vector2i(label_x_coordinate,_3pm.global_position.y+10)
		"3:45 PM":
			return Vector2i(label_x_coordinate,_3pm.global_position.y+20)
		"4:00 PM":
			return Vector2i(label_x_coordinate,_330_line.position.y)
		_:
			return Vector2i(0,0)
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
	m_label_1.get_theme_stylebox("normal").border_width_top = 0
	m_label_1.get_theme_stylebox("normal").border_width_bottom = 0
	m_label_1.hide()
	m_label_2.clear()
	m_label_2.get_theme_stylebox("normal").border_width_top = 0
	m_label_2.get_theme_stylebox("normal").border_width_bottom = 0
	m_label_2.hide()
	m_label_3.clear()
	m_label_3.get_theme_stylebox("normal").border_width_top = 0
	m_label_3.get_theme_stylebox("normal").border_width_bottom = 0
	m_label_3.hide()
	m_label_4.clear()
	m_label_4.get_theme_stylebox("normal").border_width_top = 0
	m_label_4.get_theme_stylebox("normal").border_width_bottom = 0
	m_label_4.hide()
	#clears tuesday labels
	t_label_1.clear()
	t_label_1.get_theme_stylebox("normal").border_width_top = 0
	t_label_1.get_theme_stylebox("normal").border_width_bottom = 0
	t_label_1.hide()
	t_label_2.clear()
	t_label_2.get_theme_stylebox("normal").border_width_top = 0
	t_label_2.get_theme_stylebox("normal").border_width_bottom = 0
	t_label_2.hide()
	t_label_3.clear()
	t_label_3.get_theme_stylebox("normal").border_width_top = 0
	t_label_3.get_theme_stylebox("normal").border_width_bottom = 0
	t_label_3.hide()
	t_label_4.clear()
	t_label_4.get_theme_stylebox("normal").border_width_top = 0
	t_label_4.get_theme_stylebox("normal").border_width_bottom = 0
	t_label_4.hide()
	#clears wednesday labels
	w_label_1.clear()
	w_label_1.get_theme_stylebox("normal").border_width_top = 0
	w_label_1.get_theme_stylebox("normal").border_width_bottom = 0
	w_label_1.hide()
	w_label_2.clear()
	w_label_2.get_theme_stylebox("normal").border_width_top = 0
	w_label_2.get_theme_stylebox("normal").border_width_bottom = 0
	w_label_2.hide()
	w_label_3.clear()
	w_label_3.get_theme_stylebox("normal").border_width_top = 0
	w_label_3.get_theme_stylebox("normal").border_width_bottom = 0
	w_label_3.hide()
	w_label_4.clear()
	w_label_4.get_theme_stylebox("normal").border_width_top = 0
	w_label_4.get_theme_stylebox("normal").border_width_bottom = 0
	w_label_4.hide()
	#clears thursday labels
	th_label_1.clear()
	th_label_1.get_theme_stylebox("normal").border_width_top = 0
	th_label_1.get_theme_stylebox("normal").border_width_bottom = 0
	th_label_1.hide()
	th_label_2.clear()
	th_label_2.get_theme_stylebox("normal").border_width_top = 0
	th_label_2.get_theme_stylebox("normal").border_width_bottom = 0
	th_label_2.hide()
	th_label_3.clear()
	th_label_3.get_theme_stylebox("normal").border_width_top = 0
	th_label_3.get_theme_stylebox("normal").border_width_bottom = 0
	th_label_3.hide()
	th_label_4.clear()
	th_label_4.get_theme_stylebox("normal").border_width_top = 0
	th_label_4.get_theme_stylebox("normal").border_width_bottom = 0
	th_label_4.hide()
	#clears friday labels
	f_label_1.clear()
	f_label_1.get_theme_stylebox("normal").border_width_top = 0
	f_label_1.get_theme_stylebox("normal").border_width_bottom = 0
	f_label_1.hide()
	f_label_2.clear()
	f_label_2.get_theme_stylebox("normal").border_width_top = 0
	f_label_2.get_theme_stylebox("normal").border_width_bottom = 0
	f_label_2.hide()
	f_label_3.clear()
	f_label_3.get_theme_stylebox("normal").border_width_top = 0
	f_label_3.get_theme_stylebox("normal").border_width_bottom = 0
	f_label_3.hide()
	f_label_4.clear()
	f_label_4.get_theme_stylebox("normal").border_width_top = 0
	f_label_4.get_theme_stylebox("normal").border_width_bottom = 0
	f_label_4.hide()
	
#function to read json files and returns them as a dictionary
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict
	
#function that lets us compare the student data dictionary vs the class data dictionary,
#which will be used to fill the labels on the schedules
func check_for_class(sData:Array, cData :Array):
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
			print("\n RESETTING CLASS DATA INDEX")
			#sets to -1 bc the loop always increments it +1 outside of the if statements, and we want the index to restart at 0
			c_data_index = -1
		else:
			pass
		#increments the class data index
		c_data_index+=1
		
	#gets rid of any null elements in the new array
	_trim(matching_Data)
	return matching_Data
	
#function to sort the array of classes in order of which is earliest to which is latest
func _sort_by_time(result_array:Array):
	for n in range(0,result_array.size()):
		var parsed_string1 =0
		var parsed_string2 =0
		#out of bounds check
		if(n+1 == result_array.size()):
			break
		#if the first class' time has AM in it and the second class' time has PM, nothing needs to be done
		if("AM" in result_array[n].CLASSSTARTTIME and "PM" in result_array[n+1].CLASSSTARTTIME):
			pass
		#if the first class' time has PM in it and the second class' time has AM, obviously the second class
		#needs to be swapped with the first
		elif("PM" in result_array[n].CLASSSTARTTIME and "AM" in result_array[n+1].CLASSSTARTTIME):
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
		elif("PM" in result_array[n].CLASSSTARTTIME and "PM" in result_array[n+1].CLASSSTARTTIME):
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
		elif("AM" in result_array[n].CLASSSTARTTIME and "AM" in result_array[n+1].CLASSSTARTTIME):
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
