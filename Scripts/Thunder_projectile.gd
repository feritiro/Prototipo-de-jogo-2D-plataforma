extends Area2D
onready var player = Global.get("player")
var velocity = Vector2.ZERO
export var shot_speed = -300
var direction = 1

func _ready():
	pass

func _physics_process(delta):
	horizontal_projectile(delta)
	translate(velocity)
#	$AnimationPlayer.play("throw")
	
func horizontal_projectile(delta):
	if direction == 1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	velocity.x = shot_speed * delta * direction


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Thunder_projectile_body_entered(_body):
	get_node("CollisionShape2D").set_deferred("disabled", true)
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _on_Thunder_projectile_area_entered(_area):
	get_node("CollisionShape2D").set_deferred("disabled", true)
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
