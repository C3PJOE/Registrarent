extends Window
signal esc_pressed 
@onready var pause_menu = $"../../PauseMenu"

@onready var end_game_parent_window = $"../../../EndGameParentWindow"
@onready var end_game_window = $"../../../EndGameParentWindow/EndGameWindow"
@onready var valid_schedules_number = $"../../../EndGameParentWindow/EndGameWindow/NumberContainer/ValidSchedulesNumber"
@onready var approved_schedules_number = $"../../../EndGameParentWindow/EndGameWindow/NumberContainer/ApprovedSchedulesNumber"
@onready var invalid_schedules_number = $"../../../EndGameParentWindow/EndGameWindow/NumberContainer/InvalidSchedules Number"
@onready var rejected_schedules_number = $"../../../EndGameParentWindow/EndGameWindow/NumberContainer/RejectedSchedulesNumber"
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
#@onready var _5pm = $"ClassTimeContainer/5PM"

#container holding the hour reference rects 
@onready var hour_line_container = $HourLineContainer

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
#var for progress bar
@onready var progress_bar = $ProgressBar
#var for progress_bar_label
@onready var progress_label = $ProgressBar/ProgressLabel


var file1 ="res://UniData/StudentData.json"
var file2 = "res://UniData/ClassData.json"
var student_names_file = "res://UniData/StudentNames.json"
#vars to hold the data from the class and student json files
var student_names
var studentData
var classData 
#global var for 
var studentIndex 
#values that will be used for scorekeeping
var valid_schedules:int = 0
var invalid_schedules:int = 0
var player_approvals:int = 0
var player_denials:int = 0
var rng = RandomNumberGenerator.new()
#creates arrays to hold the content of each group of labels 
@onready var monday_label = get_tree().get_nodes_in_group("MondayLabels")
@onready var tuesday_label = get_tree().get_nodes_in_group("TuesdayLabels")
@onready var wednesday_label = get_tree().get_nodes_in_group("WednesdayLabels")
@onready var thursday_label = get_tree().get_nodes_in_group("ThursdayLabels")
@onready var friday_label = get_tree().get_nodes_in_group("FridayLabels")
@onready var main_container = $"../.."

func _ready():
	#index variable we will pass to set current schedule to tell it which 
	#student needs to have their schedule set
	studentIndex = 0
	start()

#calls the set current schedule function 
func start():
	_set_time_labels_positions()
	_set_week_label_x_positions()
	student_names = read_json_file(student_names_file)
	studentData= read_json_file(file1)
	progress_bar_update()
	classData = read_json_file(file2)
	proc_gen()
	initial_schedule_setup()

func proc_gen():
	profile_maker()
#helper function for proc_gen that picks a random name from the list of student names,
#as well as generates a random profile for the student (year,account status, financial aid status,major,minor)
func profile_maker():
	var random_name_index 
	var random_major
	var random_minor
	var random_year
	var random_FA
	var random_AS
	for student in studentData:
		random_major = rng.randi_range(0,5)
		random_minor = rng.randi_range(0,5)
		random_year = rng.randi_range(0,3)
		random_FA = rng.randi_range(0,100)
		random_AS = rng.randi_range(0,100)
		random_name_index = rng.randi_range(0,student_names.size()-1)
		student["NAME"] = student_names[random_name_index].NAME
		interpret_random(student,random_major,random_minor,random_year,random_FA,random_AS)
		schedule_maker(student)
