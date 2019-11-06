extends Node2D

onready var sp = $Sprite
onready var tw = $Tween

func add(num):
	sp.frame = num
	tw.interpolate_property(
		sp, 
		"scale", 
		Vector2(0, 0), 
		Vector2(1.1,1.1), 
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	tw.start()
	
	yield(tw, "tween_all_completed")
	queue_free()
