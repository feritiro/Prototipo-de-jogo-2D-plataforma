extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var Mushroom = preload("res://Scenes/Mushroom.tscn")
var count = 0

func _on_SpawnTimer_timeout():
	count = count + 1
	if count == 5:
		$SpawnTimer.queue_free()
		$Spawn.queue_free()
	else:
		var mushroom = Mushroom.instance()
		mushroom.move_direction = 1
		add_child(mushroom)
		mushroom.position = $Spawn.position