#helper for profile_maker that matches random numbers generated to relevant student data,
#then fills it into student data
func interpret_random(student,s_major,s_minor,s_year,s_fin_aid,s_acc_stat):
	var parsed_major:String
	var parsed_minor:String
	var parsed_year:String
	var parsed_fin_aid:String
	var parsed_acc_stat:String
	match s_major:
		0:
			parsed_major = "ART"
		1:
			parsed_major = "COMPUTER SCIENCE"
		2:
			parsed_major = "ENGLISH"
		3:
			parsed_major = "HISTORY"
		4:
			parsed_major = "HUMANITIES"
		5:
			parsed_major = "MATH"
	#prevents major from being the same as minor
	while s_major == s_minor:
		s_minor = rng.randi_range(0,5)
	match s_minor:
		0:
			parsed_minor = "ART"
		1:
			parsed_minor = "COMPUTER SCIENCE"
		2:
			parsed_minor = "ENGLISH"
		3:
			parsed_minor = "HISTORY"
		4:
			parsed_minor = "HUMANITIES"
		5:
			parsed_minor = "MATH"
	match s_year:
		0:
			parsed_year = "FRESHMAN"
		1:
			parsed_year = "SOPHOMORE"
		2:
			parsed_year = "JUNIOR"
		3:
			parsed_year = "SENIOR"
			
	if s_fin_aid <=50:
		parsed_fin_aid = "YES"
	else:
		parsed_fin_aid = "NO"
		
	if s_acc_stat <=85:
		parsed_acc_stat = "GOOD"
	else:
		parsed_acc_stat = "DELINQUENT"
		
	student["MAJOR"] = parsed_major
	student["MINOR"] = parsed_minor
	student["YEAR"] = parsed_year
	student["FINANCIAL AID"] = parsed_fin_aid
	student["ACCOUNT STATUS"] = parsed_acc_stat

func filter_out_study_areas(st_major,st_minor,st_year):
	var filtered_array:Array = []
	#creates a regex var that will be used for class number comparison later
	var regex = RegEx.new()
	#sets the pattern to match letters and whitespaces
	regex.compile("^[A-Za-z]\\S+\\s+")
	var lesson_name:String
	var lesson_numbers_only
	if st_year != "FRESHMAN" and st_year!= "SENIOR":
		for lesson in classData:
			if lesson.CLASSDEPARTMENT != st_major and lesson.CLASSDEPARTMENT != st_minor:
				filtered_array.append(lesson)
				
	elif st_year == "FRESHMAN":
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT != st_major and lesson.CLASSDEPARTMENT != st_minor and (!(lesson_numbers_only.begins_with("4"))):
				filtered_array.append(lesson)
				
	elif st_year == "SENIOR":
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT != st_major and lesson.CLASSDEPARTMENT != st_minor and (!(lesson_numbers_only.begins_with("1"))):
				filtered_array.append(lesson)
				
	return filtered_array
