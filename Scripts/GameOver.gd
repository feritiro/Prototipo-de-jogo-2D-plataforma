extends CanvasLayer

func _ready():
	$tryagain_button.grab_focus()


func _on_tryagain_button_pressed():
#	if get_tree().reload_current_scene() != OK:
#		print("Error on reload_current_scene")

	if Global.current_level == "World":
		if get_tree().change_scene("res://Scenes/World.tscn") != OK:
			print("Error on change_scene")
	elif Global.current_level == "World2":
		if get_tree().change_scene("res://Scenes/World2.tscn") != OK:
			print("Error on change_scene")
	elif Global.current_level == "World3":
		if get_tree().change_scene("res://Scenes/World3.tscn") != OK:
			print("Error on change_scene")
	elif Global.current_level == "World4":
		if get_tree().change_scene("res://Scenes/World4.tscn") != OK:
			print("Error on change_scene")
	elif Global.current_level == "World5":
		if get_tree().change_scene("res://Scenes/World5.tscn") != OK:
			print("Error on change_scene")
	elif Global.current_level == "World6":
		if get_tree().change_scene("res://Scenes/World6.tscn") != OK:
			print("Error on change_scene")
	else:
		print("exception in game over scene")


func _on_return_button_pressed():
	if get_tree().change_scene("res://Scenes/startScreen.tscn") != OK:
		print("Error on change_scene")
