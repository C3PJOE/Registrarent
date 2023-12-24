extends Window
signal esc_pressed
#containers 
@onready var class_catalogue_scroll_container = $ClassCatalogueScrollContainer
@onready var class_catalogue_container = $ClassCatalogueScrollContainer/ClassCatalogueContainer
#labels for the dropdown menus
@onready var department_dropdown = $Dropdown1/DepartmentDropdown
@onready var time_dropdown = $Dropdown2/TimeDropdown
@onready var catalogue_taskbar_button = $"../Desktop/Taskbar/TaskbarShortcutContainer/CatalogueTaskbarButton"
@onready var pause_menu = $"../PauseMenu"

var file = "res://UniData/ClassData.json"
var class_data

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	class_data = read_json_file(file)
	_convert_the_times()
	_catalogue_filler(class_data)

func _input(_event):
	if  Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("esc_pressed")
#function to convert the times in class data to 12 hr format
func _convert_the_times():
	var start_time:int 
	var end_time:int
	#this loop converts the start times in the dictionaries to 12 hr time, so the 
	#contents of the catalogue show 12 hr time when displayed, not 24 hr time
	for lesson in class_data: 
		start_time = lesson.CLASSSTARTTIME
		end_time = lesson.CLASSENDTIME
		lesson["CLASSSTARTTIME"] = _24_to_12_hr_time(start_time)
		lesson["CLASSENDTIME"] = _24_to_12_hr_time(end_time)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
#function to read json files and returns them as a dictionary*(in this case, more like an array which contains dictionaries)
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict

#function to generate new labels
func _label_maker(label_name:String,label_content:Dictionary)->RichTextLabel:
	
	#label text var will hold the contents of the label(i.e, the passed class information);will be appended to the label later
	var label_text = "CLASS NAME: " + label_content.CLASSNAME + "\nCREDITS: " + str(label_content.CREDITS) + "\nLOCATION: " + label_content.CLASSLOCATION + "\nDEPARTMENT: " + label_content.CLASSDEPARTMENT + "\nSTART TIME: " + label_content.CLASSSTARTTIME + "\nEND TIME: " + label_content.CLASSENDTIME 
	#creates a new rich text label
	var new_label = RichTextLabel.new()
	new_label.name = label_name
	#makes the label parse bbcode tags
	new_label.bbcode_enabled = true
	#makes the label fit its content to the size of the container
	new_label.fit_content = true
	#sets the label's minimum size
	new_label.custom_minimum_size = Vector2(200,200)
	#overrides some default fonts/colors/constants to match desired aesthetic 
	new_label.add_theme_color_override("default_color",Color(0,0,0))#0.984, 0.949, 0.212
	#new_label.add_theme_color_override("font_shadow_color",Color(0, 0, 0)) 
	#new_label.add_theme_constant_override("shadow_offset_y",1)
	#new_label.add_theme_constant_override("shadow_outline_size",4)
	new_label.add_theme_font_size_override("normal_font_size",20)
	#adds the previously initialized label text var to the label 
	new_label.append_text("[center]%s[/center]"%label_text)
	
	return new_label
#function to add the labels from label_maker to the catalogue container
func _add_label_to_catalogue(label:RichTextLabel):
	class_catalogue_container.add_child(label)
	
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
#function to iterate through the catalogue and give each class a label
func _catalogue_filler(catalogue:Array,optional_filter_type:String = "NO FILTER",optional_specific_filter:String =""):
	match optional_filter_type:
		"NO FILTER":
			var _n = 1
			for lesson in catalogue:
				var class_label_number = "Class" + str(_n)
				_add_label_to_catalogue(_label_maker(class_label_number,lesson))     
				_n+=1
		"DEPARTMENT":
			container_clearer()
			#function calls itself with no specific filter, using _filter function as parameter. 
			#No matter the filter key, the final step of sorting will be to make labels and add them to the catalogue,
			#so calling the function like this prevents redundant copy/pasting. 
			_catalogue_filler(_filter_by_department(catalogue,optional_specific_filter))
		"TIME":
			container_clearer()
			_catalogue_filler(_filter_by_time(catalogue,optional_specific_filter))
			
