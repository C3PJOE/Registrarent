extends Window
#containers 
@onready var class_catalogue_scroll_container = $ClassCatalogueScrollContainer
@onready var class_catalogue_container = $ClassCatalogueScrollContainer/ClassCatalogueContainer
#labels to hold class data
@onready var class_1 = $ClassCatalogueScrollContainer/ClassCatalogueContainer/Class1

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
	#label text var will hold the contents of the label(i.e, the passed class information);will be appended to the label later
	var label_text = "CLASS NAME: " + label_content.CLASSNAME + "\nLOCATION: " + label_content.CLASSLOCATION + "\nDEPARTMENT: " + label_content.CLASSDEPARTMENT + "\nSTART TIME: " + label_content.CLASSSTARTTIME + "\nEND TIME: " + label_content.CLASSENDTIME
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
#function to iterate through the catalogue and give each class a label
func _catalogue_filler(catalogue:Array):
	var n = 1
	for lesson in catalogue:
		var class_label_number = "Class" + str(n)
		_add_label_to_catalogue(_label_maker(class_label_number,lesson))     
		n+=1
		
	
