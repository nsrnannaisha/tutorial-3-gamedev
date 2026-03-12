extends CharacterBody2D

@export var gravity = 1200.0
@export var walk_speed = 200
@export var jump_speed = -400
@onready var animplayer := $AnimatedSprite2D

const UP = Vector2(0,-1)

var jump_count = 0
var jump_max = 2
var is_hurt = false

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _get_input():	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		is_hurt = true
		velocity.x = 0
	else:
		is_hurt = false
		
	if jump_count < jump_max and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
	
	var direction := Input.get_axis("ui_left", "ui_right")
	var animation = "idle"
	if direction:
		animation = "walk right"
		velocity.x = direction * walk_speed
		if direction>0:
			animplayer.flip_h = false
		else:
			animplayer.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	animplayer.play(animation)
	
	move_and_slide()
	
	update_animation()

func update_animation():
	if is_hurt:
		animplayer.play("hurt")
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
	animplayer.play("win")

func _physics_process(delta: float) -> void:
	velocity.y += delta*gravity
	_get_input()
	move_and_slide()
