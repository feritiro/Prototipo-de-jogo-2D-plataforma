extends KinematicBody2D

class_name enemyBase

export (int) var gravity = 400
var velocity = Vector2.ZERO
export (int) var speed = 40
export (int) var health = 3
var is_hit = false
var knockback_dir = 1
var knockback_power = 40

var move_direction = -1

func _physics_process(_delta):
	velocity.x = speed * move_direction
	#velocity.y += gravity * delta
	velocity = move_and_slide(velocity)
	knockback_dir = move_direction

	if move_direction == 1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	_set_animation()
	
func apply_gravity(delta):
	velocity.y += gravity * delta

func _set_animation():
	var anim = "walking"
	if $raywall.is_colliding():
		anim = "idle"
	elif velocity.x != 0:
		anim = "walking"
	
	if is_hit == true:
		anim = "hit"
		knockback()
	if $AnimationPlayer.assigned_animation != anim:
		$AnimationPlayer.play(anim)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "idle":
		$raywall.scale.x *= -1
		move_direction *= -1
		$AnimationPlayer.play("walking")

func _on_Hitbox_body_entered(body): #player pula em cima do enemy
	print("ppp")
	is_hit = true
	health -= 1
	body.velocity.y = body.jump_speed * 0.75
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer,"animation_finished")
	is_hit = false
	if health < 1:
		queue_free()
		get_node("Hitbox/hitbox_collision").set_deferred("disabled", true)

func knockback():
	velocity.x = -knockback_dir * knockback_power
	velocity = move_and_slide(velocity)

func _on_Hitbox_area_entered(_area): #golpe da espada
	is_hit = true
	health -= 1
	if health < 1:
		set_collision_layer_bit(1,false)
		set_collision_mask_bit(0, false)
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer,"animation_finished")
	is_hit = false
	if health < 1:
		queue_free()
		get_node("Hitbox/hitbox_collision").set_deferred("disabled", true)
