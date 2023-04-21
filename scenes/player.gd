extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0
const ACCELERATION = 1000
const GRAVITY = 150

const MAX_HEALTH = 100
var health = 100:
	set(value):
		health = value
		hud.set_health(health)
	get:
		return health

var Enemy = preload("res://scenes/enemy.tscn")

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot

@onready var camera = $Camera
@onready var camera_zoom = $CameraZoom

@onready var audio_stream_player = $AudioStreamPlayer
@onready var area_2d = $Pivot/Area2D

@onready var hud = $CanvasLayer/HUD

const MAX_JUMPS = 3
var jumps = 0

const MAX_JUMP_TIME = 1
var jump_time = 0


func _ready():
	animation_tree.active = true
	camera.enabled = true
	area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and jumps < MAX_JUMPS - 1:
		Game.jumps += 1
		audio_stream_player.play()
		jumps += 1
		jump_time = 0
#		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("jump") and jump_time < MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY * (MAX_JUMP_TIME - jump_time)/MAX_JUMP_TIME
	
	jump_time += delta
	
	if is_on_floor():
		jumps = 0
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("spawn"):
		_spawn()
	
	if Input.is_action_just_pressed("attack"):
		_attack()
	
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


func _attack():
	playback.call_deferred("travel", "attack")


func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage()
	if body is CharacterBody2D:
		var character = body as CharacterBody2D
		character.velocity = (character.global_position - global_position).normalized() * 300


func take_damage():
	if health <= 0:
		return
	health = max(health - 25, 0)
