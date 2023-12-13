extends Window
#containers 
@onready var class_catalogue_scroll_container = $ClassCatalogueScrollContainer
@onready var class_catalogue_container = $ClassCatalogueScrollContainer/ClassCatalogueContainer
#labels for the dropdown menus
@onready var department_dropdown = $Dropdown1/DepartmentDropdown
@onready var time_dropdown = $Dropdown2/TimeDropdown

var file = "res://UniData/ClassData.json"
var class_data

# Called when the node enters the scene tree for the first time.
func _ready():
	class_data = read_json_file(file)
	_convert_the_times()
	_catalogue_filler(class_data)

#function to convert the times in class data to 12 hr format
func _convert_the_times():
	var start_time:int 
	var end_time:int
	#this loop converts the start times in the dictionaries to 12 hr time, so the 
	#contents of the catalogue show 12 hr time when displayed, not 24 hr time
	for lesson in class_data: 
		start_time = lesson.CLASSSTARTTIME.to_int()
		end_time = lesson.CLASSENDTIME.to_int()
		lesson["CLASSSTARTTIME"] = _24_to_12_hr_time(start_time)
		lesson["CLASSENDTIME"] = _24_to_12_hr_time(end_time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#function to read json files and returns them as a dictionary*(in this case, more like an array which contains dictionaries)
func read_json_file(parameter: String):
	var json_as_text = FileAccess.get_file_as_string(parameter)
	var json_as_dict = JSON.parse_string(json_as_text.to_upper()) 
	return json_as_dict

#function to generate new labels
func _label_maker(label_name:String,label_content:Dictionary)->RichTextLabel:
	var font = FontFile
	font = load("res://Assets/Fonts/times.ttf")
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
	new_label.add_theme_color_override("default_color",Color(0.984, 0.949, 0.212))
	new_label.add_theme_color_override("font_shadow_color",Color(0, 0, 0)) 
	new_label.add_theme_constant_override("shadow_offset_y",1)
	new_label.add_theme_constant_override("shadow_outline_size",2)
	new_label.add_theme_font_override("normal_font",font)
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
	#iterates through every class in the originally passed catalogue
	for cl in catalogue:
		#if the current class' department matches the specific filter 
		if cl.CLASSDEPARTMENT == specific_filter:
			#appens the class to the array of filtered classes
			filtered_catalogue.append(cl)
	
	return filtered_catalogue

#function to filter the passed array using the specific filter as a key, returns the filtered array
func _filter_by_time(catalogue:Array,specific_filter:String)->Array:
	var filtered_catalogue:Array = []
	#iterates through every class in the originally passed catalogue
	for cl in catalogue:
		#if the current class' department matches the specific filter 
		if cl.CLASSSTARTTIME == specific_filter:
			#appens the class to the array of filtered classes
			filtered_catalogue.append(cl)
	
	return filtered_catalogue
					
func _on_department_dropdown_item_selected(index):
	var filter_param = department_dropdown.get_item_text(index)
	#if the selection is for all classes, we just call the default catalogue filler 
	if filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data)
	else:
		#calls catalogue filler, passing department as the general filter type and filter_param as the specific department 
		_catalogue_filler(class_data,"DEPARTMENT",filter_param)

func _on_time_dropdown_item_selected(index):
	var filter_param = time_dropdown.get_item_text(index)
	#if the selection is for all times, we just call the default catalogue filler 
	if filter_param == "ALL":
		container_clearer()
		_catalogue_filler(class_data)
	else:
		#calls catalogue filler, passing time as the general filter type and filter_param as the specific department 
		_catalogue_filler(class_data,"TIME",filter_param)
