extends Control


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$ColorRect/AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Game.tscn")
