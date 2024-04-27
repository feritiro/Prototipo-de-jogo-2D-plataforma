extends Control

func _ready():
	$return_button.grab_focus()
	
	if Global.game_data.level1_unlocked:
		$VBoxContainer/lv1.text = "    Level 1:  " +str(Global.game_data.lv1_time) + " s, " + str(Global.game_data.lv1_points) + " pts, " + str(Global.game_data.lv1_points/Global.game_data.lv1_time) + " pts/s\n"
	if Global.game_data.level2_unlocked:
		$VBoxContainer/lv2.text = "    Level 2:  " +str(Global.game_data.lv2_time) + " s, " + str(Global.game_data.lv2_points) + " pts, " + str(Global.game_data.lv2_points/Global.game_data.lv2_time) + " pts/s\n" 
	if Global.game_data.level3_unlocked:
		$VBoxContainer/lv3.text = "    Level 3:  " +str(Global.game_data.lv3_time) + " s, " + str(Global.game_data.lv3_points) + " pts, " + str(Global.game_data.lv3_points/Global.game_data.lv3_time) + " pts/s\n" 
	if Global.game_data.level4_unlocked:
		$VBoxContainer/lv4.text = "    Level 4:  " +str(Global.game_data.lv4_time) + " s, " + str(Global.game_data.lv4_points) + " pts, " + str(Global.game_data.lv4_points/Global.game_data.lv4_time) + " pts/s\n" 
	if Global.game_data.level5_unlocked:
		$VBoxContainer/lv5.text = "    Level 5:  " +str(Global.game_data.lv5_time) + " s, " + str(Global.game_data.lv5_points) + " pts, " + str(Global.game_data.lv5_points/Global.game_data.lv5_time) + " pts/s\n" 
	
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK:
			print("error on change scene to startScreen")


func _on_return_button_pressed():
	if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK:
		print("error on change scene to startScreen")
