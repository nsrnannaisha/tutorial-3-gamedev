extends CharacterBody2D

@export var gravity = 1200.0
@export var walk_speed = 200
@export var jump_speed = -400
@onready var animplayer := $AnimatedSprite2D
@onready var sfx_default = $SpaceAudio
@onready var sfx_lose = $SFXLose
@onready var sfx_win = $SFXWin
@onready var sfx_attack = $SFXAttack

const UP = Vector2(0,-1)

var jump_count = 0
var jump_max = 2
var is_attacking = false

func _get_input():
	if Input.is_action_just_pressed("ui_accept"):
		_attack_enemy()

	if jump_count < jump_max and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * walk_speed
		if direction > 0:
			animplayer.flip_h = false
		else:
			animplayer.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

	update_animation()

func _attack_enemy():
	is_attacking = true
	animplayer.play("attack")
	sfx_attack.play()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < 550:
			enemy.die()
	await get_tree().create_timer(0.3).timeout
	is_attacking = false

func update_animation():
	if is_attacking:
		animplayer.play("attack")
		return

	if is_on_floor():
		if velocity.x == 0:
			animplayer.play("idle")
		else:
			animplayer.play("walk right")
	else:
		if velocity.y < 0:
			animplayer.play("jump")
		else:
			animplayer.play("fall")

func win():
	velocity = Vector2.ZERO
	set_physics_process(false)
	sfx_default.stop()
	sfx_win.play()
	animplayer.play("win")

func lose():
	velocity = Vector2.ZERO
	set_physics_process(false)
	sfx_lose.play()
	animplayer.play("hurt")
	
func _physics_process(delta: float) -> void:
	velocity.y += delta * gravity
	_get_input()
	move_and_slide()
