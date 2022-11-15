extends Area2D
onready var player = Global.get("player")
var velocity = Vector2.ZERO
var shot_speed = -100
var direction = 1
var look_vector = Vector2.ZERO

func _ready():
	look_vector = player.position - global_position

func _physics_process(delta):
	#follow_projectile(delta)
	horizontal_projectile(delta)
	#target_projectile(delta)
	
func horizontal_projectile(delta):
	velocity.x = shot_speed * delta * direction
	translate(velocity)
	
func target_projectile(delta):#bug
	velocity = Vector2.ZERO
	velocity = velocity.move_toward(look_vector,delta)
	velocity = velocity.normalized() 
	velocity.x = - velocity.x * direction
	position += velocity 
	

func follow_projectile(delta): #bug
	var distance = player.global_position.x - self.global_position.x
	var height = player.global_position.y - self.global_position.y
	var vector_aux = Vector2(distance,height).normalized()
	velocity.x = shot_speed * delta
	velocity.y = shot_speed * delta
	velocity = vector_aux * velocity * direction
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Plant_projectile_body_entered(body):
	if body.name == "Player":
		queue_free()
