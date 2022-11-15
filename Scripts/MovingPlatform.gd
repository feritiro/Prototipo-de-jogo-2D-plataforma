extends Node2D

export var speed = 3
export var direction = 1
export var distance = 192
export var horizontal = true

var follow = Vector2.ZERO

const WAIT_DURATION = 3.0

func _ready():
	_start_tween()

func _start_tween():
	var move_direction = direction * Vector2.RIGHT * distance if horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(speed * 16)
	$Tween.interpolate_property(self, "follow", Vector2.ZERO, move_direction, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, WAIT_DURATION )
	$Tween.interpolate_property(self, "follow", move_direction, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + 2 * WAIT_DURATION )
	
	$Tween.start()
	
func _physics_process(_delta: float) -> void:
	$moving_platform.position = $moving_platform.position.linear_interpolate(follow, 0.05)
	
	
	
