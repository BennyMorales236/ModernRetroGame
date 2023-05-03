extends YSort

export(PackedScene) var stone_drone_scene

onready var player_start_position = $PlayerStartPosition
onready var stone_drone_position_1 = $StoneDronePosition1
onready var player = $Player


func _ready():
	$HUD.update_HP(player.current_health)
	player.position = player_start_position.position
	_create_enemy(stone_drone_scene, stone_drone_position_1)
	

func _process(delta):
	if Input.is_action_just_pressed("reset_button"):
		new_game()

func _create_enemy(enemy_scene, position):
	var enemy = enemy_scene.instance()
	add_child(enemy)
	enemy.position = position.position

func game_over():
	yield(get_tree().create_timer(1), "timeout")
	$HUD.show_game_over()
	yield(get_tree().create_timer($HUD/MessageTimer.wait_time), "timeout")
	get_tree().reload_current_scene()

func new_game():
	get_tree().reload_current_scene()


func _on_Player_HP_changed():
	$HUD.update_HP(player.current_health)

func _on_Player_has_died():
	game_over()
