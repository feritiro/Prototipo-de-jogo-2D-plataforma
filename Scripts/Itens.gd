extends Area2D

export var points = 1


func _on_Itens_body_entered(_body):
	$AnimationPlayer.play("collected")
	Global.points += points


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collected":
		queue_free()
