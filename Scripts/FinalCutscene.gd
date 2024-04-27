extends Node2D

var on = false
var multi = 2

func _physics_process(_delta):
	if on:
		$Demon1.position.x += -0.1 * multi
		$Demon1.position.y += 0.05 * multi
		
		$blue_firebat.position.x += 0.1 * multi
		$blue_firebat.position.y += 0.05 * multi
		
		$blue_firebat2.position.x += -0.1 * multi
		
		$burning_ghoul.position.x += -0.1 * multi
		$burning_ghoul2.position.x += 0.1 * multi
		
		$FireGuardian.position.x += 0.1 * multi
		
		$undead.position.x += 0.1 * multi
		
		$fire_skull.position.x += -0.1 * multi
		$fire_skull.position.y += 0.1 * multi
		
func _on_Timer_timeout():
	on = false


func _on_CutsceneTrigger_TriggerCutscene():
	on = true
	$Timer.start()
	$ColorRect/AnimationPlayer.play("fade_out")
	get_parent().get_node("HUD").offset.x = -500


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		Global.game_data.game_cleared = true
		Global.save_data()
		if (get_tree().change_scene("res://Scenes/startScreen.tscn")) != OK:
			print("error on change scene to startScreen") 
