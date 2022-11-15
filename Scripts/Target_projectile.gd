extends Area2D

var velocity = Vector2.ZERO
var look_vector = Vector2.ZERO
var player = null
var speed = 20



func _ready():
	look_vector = player.position - global_position
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = velocity.move_toward(look_vector,delta)
	velocity = velocity.normalized() 
	position += velocity 
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Target_projectile_body_entered(body):
	if body.name == "Player":
		queue_free()
