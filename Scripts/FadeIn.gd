extends Control
func _ready():
	get_tree().paused = true
	$ColorRect/AnimationPlayer.play("fade_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().paused = false
