extends Control


func _ready():
	# RESET VARIABLES
	Global.game_data.checkpoint = false
	Global.game_data.checkpoint_pos_x = 0
	Global.game_data.checkpoint_pos_y = 170
	Global.temp_score = 0
	Global.save_data()
	
	$VBoxContainer/play_button.grab_focus()

	if Global.game_data.game_cleared == true:
		$Sprite2.visible = true
		$ColorRect/AnimationPlayer.play("fade_in_white")
	else:
		$ColorRect/AnimationPlayer.play("fade_in_black")

#func _on_start_button_pressed():
#	get_tree().change_scene("res://Scenes/World.tscn")

func _on_credits_button_pressed():
	if (get_tree().change_scene("res://Scenes/creditsScreen.tscn")) != OK:
		print("error on change scene to creditsScreen")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_controls_button_pressed():
	if (get_tree().change_scene("res://Scenes/controlScreen.tscn")) != OK:
		print("error on change scene to controlScreen")

func _on_play_button_pressed():
	if (get_tree().change_scene("res://Scenes/selectScreen.tscn")) != OK:
		print("error on change scene to selectScreen")

func _on_score_button_pressed():
	if (get_tree().change_scene("res://Scenes/scoreScreen.tscn")) != OK:
		print("error on change scene to controlScreen")
