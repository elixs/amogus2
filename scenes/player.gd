class_name Player
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
@export var Bullet : PackedScene

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot

@onready var camera = $Camera
@onready var camera_zoom = $CameraZoom

@onready var audio_stream_player = $AudioStreamPlayer
@onready var area_2d = $Pivot/Area2D

@onready var hud = $CanvasLayer/HUD
@onready var ray_cast_2d = $Pivot/RayCast2D

@onready var talk_area = $Pivot/TalkArea
@onready var bullet_spawn = $Pivot/BulletSpawn


var talk_area_array = []



const MAX_JUMPS = 3
var jumps = 0:
	set(value):
		jumps = value
		hud.set_jumps(jumps)

const MAX_JUMP_TIME = 1
var jump_time = 0


func _ready():
	animation_tree.active = true
	camera.enabled = true
	area_2d.body_entered.connect(_on_body_entered)
	jumps = jumps
	talk_area.body_entered.connect(_on_talk_entered)
	talk_area.body_exited.connect(_on_talk_exited)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		jumps = 0
	
	if Input.is_action_just_pressed("jump"):

		if ray_cast_2d.is_colliding():
			audio_stream_player.play()
			jump_time = 0
		elif jumps < MAX_JUMPS - 1:
			Game.jumps += 1
			jumps += 1
			audio_stream_player.play()
			jump_time = 0
	#		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("jump") and jump_time < MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY * (MAX_JUMP_TIME - jump_time)/MAX_JUMP_TIME
	
	jump_time += delta
	

	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("spawn"):
		_spawn()
	
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	if Input.is_action_just_pressed("fire"):
		_fire()
		
	if Input.is_action_just_pressed("interact"):
		if talk_area_array.size():
			var closest = talk_area_array[0]
			var closest_distance = abs(closest.global_position.x - global_position.x)
			for body in talk_area_array:
				var body_distance = abs(body.global_position.x - global_position.x)
				if body_distance < closest_distance:
					closest = body
			if closest.has_method("talk"):
				closest.talk()
	
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


func _on_talk_entered(body: Node):
	talk_area_array.append(body)
	body.highlight = true


func _on_talk_exited(body: Node):
	if body in talk_area_array:
		talk_area_array.erase(body)
	body.highlight = false


func _fire():
	if not Bullet:
		return
	var bullet = Bullet.instantiate()
	add_sibling(bullet)
	bullet.global_position = bullet_spawn.global_position
	bullet.rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
