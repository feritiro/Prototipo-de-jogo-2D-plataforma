extends KinematicBody2D

onready var player = Global.get("player")
export (int) var speed = 40
export (int) var gravity = 400
var health = 4
var is_hit = false
var velocity = Vector2.ZERO
var move_direction = 1
var knockback_dir = 1
var knockback_power = 130
var is_idle = false
var is_dead = false
var is_attacking = false
var is_chasing = false
var distance


func _physics_process(delta):
	if is_hit or is_dead or is_attacking:
		velocity.x = 0
	elif is_idle:
		velocity.x = 0
	elif is_chasing:
		speed = 45
		distance = player.global_position.x - self.position.x
		if distance > 0:
			move_direction = 1
		else:
			move_direction = -1
		knockback_dir = -move_direction
		
		$raywall.scale.x = move_direction
		$Player_Detector.scale.x = move_direction
#		$Player_detector_area/CollisionShape2D.position.x = move_direction

		velocity.x = speed * move_direction
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity)
	else:
		velocity.x = speed * move_direction
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity)

	if move_direction == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	$Hitbox.scale.x = move_direction
		
	if is_dead:
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		get_node("Hurtbox/hurtbox_collision").set_deferred("disabled", true)
	
	if is_attacking:
		$Player_Detector.enabled = false
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer,"animation_finished")
		$Player_Detector.enabled = true
		is_attacking = false

	_set_animation()
	

func _set_animation():
	var anim = "walking"
	
	if $Player_Detector.is_colliding():
		is_attacking = true
	
	if $raywall.is_colliding():
		get_node("Player_detector_area/CollisionShape2D").set_deferred("disabled", true)
		is_idle = true
		anim = "idle"
	elif velocity.x != 0:
		anim = "walking"
		get_node("Player_detector_area/CollisionShape2D").set_deferred("disabled", false)
		
	if is_hit == true:
		anim = "hurted"

	if $AnimationPlayer.assigned_animation != anim:
		$AnimationPlayer.play(anim)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "idle":
		is_idle = false
		$raywall.scale.x *= -1
		$Player_Detector.scale.x *= -1
		move_direction *= -1
		$AnimationPlayer.play("walking")
		

func knockback():
	velocity.x = -knockback_dir * knockback_power
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(_area):
	is_hit = true
	health -= 1
	if health < 1:
		set_collision_layer_bit(1,false)
		set_collision_mask_bit(0, false)
		is_dead = true
	else:
		$AnimationPlayer.play("hurted")
		yield($AnimationPlayer,"animation_finished")
		is_hit = false


func _on_Player_detector_area_body_entered(body):
	if body.name == "Player":
		is_chasing = true

func _on_Player_detector_area_body_exited(body):
	if body.name == "Player":
		is_chasing = false


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.velocity.x = -knockback_dir * knockback_power