#function to find and reesolve potential schedule time conflicts
func start_end_conflict_finder(array:Array,student,major_array:Array,minor_array:Array,classes_to_exclude:Array):
	var s_major = student.MAJOR
	var s_minor = student.MINOR
	var s_year = student.YEAR
	var irrelevant_courses = filter_out_study_areas(s_major,s_minor,s_year)
	var time_pair:Array = []
	time_pair.resize(array.size())
	var conflict_array:Array = []
	var replacement_seed = 0
	var n = 0
	#pairs the start and end times of each item in the passed array for easier comparison later(instead
	#of having to reference .CLASSSTARTTIME and .CLASSENDTIME, we can access within a 2d array
	for item in array:
		time_pair[n]=[int(item.CLASSSTARTTIME),int(item.CLASSENDTIME)]
		n+=1
	#iterates through the array of time pairs
	for i in range(0,time_pair.size()):
		for j in range(i+1,time_pair.size()):
			#if the start time of the next class is <= the end time of the current class
			#and the start time of the current class <= the end time of the next class,
			#there's a conflict (time is still 24 hr based at this point, comparison is easier that way)
			if time_pair[j][0] <= time_pair[i][1] and time_pair[i][0] <= time_pair[j][1]:
				#we append the current index to the conflict array. Because time pair is the same size as the originally
				#passed array, we can use these indeces later to directly access the problem children
				conflict_array.append(i)
	#while there are still items causing time conflicts
	while conflict_array.size()>=1:
		#going through the indeces we stored in the conflcit array
		for index in conflict_array:
			#if a class in the student's major has a time conflict,we search 
			#for another class in their majr to replace it with
			if array[index].CLASSDEPARTMENT == s_major:
				replacement_seed = rng.randi_range(0,major_array.size()-1)
				#var to track how many times generation of a new seed was attempted
				var reroll_count = 0
				#while the random seed produced a class that isn't valid
				while classes_to_exclude.has(major_array[replacement_seed].CLASSNAME):
					#if a reroll is attempted 16 times or more(16 classes in each department at the moment,
					#so if it gets to 16, there is no valid class to replace the conflicting one with)
					if reroll_count >=16:
						#we remove the conflciting class from the schedule entirely, 
						#and break out of the while loop
						array.remove_at(index)
						break
					#otherwise...
					else:
						replacement_seed = rng.randi_range(0,major_array.size()-1)
					reroll_count+=1
				#replaces the current array element with a new class that (hopefully) doesn't conflict
				array[index] = major_array[replacement_seed]
				#adds the newly appended class to teh exclusion list, so it can't be double added to the array
				classes_to_exclude.append(major_array[replacement_seed].CLASSNAME)
			#if a class in the student's minor has a time conflict, we search 
			#for another class in their minor to replace it with 
			elif array[index].CLASSDEPARTMENT == s_minor:
				replacement_seed = rng.randi_range(0,minor_array.size()-1)
				var reroll_count = 0
				while classes_to_exclude.has(minor_array[replacement_seed].CLASSNAME):
					if reroll_count >=16:
						array.remove_at(index)
						break
					else:
						replacement_seed = rng.randi_range(0,minor_array.size()-1)
					reroll_count+=1
				array[index] = minor_array[replacement_seed]
				classes_to_exclude.append(minor_array[replacement_seed].CLASSNAME)
			#if the conflicting class is neither part of the studen'ts major or minor
			#we do the same as above, except we pull from a pool of non major/minor classes
			else:
				replacement_seed = rng.randi_range(0,irrelevant_courses.size()-1)
				var reroll_count = 0
				while(classes_to_exclude.has(irrelevant_courses[replacement_seed].CLASSNAME)):
					if reroll_count >=16:
						array.remove_at(index)
						break
					else:
						replacement_seed = rng.randi_range(0,irrelevant_courses.size()-1)
					reroll_count +=1
				array[index] = irrelevant_courses[replacement_seed]
				classes_to_exclude.append(irrelevant_courses[replacement_seed].CLASSNAME)
		#clear the conflict array once the for loop terminates
		conflict_array.clear()
		#calls conflict finder again until the conflict array has no conflicts
		start_end_conflict_finder(array,student,major_array,minor_array,classes_to_exclude)
	
#iterates through the array of classes and appends a class to a new array if the class matches the student's major
#takes an optional param that, if == 1, will allow every class in the studen'ts major into the array,
#even if the class does not suit the student's grade level
func make_major_array(student,allow_invalid_classes:int = 0):
	var major_array:Array = []
	var regex = RegEx.new()
	var lesson_name:String
	var lesson_numbers_only
	#sets the pattern to match letters and whitespaces
	regex.compile("^[A-Za-z]\\S+\\s+")
	
	if (student.YEAR != "FRESHMAN" and student.YEAR != "SENIOR") || allow_invalid_classes == 1:
		for lesson in classData:
			if lesson.CLASSDEPARTMENT == student.MAJOR:
				major_array.append(lesson)
				
	elif student.YEAR == "FRESHMAN":
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT == student.MAJOR and (!(lesson_numbers_only.begins_with("4"))):
				major_array.append(lesson)
	else:
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT == student.MAJOR and (!(lesson_numbers_only.begins_with("1"))):
				major_array.append(lesson)
				
	return major_array
	
#iterates through the array of classes and appends a class to a new array if the class matches the student's major
#takes an optional param that, if == 1, will allow every class in the studen'ts minor into the array,
#even if the class does not suit the student's grade level
func make_minor_array(student,allow_invalid_classes:int = 0):
	var minor_array:Array = []
	#creates a regex var that will be used for class number comparison later
	var regex = RegEx.new()
	#sets the pattern to match letters and whitespaces
	regex.compile("^[A-Za-z]\\S+\\s+")
	var lesson_name:String
	var lesson_numbers_only
	if (student.YEAR != "FRESHMAN" and student.YEAR != "SENIOR") || allow_invalid_classes == 1:
		for lesson in classData:
			if lesson.CLASSDEPARTMENT == student.MINOR:
				minor_array.append(lesson)
	
	elif student.YEAR == "FRESHMAN":
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT == student.MINOR and (!(lesson_numbers_only.begins_with("4"))):
				minor_array.append(lesson)
	else:
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if lesson.CLASSDEPARTMENT == student.MINOR and (!(lesson_numbers_only.begins_with("1"))):
				minor_array.append(lesson)
	
	return minor_array
