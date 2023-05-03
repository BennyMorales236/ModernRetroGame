extends CanvasLayer

func _ready():
	$Message.hide()
#	$HP.hide()

func _input(event):
	pass

func _process(delta):
	if Input.is_action_pressed("attack_button"):
		$TitleScreen.hide()
		$HP.show()

func update_HP(HP):
	$HP.text = str(HP) + "HP"

func show_HP():
	$HP.show()

func hide_HP():
	$HP.hide()

func show_titlescreen():
	$TitleScreen.show()

func hide_titlescreen():
	$TitleScreen.hide()

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