#function to clear the catalogue container
func container_clearer():
	#iterates through every child in class_catalogue_container
	for  child in class_catalogue_container.get_children():
		#removes the child from the catalogue container
		class_catalogue_container.remove_child(child)
		#frees the child from memory
		child.queue_free()
		#class_catalogue_container.remove_child(class_catalogue_container.get_child(n))
		
#function to filter the passed array using the specific filter as a key, returns the filtered array
func _filter_by_department(catalogue:Array,specific_filter:String)->Array:
	var filtered_catalogue:Array = []
	var time_dropdown_text = time_dropdown.get_item_text(time_dropdown.selected)
	if time_dropdown_text == "ALL":
		#iterates through every class in the originally passed catalogue
		for cl in catalogue:
			#if the current class' department matches the specific filter 
			if cl.CLASSDEPARTMENT == specific_filter:
				#appens the class to the array of filtered classes
				filtered_catalogue.append(cl)
	else:
		#sets the filtered catalogue equal to the result of filter_by_time_and_department, which will return an array that's been filtered based on both keys
		filtered_catalogue = _filter_by_time_and_department(catalogue,time_dropdown_text,specific_filter)
		
	return filtered_catalogue

#function to filter the passed array using the specific filter as a key, returns the filtered array
func _filter_by_time(catalogue:Array,specific_filter:String)->Array:
	var filtered_catalogue:Array = []
	var department_dropdown_text = department_dropdown.get_item_text(department_dropdown.selected)
	#checks to see if there is a secondary filter that needs to be applied. "ALL" indicates there is not
	if department_dropdown_text == "ALL":
		#iterates through every class in the originally passed catalogue
		for cl in catalogue:
			#if the current class' department matches the specific filter 
			if cl.CLASSSTARTTIME == specific_filter:
				#appends the class to the array of filtered classes
				filtered_catalogue.append(cl)
	else:
		#sets the filtered catalogue equal to the result of filter_by_time_and_department, which will return an array that's been filtered based on both keys
		filtered_catalogue = _filter_by_time_and_department(catalogue,specific_filter,department_dropdown_text)
		
	return filtered_catalogue
#function to filter the passed array using the 2 specific filters as keys, returns the filtered array
func _filter_by_time_and_department(catalogue:Array,specific_filter_time:String,specific_filter_department:String):
	var filtered_catalogue:Array = []
	for cl in catalogue:
		#if the current class matches both the passed time and department filter
		if cl.CLASSSTARTTIME == specific_filter_time and cl.CLASSDEPARTMENT == specific_filter_department:
			filtered_catalogue.append(cl)
	
	return filtered_catalogue		
func _on_department_dropdown_item_selected(index):
	var filter_param = department_dropdown.get_item_text(index)
	var time_filter_param = time_dropdown.get_item_text(time_dropdown.selected)
	#if the selection is for all classes, we just call the default catalogue filler 
	if filter_param == "ALL" and time_filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data)
	#if the selection is for all depts but the time dropdown doesn't have ALL selected, we call catalogue filler, passing time as the general
	#filter type and time_filter_param as the specific filter
	elif filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data,"TIME",time_filter_param)
	else:
		#calls catalogue filler, passing department as the general filter type and filter_param as the specific department 
		_catalogue_filler(class_data,"DEPARTMENT",filter_param)

func _on_time_dropdown_item_selected(index):
	var filter_param = time_dropdown.get_item_text(index)
	var department_filter_param = department_dropdown.get_item_text(department_dropdown.selected)
	#if the selection is for all times and the dept dropdown has ALL selected, we just call the default catalogue filler 
	if filter_param == "ALL" and department_filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data)
	#if the selection is for all times but the dept dropdown doesn't have ALL selected, we call catalogue filler, passing department as the general
	#filter type and department_filter_param as the specific filter
	elif filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data,"DEPARTMENT",department_filter_param)
	else:
		#calls catalogue filler, passing time as the general filter type and filter_param as the specific department 
		_catalogue_filler(class_data,"TIME",filter_param)

func _on_close_requested():
	#hides the window when the close button is hit 
	hide()
	catalogue_taskbar_button.hide()

func _on_esc_pressed():
	if pause_menu.visible == true:
		pause_menu.hide()
	else:
		pause_menu.show()

