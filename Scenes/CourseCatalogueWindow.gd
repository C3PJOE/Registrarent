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
	_catalogue_filler(class_data)

	
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
	print(label_name," ",label_content.CLASSNAME)
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
	#overrides some default colors/constants to match desired aesthetic "theme_override_colors/default_color"
	new_label.add_theme_color_override("default_color",Color(0.984, 0.949, 0.212))
	new_label.add_theme_color_override("font_shadow_color",Color(0, 0, 0))
	new_label.add_theme_constant_override("shadow_offset_y",1)
	new_label.add_theme_constant_override("shadow_outline_size",2)
	#adds the previously initialized label text var to the label 
	new_label.append_text("[center]%s[/center]"%label_text)
	return new_label
#function to add the labels from label_maker to the catalogue container
func _add_label_to_catalogue(label:RichTextLabel):
	class_catalogue_container.add_child(label)
	
func _remove_label_from_catalogue(label:RichTextLabel):
	label.hide()
	label.free()
#function that makes an array containing the different departments 
func _dept_list_maker(catalogue:Array)->Array:
	#var to track index of array
	var n = 0
	#array to hold departments
	var department_list:Array = []
	#iterates through every class in the course catalogue 
	for lesson in catalogue:
		#if the department is already in the array, no need to add it again
		if lesson.CLASSDEPARTMENT in department_list:
			pass
		#if the department is not already in the array, we add it and increment the array's index
		elif lesson.CLASSDEPARTMENT not in department_list:
			department_list.append(lesson.CLASSDEPARTMENT)
			n+=1
	return department_list
	
#function to iterate through the catalogue and give each class a label
func _catalogue_filler(catalogue:Array,optional_filter_type:String = "NO FILTER",optional_specific_filter:String =""):
	var dept_list = _dept_list_maker(catalogue)
	match optional_filter_type:
		"NO FILTER":
			var n = 1
			for lesson in catalogue:
				var class_label_number = "Class" + str(n)
				_add_label_to_catalogue(_label_maker(class_label_number,lesson))     
				n+=1
		"DEPARTMENT":
			container_clearer()
			#function calls itself with no specific filter, using _filter function as parameter. 
			#No matter the filter key, the final step of sorting will be to make labels and add them to the catalogue,
			#so calling the function like this prevents redundant copy/pasting. 
			_catalogue_filler(_filter(catalogue,optional_specific_filter))

func container_clearer():
	#iterates through every child in class_catalogue_container
	for  child in class_catalogue_container.get_children():
		#removes the child from the catalogue container
		class_catalogue_container.remove_child(child)
		#frees the child from memory
		child.queue_free()
		#class_catalogue_container.remove_child(class_catalogue_container.get_child(n))
	
func _filter(catalogue:Array,specific_filter:String)->Array:
	var clone_catalogue = catalogue.duplicate()
	var sorted_catalogue:Array = []
	#iterates through every class in the originally passed catalogue
	for cl in catalogue:
		#if the current class' department matches the specific filter 
		if cl.CLASSDEPARTMENT == specific_filter:
			#appens the class to the array of sorted classes
			sorted_catalogue.append(cl)
			#erases the class from the clone catalogue, so that there are no duplicates when we merge it with the sorted_catalogue
			clone_catalogue.erase(cl)
			
	#adds the rest of the classes to the back of the sorted array, thus giving us a sorted catalogue of classes	
	sorted_catalogue.append_array(clone_catalogue)
	return sorted_catalogue

					
func _on_department_dropdown_item_selected(index):
	var filter_param = department_dropdown.get_item_text(index)
	_catalogue_filler(class_data,"DEPARTMENT",filter_param)
