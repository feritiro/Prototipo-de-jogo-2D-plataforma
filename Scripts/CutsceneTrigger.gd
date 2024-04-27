extends Area2D
# Triggers camera.current = false in the player script
# Conectar em player e arena_barrier
signal TriggerCutscene

func _physics_process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			emit_signal("TriggerCutscene")
			queue_free()



func _on_FireDemonBoss_BossDead():
	$trigger_col.disabled = false
