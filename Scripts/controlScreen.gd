extends Control

func _ready():
	$return_button.grab_focus()

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK:
			print("error on change scene to startScreen")


func _on_return_button_pressed():
	if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK:
		print("error on change scene to startScreen")
