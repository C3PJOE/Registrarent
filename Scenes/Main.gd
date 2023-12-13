extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()

#reloads the game as if it was just launched
func _on_play_again_pressed():
	$EndGameParentWindow.hide()
	$EndGameParentWindow/EndGameWindow.hide()
	get_tree().reload_current_scene()
	
