extends CanvasLayer

func _ready():
	$Message.hide()

func _input(event):
	pass

func _process(delta):
	pass

func update_HP(HP):
	$HP.text = str(HP) + "HP"

func show_HP():
	$HP.show()

func hide_HP():
	$HP.hide()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	# get_node("/root/Game")

func _on_MessageTimer_timeout():
	$Message.hide()