#function that filters 100 level classes out of the senior class pool 
#and 400 level classes out of the freshmen class pool
func filter_out_class_level(student):
	var filtered_array:Array = []
	var regex = RegEx.new()
	#sets the pattern to match letters and whitespaces
	regex.compile("^[A-Za-z]\\S+\\s+")
	var lesson_name:String
	var lesson_numbers_only
	if student.YEAR != "FRESHMAN" and student.YEAR != "SENIOR":
		return classData
	elif student.YEAR == "FRESHMAN":
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if (!(lesson_numbers_only.begins_with("4"))):
				filtered_array.append(lesson)
	else:
		for lesson in classData:
			lesson_name = lesson.CLASSNAME
			#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
			lesson_numbers_only = regex.sub(lesson_name,"")  
			if (!(lesson_numbers_only.begins_with("1"))):
				filtered_array.append(lesson)
				
	return filtered_array
#function that makes and enters the schedule data into the dictionary for the student
func schedule_maker(student):
	var major_class_array = make_major_array(student)
	var minor_class_array = make_minor_array(student)
	#var that will hold every class that the student is eligible for (i.e no 100 levels for seniors and no 400s for freshmen)
	var every_valid_class_array:Array
	var seed_1:int
	var seed_2:int
	var seed_3:int
	var seed_4:int
	var seed_5:int
	var class_1
	var class_2
	var class_3
	var class_4
	var class_5
	var used_classes_list:Array = []
	var all_classes = []
	var mon_wed_fri_classes:Array = []
	var tu_thurs_classes:Array = []
	every_valid_class_array = filter_out_class_level(student)
	seed_1 =rng.randi_range(0,every_valid_class_array.size()-1)
	seed_2 =rng.randi_range(0,every_valid_class_array.size()-1)
	seed_3 =rng.randi_range(0,every_valid_class_array.size()-1)
	seed_4 =rng.randi_range(0,every_valid_class_array.size()-1)
	seed_5 =rng.randi_range(0,every_valid_class_array.size()-1)
	class_1 = every_valid_class_array[seed_1]
	class_2 = every_valid_class_array[seed_2]
	class_3 = every_valid_class_array[seed_3]
	class_4 = every_valid_class_array[seed_4]
	class_5 = every_valid_class_array[seed_5]
	#generates new seeds until none of them are duplicates, this will ensure unique classes
	while seed_1 == seed_2 || seed_1 == seed_3 || seed_1 == seed_4 || seed_1 == seed_5 || seed_2 == seed_3 || seed_2 == seed_4 || seed_2 == seed_5|| seed_3 == seed_4 || seed_3 == seed_5 || seed_4 == seed_5:
		seed_1 =rng.randi_range(0,every_valid_class_array.size()-1)
		seed_2 =rng.randi_range(0,every_valid_class_array.size()-1)
		seed_3 =rng.randi_range(0,every_valid_class_array.size()-1)
		seed_4 =rng.randi_range(0,every_valid_class_array.size()-1)
		seed_5 =rng.randi_range(0,every_valid_class_array.size()-1)
		class_1 = every_valid_class_array[seed_1]
		class_2 = every_valid_class_array[seed_2]
		class_3 = every_valid_class_array[seed_3]
		class_4 = every_valid_class_array[seed_4]
		class_5 = every_valid_class_array[seed_5]
	
	mon_wed_fri_classes = [class_1,class_2,class_3]
	tu_thurs_classes = [class_4,class_5]
	
	used_classes_list = [mon_wed_fri_classes[0].CLASSNAME,mon_wed_fri_classes[1].CLASSNAME,mon_wed_fri_classes[2].CLASSNAME,tu_thurs_classes[0].CLASSNAME,tu_thurs_classes[1].CLASSNAME]
	used_classes_list.append(tu_thurs_classes[0].CLASSNAME)
	used_classes_list.append(tu_thurs_classes[1].CLASSNAME)
	
	
	all_classes.append_array(mon_wed_fri_classes)
	all_classes.append_array(tu_thurs_classes)
	var major_count = major_class_count(student.MAJOR,all_classes)
	var minor_count = minor_class_count(student.MINOR,all_classes)
	#list that stores all of the classes that have been previously placed into the schedule.This 
	#will prevent the classes from being reused 
	
	var replacement_seed = 0
	while major_count != 3 || (minor_count <1 || minor_count >2):
		for n in range(0,all_classes.size()):
			if ((all_classes[n].CLASSDEPARTMENT == student.MAJOR) and (major_count > 3)):
				replacement_seed = rng.randi_range(0,minor_class_array.size()-1)
				while used_classes_list.has(minor_class_array[replacement_seed].CLASSNAME):
					replacement_seed = rng.randi_range(0,minor_class_array.size()-1)
					
				all_classes[n] = minor_class_array[replacement_seed]
				used_classes_list.append(all_classes[n].CLASSNAME)
				minor_count+=1
				major_count = major_count -1
			elif((all_classes[n].CLASSDEPARTMENT == student.MINOR) and (minor_count >2)):
				replacement_seed = rng.randi_range(0,major_class_array.size()-1)
				while used_classes_list.has(major_class_array[replacement_seed].CLASSNAME):
					replacement_seed = rng.randi_range(0,major_class_array.size()-1)
				all_classes[n] = major_class_array[replacement_seed]
				used_classes_list.append(all_classes[n].CLASSNAME)
				major_count+=1
				minor_count= minor_count -1
			elif(major_count < 3) and all_classes[n].CLASSDEPARTMENT != student.MAJOR and all_classes[n].CLASSDEPARTMENT != student.MINOR:
				replacement_seed = rng.randi_range(0,major_class_array.size()-1)
				while used_classes_list.has(major_class_array[replacement_seed].CLASSNAME):
					replacement_seed = rng.randi_range(0,major_class_array.size()-1)
				all_classes[n] = major_class_array[replacement_seed]
				used_classes_list.append(all_classes[n].CLASSNAME)
				major_count +=1
			elif(minor_count < 1) and all_classes[n].CLASSDEPARTMENT != student.MAJOR and all_classes[n].CLASSDEPARTMENT != student.MINOR:
				replacement_seed = rng.randi_range(0,minor_class_array.size()-1)
				while used_classes_list.has(minor_class_array[replacement_seed].CLASSNAME):
					replacement_seed = rng.randi_range(0,minor_class_array.size()-1)
				all_classes[n] = minor_class_array[replacement_seed]
				used_classes_list.append(all_classes[n].CLASSNAME)
				minor_count +=1
	
	mon_wed_fri_classes = []
	tu_thurs_classes = []
	mon_wed_fri_classes.append(all_classes[0])
	mon_wed_fri_classes.append(all_classes[1])
	mon_wed_fri_classes.append(all_classes[2])	
	tu_thurs_classes.append(all_classes[3])
	tu_thurs_classes.append(all_classes[4])
	
	start_end_conflict_finder(mon_wed_fri_classes,student,major_class_array,minor_class_array,used_classes_list)

	start_end_conflict_finder(tu_thurs_classes,student,major_class_array,minor_class_array,used_classes_list)
	
	#trims null elements that may be present after start_end_conflict_finder calls
	_trim(mon_wed_fri_classes)
	_trim(tu_thurs_classes)
	#strings to hold the classes that we are going to insert into the student's profile
	var mon_wed_fri_string:String = ""
	var tu_thur_string:String = ""
	var index = 0
	#iterates through the classes and appends them to a string
	for lesson in mon_wed_fri_classes:
		#prevents a comma from being added to the last element of the array(to prevent formatting explosion)
		if index == mon_wed_fri_classes.size()-1:
			mon_wed_fri_string += mon_wed_fri_classes[index].CLASSNAME 
		else:
			mon_wed_fri_string += mon_wed_fri_classes[index].CLASSNAME + ","
		index+=1
	index = 0
	#does the same as above except for the tuesday/thursday classes
	for lesson in tu_thurs_classes:
		if index == tu_thurs_classes.size()-1:
			tu_thur_string += tu_thurs_classes[index].CLASSNAME
		else:
			tu_thur_string += tu_thurs_classes[index].CLASSNAME + ","
		index +=1
	#assigns the resulting strings to the student's profile, setting their schedule of classes in the dictionary
	student["MONDAY"] = mon_wed_fri_string
	student["WEDNESDAY"] = mon_wed_fri_string
	student["FRIDAY"] = mon_wed_fri_string
	
	student["TUESDAY"] = tu_thur_string
	student["THURSDAY"] = tu_thur_string
	
