extends KinematicBody2D

onready var projectile_instance = preload("res://Plant_projectile.tscn")
onready var player = Global.get("player")
var facing_left = true
var health = 1
var is_hit = false


func _physics_process(_delta):
	if player:
		var distance = player.global_position.x - self.position.x
		facing_left = true if distance < 0 else false
	if facing_left:
		self.scale.x = 1
	else:
		self.scale.x = -1
		
func shoot():
	var projectile = projectile_instance.instance()
	get_parent().add_child(projectile)
	projectile.global_position = $spawnedShot.global_position
	if facing_left:
		projectile.direction = 1
	else:
		projectile.direction = -1


func _on_playerDetectorArea_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("attack")


func _on_playerDetectorArea_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("idle")


func _on_hitbox_body_entered(body):
	is_hit = true
	health -= 1
	body.velocity.y = body.jump_speed * 0.75
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer,"animation_finished")
	is_hit = false
	if health < 1:
		queue_free()
		get_node("hitbox/hitbox_collision").set_deferred("disabled", true)
