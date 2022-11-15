extends KinematicBody2D
var player = null
onready var player_pos = Global.get("player")
var velocity = Vector2.ZERO
var speed = 1
var move_direction = -1
var is_hit = false
var is_chasing = false
var is_attacking = false
var is_flying = true
var is_idle = false
var distance
var knockback_dir = 1
var knockback_power = 130

func _physics_process(_delta):
	distance = player_pos.global_position.x - self.position.x
	if distance > 0:
		move_direction = 1
	else:
		move_direction = -1
		
	knockback_dir = -move_direction
	
#	velocity = Vector2.ZERO
	if player != null:
		velocity = position.direction_to(player.position) * speed # speed nao faz diferença
	else:
		velocity = Vector2.ZERO
		
	velocity = velocity.normalized()
	velocity = move_and_collide(velocity)
	
	$Hitbox.scale.x = move_direction
		
	if move_direction == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

		
	if is_hit:
		get_node("Area2D/area_detector").set_deferred("disabled", true)
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		get_node("Hurtbox/hurtbox_collision").set_deferred("disabled", true)
			
	elif is_attacking: #FAZER ATAQUE QUE EXPLODE E SE SUICIDA -> QUEEU FREE
		get_node("Area2D/area_detector").set_deferred("disabled", true)
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer,"animation_finished")
		is_attacking = false
		is_idle = true

	elif is_idle:
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer,"animation_finished")
		get_node("Area2D/area_detector").set_deferred("disabled", false)
		is_idle = false
		is_flying = true
		
	else:
		$AnimationPlayer.play("flying")
		get_node("AttackArea/CollisionShape2D").set_deferred("disabled", false)
	
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = body


func _on_Area2D_body_exited(_body):
	player = null


func _on_Hurtbox_area_entered(_area):
	print("aaaa")
	is_hit = true

func _on_AttackArea_body_entered(body):
	if body.name == "Player":
		get_node("AttackArea/CollisionShape2D").set_deferred("disabled", true)
		is_flying = false
		is_attacking = true
		
func _on_AttackArea_body_exited(body):
	if body.name == "Player":
		pass
	
func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.velocity.x = -knockback_dir * knockback_power