#function that briefly shows the schedule browser so that the first schedule's labels get placed correctly, 
#fixing an issue where the first schedule's contents would be in the wrong positions 
#if the schedule browser window was hidden on game start
#probably a better way to fix this but it works
func initial_schedule_setup():
	$"..".show()
	show()
	_set_Current_Schedule(studentIndex)
	await get_tree().create_timer(.01).timeout
	$"..".hide()
	hide()
#function to initialize progress bar UI elements
func progress_bar_update():
	progress_label.clear()
	var current_student = str(studentIndex)
	progress_bar.set_value_no_signal(current_student.to_int())
	progress_bar.max_value = schedule_totaler()
	var total_students = str(progress_bar.max_value)
	var label_text = "Reviewed " + current_student + "/" + total_students + " schedules"
	progress_label.append_text("[center]%s[/center]" % label_text)
	
func schedule_totaler():
	var schedule_count = 0
	for n in studentData:
		schedule_count +=1
	return schedule_count
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
	student_name.add_text("NAME: " + studentData[student].NAME)
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

	if check_for_errors(parent_class_array) != 0:
		invalid_schedules+=1
	else:
		valid_schedules+=1
func score_checker():

	valid_schedules_number.clear()
	approved_schedules_number.clear()
	invalid_schedules_number.clear()
	rejected_schedules_number.clear()
	end_game_parent_window.show()
	end_game_window.show()
	valid_schedules_number.append_text("[right]%s[/right]" % valid_schedules)
	approved_schedules_number.append_text("[right][b]%s" % player_approvals)
	invalid_schedules_number.append_text("[right]%s[/right]" %invalid_schedules)
	rejected_schedules_number.append_text("[right][b]%s"% player_denials)
	#var total_scheds = valid_schedules+invalid_schedules

