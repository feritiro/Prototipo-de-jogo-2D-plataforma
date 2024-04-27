extends StaticBody2D



func _on_ArenaTrigger_PlayerEntered():
	$barrier.disabled = false
	$barrier2.disabled = false
	$EnemyBarrier/enemy_barrier_col.disabled = true

func _on_SkeletonSeeker_BossDead():
	queue_free()


func _on_EvilWizard_BossDead():
	queue_free()


func _on_Necromancer_BossDead():
	queue_free()
