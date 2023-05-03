extends KinematicBody2D

signal HP_changed
signal has_died

var velocity = Vector2()# The player's movement vector.
var screen_size

export var speed = 90
export var base_health = 5
export var base_attack = 1

var current_speed = speed
var current_health = base_health
var current_attack = base_attack

var is_attacking = false
var is_alive = true

var player_general_direction = "idle_down"
var walking_direction = "walk_down"
var attack_direction = "attack_down"

# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size not used
	#screen_size = get_viewport_rect().size
	pass

func _physics_process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	if is_alive:
		if Input.is_action_pressed("move_right") && is_attacking == false:
			velocity.x += 1
			player_general_direction = "idle_right"
			walking_direction = "walk_right"
			attack_direction = "attack_right"
		if Input.is_action_pressed("move_left") && is_attacking == false:
			velocity.x -= 1
			player_general_direction = "idle_left"
			walking_direction = "walk_left"
			attack_direction = "attack_left"
		if Input.is_action_pressed("move_down") && is_attacking == false:
			velocity.y += 1
			player_general_direction = "idle_down"
			walking_direction = "walk_down"
			attack_direction = "attack_down"
		if Input.is_action_pressed("move_up") && is_attacking == false:
			velocity.y -= 1
			player_general_direction = "idle_up"
			walking_direction = "walk_up"
			attack_direction = "attack_up"
	
	if velocity.length() > 0 && is_alive:
		velocity = velocity.normalized() # * current_speed
		velocity = move_and_slide(velocity * current_speed)
		$AnimatedSprite.play(walking_direction)
	else:
#		$AnimatedSprite.frame = 0
		if is_attacking == false:
			$AnimatedSprite.play(player_general_direction)
	
	if Input.is_action_just_pressed("attack_button") && is_alive:
		$AnimatedSprite.play(attack_direction)
		is_attacking = true
		if attack_direction == "attack_up":
			$AttackHitBox/StandardAttackUp.set_deferred("disabled", false)
		if attack_direction == "attack_down":
			$AttackHitBox/StandardAttackDown.set_deferred("disabled", false)
		if attack_direction == "attack_left":
			$AttackHitBox/StandardAttackLeft.set_deferred("disabled", false)
		if attack_direction == "attack_right":
			$AttackHitBox/StandardAttackRight.set_deferred("disabled", false)
	
	
	# 'position' is the actual position of the character. clamp prevents character from leaving the parameters, in this case screen.
	#position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == attack_direction:
		if attack_direction == "attack_up":
			$AttackHitBox/StandardAttackUp.set_deferred("disabled", true)
		if attack_direction == "attack_down":
			$AttackHitBox/StandardAttackDown.set_deferred("disabled", true)
		if attack_direction == "attack_left":
			$AttackHitBox/StandardAttackLeft.set_deferred("disabled", true)
		if attack_direction == "attack_right":
			$AttackHitBox/StandardAttackRight.set_deferred("disabled", true)
		is_attacking = false


func _on_HurtBox_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
#		current_health -= area.get_parent().current_attack
		modulate = Color(1,0,0)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = Color(1,1,1)
		emit_signal("HP_changed")
		if current_health <= 0:
			current_health = 0
			is_alive = false
			emit_signal("HP_changed")
			emit_signal("has_died")
			# Must be deferred as we can't change physics properties on a physics callback.
			$CollisionShape2D.set_deferred("disabled", true)
			$HurtBox/CollisionShape2D2.set_deferred("disabled",true)
			$DetectionBox/CollisionShape2D2.set_deferred("disabled",true)