#func that takes the day, the array of labels, and the parent array from set_current_schedule
#and assigns the contents of the parent array to labels 
func label_assigner(day:int, parent_array:Array,day_of_week_group:Array):
	#var that will hold the text to be appended in the label
	var labelText:String = ""
	#var that will hold the classes whose data needs to fill out the labels
	var checkedResult:Array
	#var that will hold the path to a label 
	var path:NodePath
	#vars that will hold the 12 hr start and end time of classes
	var _12_hr_start_time
	var _12_hr_end_time
	var n = 0
	for label in parent_array[day]:
		#waits a fraction of a second because I was having issues with the first schedule not placing correctly and 
		#this seems to fix it 
		await get_tree().create_timer(.01).timeout
		
		#calls check_for_class func and stores the results in an array of dictionaries
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

func check_for_errors(current_schedule_data:Array):
	#var current_student_name = studentData[studentIndex].NAME
	var current_student_major = studentData[studentIndex].MAJOR
	var current_student_minor = studentData[studentIndex].MINOR
	var current_student_year = studentData[studentIndex].YEAR
	#current student financial aid status
	var current_student_FAS = studentData[studentIndex]["FINANCIAL AID"]
	#current student account status
	var current_student_AS = studentData[studentIndex]["ACCOUNT STATUS"]
	var result_array:Array =[]
	var credit_total:int
	var major_class_total:int
	var minor_class_total:int
	#creates a regex var that will be used for class number comparison later
	var regex = RegEx.new()
	#sets the pattern to match letters and whitespaces
	regex.compile("^[A-Za-z]\\S+\\s+")
	var lesson_name:String
	var lesson_numbers_only
	#return value of -1 indicates account delinquency 
	if current_student_AS == "DELINQUENT":
		return -1
	else:
		result_array.resize(current_schedule_data.size())
		var trimmed_result_array:Array
		#goes through the passed data and calls check_for_class, giving us an array of dictionary arrays, allowing us to utilize the keys for error checking
		for n in range(0,current_schedule_data.size()):
			result_array[n] =check_for_class(current_schedule_data[n],classData)
		trimmed_result_array = remove_duplicates(result_array)
	
		credit_total = credit_count(trimmed_result_array)
		#return value of 1 indicates invalid credit count
		if current_student_FAS == "NO" and credit_total in range(13,19):
			pass
		elif current_student_FAS == "YES" and credit_total in range(15,19):
			pass
		else:
			return 1 
		#return value of 2 indicates invalid number of major classes
		major_class_total = major_class_count(current_student_major,trimmed_result_array)
		if major_class_total < 3:
			return 2
		else:
			pass
		
		minor_class_total = minor_class_count(current_student_minor,trimmed_result_array)
		#return value of 3 indicates invalid number of minor classes
		if minor_class_total < 1:
			return 3
		else:
			pass
		if current_student_year == "FRESHMAN":
			for item in result_array:
				for lesson in item:
					lesson_name = lesson.CLASSNAME
					#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
					lesson_numbers_only = regex.sub(lesson_name,"")  
					#return value of 4 indicates a freshman with a senior level class
					if lesson_numbers_only.begins_with("4"):
						return 4
		elif current_student_year == "SENIOR":
			for item in result_array:
				for lesson in item:
					lesson_name = lesson.CLASSNAME
					#lesson_numbers var gets set to just the numbers of the lesson_name var, using regex to replace letters/spaces with nothing
					lesson_numbers_only = regex.sub(lesson_name,"")  
					#return value of 5 indicates a senior with a freshman level class
					if lesson_numbers_only.begins_with("1"):
						return 5
			
	#return value of 0 indicates all criteria met
	return 0
