extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0
const ACCELERATION = 1000
const GRAVITY = 150

var Enemy = preload("res://scenes/enemy.tscn")

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot

@onready var camera = $Camera
@onready var camera_zoom = $CameraZoom

func _ready():
	animation_tree.active = true
#	camera.enabled = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("spawn"):
		_spawn()
	
	# animation
	
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	
	if move_input:
		pivot.scale.x = sign(move_input)


#func _input(event):
#	if event.is_action_pressed("camera"):
#		camera.enabled = !camera.enabled
#		camera_zoom.enabled = !camera_zoom.enabled


func _spawn():
	var enemy = Enemy.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = get_global_mouse_position()
