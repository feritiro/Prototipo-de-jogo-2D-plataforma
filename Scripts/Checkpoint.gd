extends Node2D


func _ready():
	pass


func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		body.hit_checkpoint()
		$AnimationPlayer.play("checked")
		$CollisionShape2D.queue_free()
