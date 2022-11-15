extends KinematicBody2D
var player = null
onready var Bullet_scene = preload("res://Scenes/Target_projectile.tscn")
var velocity = Vector2.ZERO
var speed = 1
var move_direction = -1

func _physics_process(_delta):
	if move_direction == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	velocity = Vector2.ZERO
	if player != null:
		velocity = position.direction_to(player.position) * speed
	else:
		velocity = Vector2.ZERO
		
	velocity = velocity.normalized()
	velocity = move_and_collide(velocity)
	
func shot():
	var bullet = Bullet_scene.instance()
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(1)
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = body

func _on_Area2D_body_exited(body):
	player = null

func _on_Timer_timeout():
	if player != null:
		shot()
