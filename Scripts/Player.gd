extends KinematicBody2D
onready var projectile_instance = preload("res://Scenes/Thunder_projectile.tscn")
onready var blinker = $Blinker
onready var hurtbox = $Hurtbox/hurtbox_collision
var speed = 100
var jump_speed = -200
var gravity = 400
var player_health = 3
var max_health = 3
#var max_mana = 100
#var mana = max_mana
#var mana_recovery = 2
var knockback_dir = 1
var knockback_power = 170
var move_direction = 1
var is_dead = false
var is_cutscene = false
var cutscene_state = 0
const whiten_duration = 0.15
const invincibily_duration = 1.5
var is_invincible = false
export (ShaderMaterial) var whiten_material
var velocity = Vector2.ZERO
export (float,0,1.0) var friction = 15
export (float,0,1.0) var acceleration = 30

enum state {IDLE, RUNNING, ROLLING, JUMP, FALL, ATTACK, THROW, HURT, DEATH, CUTSCENE}

var player_state = state.IDLE
signal change_life(player_health)
#signal change_mana(mana)

func _ready():
	Global.set("player",self)
	if (connect("change_life", get_parent().get_node("HUD/HBoxContainer/LifeHolder"),"on_change_life")) != OK:
		print("error on change_life")
	emit_signal("change_life",max_health)
#	connect("change_mana", get_parent().get_node("HUD/ManaHolder"),"on_change_mana")
#	emit_signal("change_mana",max_mana)
	
	position.x = Global.game_data.checkpoint_pos_x +50 #comentar para testar
	position.y = Global.game_data.checkpoint_pos_y
	Global.points = Global.temp_score	
		
func shoot():
	if move_direction == -1:
		$Position2D.position.x *= -1
	var projectile = projectile_instance.instance()
	get_parent().add_child(projectile)
	projectile.shot_speed = -300
	projectile.global_position = $Position2D.global_position
	projectile.direction = -move_direction
	
		
func get_input():
	var dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if dir != 0:	
		if dir > 0:
			move_direction = 1
		else:
			move_direction = -1

		velocity.x = move_toward(velocity.x, move_direction * speed, acceleration)
		knockback_dir = move_direction
		$CollisionShape2D.position.x = -5 * move_direction
		$Hitbox_Area2D.scale.x = move_direction
		$Hurtbox.scale.x = move_direction
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
			
func update_animation():
	if move_direction == (-1) and player_state != state.HURT:
		$Sprite.flip_h = true

	if move_direction == 1 and player_state != state.HURT:
		$Sprite.flip_h = false
		
	match(player_state):
		state.IDLE:
			$AnimationPlayer.play("Idle")
		state.RUNNING:
			$AnimationPlayer.play("Running")
		state.ROLLING: # DASH
			set_collision_mask_bit(1, false)
			set_collision_layer_bit(0,false)
			hurtbox.disabled = true
			$AnimationPlayer.play("Dashing")
			yield($AnimationPlayer,"animation_finished")
			hurtbox.disabled = false
			set_collision_mask_bit(1, true)
			set_collision_layer_bit(0,true)
			if not is_on_floor():
				velocity.x = 0
			player_state = state.IDLE
		state.JUMP:
			$AnimationPlayer.play("Jumping") 
		state.FALL:
			$AnimationPlayer.play("Fall")
		state.ATTACK:
			$AnimationPlayer.play("Attack")
			yield($AnimationPlayer,"animation_finished")
			player_state = state.IDLE
		state.HURT:
			$AnimationPlayer.play("Hurted")
			hurtbox.set_deferred("disabled",true)
			yield($AnimationPlayer,"animation_finished")
			hurtbox.set_deferred("disabled",false)
			player_state = state.IDLE
		state.THROW:
#			velocity.x = 0
			$AnimationPlayer.play("Lateral_Throw")
			yield($AnimationPlayer,"animation_finished")
			player_state = state.IDLE
		state.DEATH:
			$AnimationPlayer.play("Death")
			yield($AnimationPlayer, "animation_finished")
		state.CUTSCENE:
			if cutscene_state == 0:
				$AnimationPlayer.play("LongIdle")
				yield($AnimationPlayer, "animation_finished")
				cutscene_state = 1
			elif cutscene_state == 1:
				$AnimationPlayer.play("Final")
				yield($AnimationPlayer, "animation_finished")
			else:
				print("bug on final cutscene")
			
func _physics_process(delta):
	camera_bound_level()
	update_animation()

	if is_cutscene:
		velocity.x = move_toward(velocity.x, 0, friction)		
		player_state = state.CUTSCENE
	
	if is_dead:
		hurtbox.set_deferred("disabled",true)
		$AnimationPlayer.play("Death")
		yield($AnimationPlayer, "animation_finished")
		Global.current_level = get_parent().get_name()
#		queue_free()
		if Global.temp_checkpoint == true:
			Global.game_data.checkpoint_pos_x = Global.temp_checkpoint_pos_x
			Global.game_data.checkpoint_pos_y = Global.temp_checkpoint_pos_y
			Global.save_data()
			Global.temp_score = Global.points
		else:
			Global.points = 0
