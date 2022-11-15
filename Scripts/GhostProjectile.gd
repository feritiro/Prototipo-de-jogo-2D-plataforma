extends Area2D

var direction = Vector2.RIGHT
var speed = 40
var shotgun = false

func _process(delta):
	translate(direction.normalized() * delta * speed)
	if shotgun:
		$Timer.start(0.2)
		shotgun = false



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_GhostProjectile_body_entered(body):
	queue_free()

func _on_Timer_timeout():
	$Timer.stop()
	queue_free()
