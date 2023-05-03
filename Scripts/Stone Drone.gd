extends KinematicBody2D

var velocity = Vector2()

export var speed = 30
var base_health = 2
var base_attack = 1

var current_speed = speed
var current_health = base_health
var current_attack = base_attack

var is_attacking = false
var target_body = null
var is_alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if is_attacking:
		velocity = position.direction_to(target_body.global_position) * current_speed
	velocity = move_and_slide(velocity)
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("PlayerHitBox"):
		current_health -= area.get_parent().current_attack
		modulate = Color(1,0,0)
		yield(get_tree().create_timer(0.1), "timeout")
		modulate = Color(1,1,1)
		if current_health <= 0:
			$CollisionShape2D.set_deferred("disabled", true)
			$HurtBox/CollisionShape2D2.set_deferred("disabled", true)
			$AttackHitBox/CollisionShape2D.set_deferred("disabled", true)
			$DetectionBox/CollisionShape2D.set_deferred("disabled", true)
			queue_free()



func _on_DetectionBox_area_entered(area):
	if area.is_in_group("PlayerDetectionBox"):
		is_attacking = true
		target_body = area
		$AttackHitBox/CollisionShape2D.set_deferred("disabled", false)


func _on_DetectionBox_area_exited(area):
	if area.is_in_group("PlayerDetectionBox"):
		is_attacking = false
		target_body = null
#	$DetectionBox/CollisionShape2D.set_deferred("disabled", false)
#	$AttackHitBox/CollisionShape2D.set_deferred("disabled", true)


func _on_AttackHitBox_area_entered(area):
	if area.is_in_group("PlayerHurtBox"):
		area.get_parent().current_health -= current_attack
		is_attacking = false
		target_body = null
		$DetectionBox/CollisionShape2D.set_deferred("disabled", true)
		$AttackHitBox/CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(1), "timeout")
		$DetectionBox/CollisionShape2D.set_deferred("disabled", false)
		$AttackHitBox/CollisionShape2D.set_deferred("disabled", false)