#			if get_tree().reload_current_scene() != OK: #quando level mt grande dah erro -> demora
#				print("Error on reload_current_scene")
		queue_free()
		if get_tree().change_scene("res://Scenes/GameOver.tscn") != OK:
			print("Error on change_scene")

	if player_state != state.ROLLING and player_state != state.ATTACK and player_state != state.HURT and player_state != state.THROW and player_state != state.CUTSCENE:
		get_input()
		
		if velocity.x == 0:
			player_state = state.IDLE
		elif velocity.x !=0 and Input.is_action_just_pressed("dash") and $DashDelayTimer.is_stopped():
			$dash_sfx.play()
			player_state = state.ROLLING
			if is_on_floor():
				$DashDelayTimer.wait_time = 0.6
			else:
				$DashDelayTimer.wait_time = 1
			$DashDelayTimer.start()
			velocity.x = 2.5 * velocity.x
		elif velocity.x != 0 and player_state != state.HURT:
			player_state = state.RUNNING
		
#		if Input.is_action_just_pressed("ui_throw_lateral"):# somente ataca apos rolling
#			player_state = state.THROW

#		if is_on_floor() and player_state != state.ROLLING and Input.is_action_just_pressed("ui_attack"): # somente ataca apos rolling
#			player_state = state.ATTACK
				
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		$jump_sfx.play()
		player_state = state.JUMP
		
	if Input.is_action_just_pressed("throw_lateral"):
		player_state = state.THROW

	if  Input.is_action_just_pressed("attack"):
		if player_state != state.ATTACK:
			$fire_slash_sfx.play() 
		player_state = state.ATTACK
		
	if not is_on_floor() and player_state != state.HURT and player_state != state.THROW and player_state != state.ATTACK and player_state != state.ROLLING:
		if velocity.y < 0:
			player_state = state.JUMP
		else: 
			player_state = state.FALL
			
	if player_state == state.ATTACK or player_state == state.THROW :
		velocity.x = move_toward(velocity.x, 0, friction)
	
	if player_state == state.ROLLING and not is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity*delta
		
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Hitbox_Area2D_body_entered(_body):
	pass
#	body.health -= 3

	
func _on_Hitbox_Area2D_area_entered(_area):
	pass
		
func knockback():
	velocity.x = -knockback_dir * knockback_power
#	velocity.y = -knockback_dir * knockback_power
	velocity = move_and_slide(velocity)
	
func start_invincibility(invincibility_duration):
	is_invincible = true
#	set_collision_mask_bit(1, false)
#	set_collision_layer_bit(0,false)
	hurtbox.set_deferred("disabled",true)
	yield(get_tree().create_timer(invincibility_duration), "timeout")
	hurtbox.set_deferred("disabled",false)
#	set_collision_mask_bit(1, true)
#	set_collision_layer_bit(0,true)
	is_invincible = false

func _on_Hurtbox_body_entered(_body):
#	return# god mode
	if not is_invincible:
		$hit_sfx.play()
		player_state = state.HURT
		knockback() #quando o player encosta no inimigo
		start_invincibility(invincibily_duration)
		blinker.start_blinking(self, invincibily_duration)
		whiten_material.set_shader_param("whiten", true)
		yield(get_tree().create_timer(whiten_duration), "timeout")
		whiten_material.set_shader_param("whiten", false)
	
		player_health -= 1
		emit_signal("change_life",player_health)
		if player_health < 1:
			is_dead = true
			player_state = state.DEATH
			$death_sfx.play()
		#gameOver()
		
func _on_Hurtbox_area_entered(_area):
#	return# god mode
	if not is_invincible:
		$hit_sfx.play()
		player_state = state.HURT
		start_invincibility(invincibily_duration)
		blinker.start_blinking(self, invincibily_duration)
		whiten_material.set_shader_param("whiten", true)
		yield(get_tree().create_timer(whiten_duration), "timeout")
		whiten_material.set_shader_param("whiten", false)
	
		player_health -= 1
		emit_signal("change_life",player_health)
		if player_health < 1:
			is_dead = true
			player_state = state.DEATH
			$death_sfx.play()
			
func hit_checkpoint():
	Global.temp_checkpoint_pos_x = position.x
	Global.temp_checkpoint_pos_y = position.y 
	Global.temp_checkpoint = true
	Global.check_min = Global.minutes
	Global.check_sec = Global.seconds
	Global.temp_score = Global.points
	
func gameOver() -> void:
	if player_health < 1:
#		Global.current_level = get_parent().get_name()
		queue_free()
		if get_tree().change_scene("res://Scenes/GameOver.tscn") != OK:
			print("Error on change_scene")
			
func camera_bound_level():
	if get_parent().get_name() == "World6":
		$Camera2D.limit_bottom = 240	
		$Camera2D.limit_top = 24
		$Camera2D.limit_right = 384
		$Camera2D.limit_left = 0




func _on_ArenaTrigger_PlayerEntered():
	$Camera2D.current = false

#func _on_SkeletonSword_BossDead(): teste
#	$Camera2D.current = true

func _on_SkeletonSeeker_BossDead(): #boss lv.1
	$Camera2D.current = true


func _on_EvilWizard_BossDead(): # boss lv.2
	$Camera2D.current = true


func _on_Necromancer_BossDead(): #boss lv.4
	$Camera2D.current = true


func _on_CutsceneTrigger_TriggerCutscene(): #final cutscene
	is_cutscene = true



