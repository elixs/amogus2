class_name Player
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -110.0
const ACCELERATION = 1000
const GRAVITY = 150

const MAX_HEALTH = 100
var health = 100:
	set(value):
		health = value
		if health == 0:
			_death()
		hud.set_health(health)
	get:
		return health

var display_name = "meh":
	set(value):
		display_name = "meh" +  str(value)
		print(display_name)

var counter = 0:
	set(value):
		counter = value
		display_name = str(randi() % 101)
		hud.set_counter(counter)

var Enemy = preload("res://scenes/enemy.tscn")
@export var Bullet : PackedScene

@export var weapon: WeaponData

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
@onready var sprite_2d = $Pivot/Sprite2D

@onready var pickable_area = $PickableArea
@onready var coin_label = $CoinLabel


var talk_area_array = []

var can_move = true

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
	pickable_area.area_entered.connect(_on_area_entered)
	_update_coins()


func _input(event):
	if event.is_action_pressed("test"):
		counter += 1
	if event.is_action_pressed("save"):
#		save_data()
		save_config()
	if event.is_action_pressed("load"):
#		load_data()
		load_config()
	if event.is_action_pressed("resource"):
		var weapon = WeaponData.new()
		weapon.name = "test"
		weapon.attack = 0
		weapon.level = 100
		ResourceSaver.save(weapon, "res://resources/test.tres")
		

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		jumps = 0
	
	if can_move and Input.is_action_just_pressed("jump"):

		if ray_cast_2d.is_colliding():
			audio_stream_player.play()
			jump_time = 0
		elif jumps < MAX_JUMPS - 1:
			Game.jumps += 1
			jumps += 1
			audio_stream_player.play()
			jump_time = 0
	#		velocity.y = JUMP_VELOCITY
	
	if can_move and Input.is_action_pressed("jump") and jump_time < MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY * (MAX_JUMP_TIME - jump_time)/MAX_JUMP_TIME
	
	jump_time += delta
	

	
	var move_input = Input.get_axis("move_left", "move_right")
	
	if not can_move:
		move_input = 0
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
	if not can_move:
		return
	
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


func _death():
	can_move = false
	playback.call_deferred("travel", "death")
	
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2.ONE * 1.5, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel()
	tween.tween_property(sprite_2d, "position", Vector2.DOWN * 10, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(sprite_2d, "modulate", Color(1, 1, 1, 0), 0.3)
	
	await get_tree().create_timer(3).timeout
	
	get_tree().reload_current_scene()


func _on_area_entered(area):
	var coin = area as Coin
	if coin:
		coin.queue_free()
		Game.coins += 1
		_update_coins()


func _update_coins():
	coin_label.text = str(Game.coins)


func save_data():
	var data = {
		"counter": counter
	}
#	var file = FileAccess.open("user://data.json", FileAccess.WRITE)
#	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.WRITE, "meh")
	var file = FileAccess.open("user://data.binary", FileAccess.WRITE)

#	file.store_string(JSON.stringify(data))
	file.store_var(counter)
	file.store_var(display_name)


func load_data():	
#	var file = FileAccess.open("user://data.json", FileAccess.READ)
#	var file = FileAccess.open_encrypted_with_pass("user://data.save", FileAccess.READ, "meh")
	var file = FileAccess.open("user://data.binary", FileAccess.READ)

#	var data = JSON.parse_string(file.get_as_text())
#	counter = data.counter

	counter = file.get_var()
	display_name = file.get_var()


func save_config():
	var config_file = ConfigFile.new()
	config_file.set_value("settings", "language", Game.language)
	config_file.save("user://config.cfg")


func load_config():
	var config_file = ConfigFile.new()
	config_file.load("user://config.cfg")
	var language = config_file.get_value("settings", "language")
	print(language)