#helper function that checks the number of minor classes the student is enrolled in and returns the total
func minor_class_count(s_minor,array:Array):
	var minor_class_total = 0
	for item in array:
		if item.CLASSDEPARTMENT == s_minor:
			minor_class_total+=1
	return minor_class_total
#helper function that checks the number of major classes the student is enrolled in and returns the total
func major_class_count(s_major,array:Array):
	var major_class_total = 0
	for item in array:
		if item.CLASSDEPARTMENT == s_major:
			major_class_total+=1
	return major_class_total
#helper function that tallies and returns the total credits of the classes contained within the passed array 
func credit_count(array:Array):
	var credit_total = 0
	for item in array:
		credit_total+=item.CREDITS
	return credit_total
#function that goes through a passed array and each child array and eliminates duplicate items. This is mainly so we can add up credits without miscounting 
func remove_duplicates(passed_array:Array):
	var unique_array:Array = []
	for array in passed_array:
		for child in array:
			#if the new array does not already have this child, append it to the new array
			if not unique_array.has(child):
				unique_array.append(child)
	return unique_array
#helper function that sets the position of the label and its padding, then shows it in the schedule browser
func label_placer(array,array_index,current_label:RichTextLabel):
	var class_start_time = int(array[array_index].CLASSSTARTTIME)
	var label_x_coordinate = current_label.global_position.x
	
	var start_label = which_starting_label(class_start_time)
	
	current_label.get_theme_stylebox("normal").corner_detail = 1
	current_label.get_theme_stylebox("normal").corner_radius_top_left = 10
	current_label.get_theme_stylebox("normal").corner_radius_top_right = 10
	current_label.get_theme_stylebox("normal").corner_radius_bottom_left = 10
	current_label.get_theme_stylebox("normal").corner_radius_bottom_right = 10
	current_label.get_theme_stylebox("normal").shadow_color = Color(0, 0, 0)
	current_label.get_theme_stylebox("normal").shadow_size = 10
	
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
			
func _input(_event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("esc_pressed")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
		player_approvals+=1
		score_checker()
		get_node("..").queue_free()
		queue_free()
	else:
		player_approvals+=1
		increment_student_index()
		progress_bar_update()
		_set_Current_Schedule(studentIndex)

#when the no button is pressed
func _on_no_button_pressed():
	#prevents button spam from crashing the game by constantly calling set_current_schedule
	if studentIndex == studentData.size()-1:
		player_denials+=1
		score_checker()
		get_node("..").queue_free()
		queue_free()
	else:
		player_denials+=1
		increment_student_index()
		progress_bar_update()
		_set_Current_Schedule(studentIndex)
