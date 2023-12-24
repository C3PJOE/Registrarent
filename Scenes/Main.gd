extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_min_size(Vector2i(1024,576))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

#reloads the game as if it was just launched
func _on_play_again_pressed():
	$EndGameParentWindow.hide()
	$EndGameParentWindow/EndGameWindow.hide()
	get_tree().reload_current_scene()

	

	
