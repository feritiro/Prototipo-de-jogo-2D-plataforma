extends KinematicBody2D
var direction = Vector2.RIGHT
var speed = 50

func _ready():
	set_as_toplevel(true)
	direction = direction.normalized()
	look_at(direction + global_position)
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c = move_and_collide(v)
	if c and c.collider:
		#####etc
		queue_free()
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
