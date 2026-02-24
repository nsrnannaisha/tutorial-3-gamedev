extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -300

@onready var anim := $AnimatedSprite2D

var jump_count = 0
var jump_max = 2
var is_hurt = false

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	velocity.y += delta * gravity
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		is_hurt = true
		velocity.x = 0
	else:
		is_hurt = false
		
	if jump_count < jump_max and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  walk_speed
		anim.flip_h = false
	else:
		velocity.x = 0
		
	move_and_slide()
	
	update_animation()

func update_animation():
	if is_hurt:
		anim.play("hurt")
		return
		
	if is_on_floor():
		if velocity.x == 0:
			anim.play("idle")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			anim.play("jump")
		else: 
			anim.play("fall")
