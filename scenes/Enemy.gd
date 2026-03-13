extends CharacterBody2D

var direction = 1.0
var speed = 80.0
var gravity = 1200.0
var patrol_distance = 100.0
var start_x
var is_dead = false
var is_attacking = false
var is_idle = true  # tambah ini

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer
@onready var enemy_area = $EnemyArea

func _ready():
	start_x = global_position.x
	anim.play("idle")
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	enemy_area.body_entered.connect(_on_body_entered)

func _on_timer_timeout():
	if is_dead:
		return
	is_idle = false
	while not is_dead:
		is_attacking = false
		await get_tree().create_timer(1.0).timeout
		if is_dead:
			return
		is_attacking = true
		await get_tree().create_timer(1.0).timeout
		if is_dead:
			return

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_idle:  # diam selama idle
		velocity.x = 0
		anim.play("idle")
		move_and_slide()
		return

	if not is_attacking:
		velocity.x = speed * direction
		anim.flip_h = direction < 0
		anim.play("walk right")
		if global_position.x > start_x + patrol_distance:
			direction = -1.0
		elif global_position.x < start_x - patrol_distance:
			direction = 1.0
	else:
		velocity.x = 0
		anim.play("attack")

	move_and_slide()

func _on_body_entered(body):
	if body.name == "Player" and not is_dead:
		body.lose()
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()

func die():
	if is_dead:
		return
	is_dead = true
	timer.stop()
	velocity = Vector2.ZERO
	is_attacking = false
	anim.play("dead")
	await anim.animation_finished
	queue_free()
