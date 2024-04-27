extends KinematicBody2D

export var drop_type = 0 # GREEN=0, BLUE=1, PURPLE=2
var velocity = Vector2()
var gravity = 200

func _ready():
	if drop_type == 0:
		$AnimationPlayer.play("green")
	elif drop_type == 1:
		$AnimationPlayer.play("blue")
	elif drop_type == 2:
		$AnimationPlayer.play("purple")
	else:
		print("exceção no tipo de drop item")
		

func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)


func _on_CollectArea_body_entered(body):
	if drop_type == 0:
		Global.points += 1
	elif drop_type == 1:
		Global.points += 3
	elif drop_type == 2:
		Global.points += 20
	else:
		Global.points += 999
		
	if body.name == "Player":
		$AnimationPlayer.play("collected")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "green" or anim_name == "blue" or anim_name == "purple":
		queue_free()
	if anim_name == "collected":
		queue_free()
