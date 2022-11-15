extends KinematicBody2D
onready var player = Global.get("player")
onready var ray_cast = $RayCast2D
onready var cooldown_time = $Timer
var projectile_scene = preload("res://KinematicProjectile.tscn")
var can_fire = true

var rotation_speed = PI

func _physics_process(delta): #fazer calculos somente se estiver dentro do ray cast
	var v = player.global_position - global_position
	var angle = v.angle()
	var r = global_rotation
	var angle_delta = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r+ angle_delta)
	global_rotation = angle
	
	if can_fire and ray_cast.is_colliding():
		spawn_projectile()
		can_fire = false
		cooldown_time.start()
		
func spawn_projectile():
	var direction = Vector2.RIGHT.rotated(global_rotation)
	var projectile = projectile_scene.instance()
	projectile.direction = direction
	projectile.global_position = ray_cast.global_position
	projectile.add_collision_exception_with(self)
	add_child(projectile)
	


func _on_Timer_timeout():
	can_fire = true
