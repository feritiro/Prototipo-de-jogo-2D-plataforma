extends Control


func _ready():
	$HBoxContainer/lv1_button.grab_focus()

func _process(_delta):

	if Input.is_action_pressed("ui_cancel"):
		if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK:
			print("error on change scene to startScreen")

	if not Global.game_data.level1_unlocked:
		$HBoxContainer/lv1_button.disabled = true
		$HBoxContainer/lv1_button.visible = false

	if not Global.game_data.level2_unlocked:
		$HBoxContainer/lv2_button.disabled = true
		$HBoxContainer/lv2_button.visible = false
		
	if not Global.game_data.level3_unlocked:
		$HBoxContainer/lv3_button.disabled = true
		$HBoxContainer/lv3_button.visible = false
		
	if not Global.game_data.level4_unlocked:
		$HBoxContainer2/lv4_button.disabled = true
		$HBoxContainer2/lv4_button.visible = false
		
	if not Global.game_data.level5_unlocked:
		$HBoxContainer2/lv5_button.disabled = true
		$HBoxContainer2/lv5_button.visible = false
		
	if not Global.game_data.level6_unlocked:
		$HBoxContainer2/lv6_button.disabled = true
		$HBoxContainer2/lv6_button.visible = false

func _on_lv1_button_pressed():
	if (get_tree().change_scene("res://Scenes/World.tscn")) != OK:
		print("error on change scene to World")

func _on_lv2_button_pressed():
	if (get_tree().change_scene("res://Scenes/World2.tscn")) != OK:
		print("error on change scene to World2")

func _on_lv3_button_pressed():
	if (get_tree().change_scene("res://Scenes/World3.tscn")) != OK:
		print("error on change scene to World3")

func _on_lv4_button_pressed():
	if (get_tree().change_scene("res://Scenes/World4.tscn")) != OK:
		print("error on change scene to World4")

func _on_lv5_button_pressed():
	if (get_tree().change_scene("res://Scenes/World5.tscn")) != OK:
		print("error on change scene to World5")

func _on_lv6_button_pressed():
	if (get_tree().change_scene("res://Scenes/World6.tscn")) != OK:
		print("error on change scene to World6")


func _on_return_button_pressed():
	if (get_tree().change_scene("res://Scenes/startScreen2.tscn")) != OK: 
		print("error on change scene to startScreen")
