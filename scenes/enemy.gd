class_name Enemy

extends CharacterBody2D

@export var Bullet: PackedScene

@onready var bullet_spawn = $BulletSpawn
@onready var detection_area = $DetectionArea

var target: Player = null
var bullet_cooldown_max = 0.5
var bullet_cooldown_time = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 10

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
	bullet_cooldown_time += delta
	if(target and bullet_cooldown_time > bullet_cooldown_max):
		_fire()
		bullet_cooldown_time = 0


func take_damage():
	print("auch")
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE


func _fire():
	if not Bullet:
		return
	var bullet = Bullet.instantiate()
	add_sibling(bullet)
	bullet.global_position = bullet_spawn.global_position
	bullet.rotation = global_position.direction_to(target.global_position).angle()


func _on_body_entered(body: Node):
	if body is Player:
		target = body

func _on_body_exited(body: Node):
	if target == body:
		target = null
		
