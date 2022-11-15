extends Control

var life_size = 32

func on_change_life(player_health):
	$icon.rect_size.x = player_health * life_size
