extends KinematicBody2D

onready var bullet_scene = preload("res://Scenes/GhostProjectile.tscn")


func splash_fire():
	var bullet = [null,null,null,null,null,null,null,null,null,null]
	var angle = 360/10
	for i in range(10):
		bullet[i] = bullet_scene.instance()
		bullet[i].direction = Vector2.RIGHT.rotated(36*i)
		bullet[i].global_position = global_position
		get_tree().get_root().add_child(bullet[i])

func fire():
	var bullet = bullet_scene.instance()
	bullet.direction = ($Node2D/Position2D.global_position - global_position).normalized()
	bullet.global_position = $Node2D/Position2D.global_position
	get_tree().get_root().add_child(bullet)
	
func _ready():
	$Timer.start(1)

func _on_Timer_timeout():
#	fire()
#	$Timer.start(0.15)
	splash_fire()
	$Timer.start(1)
