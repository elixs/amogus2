extends CharacterBody2D

@onready var move_timer = $MoveTimer
@onready var label = $Label

@export var message = "meh"
@onready var gpu_particles_2d = $GPUParticles2D



var moving = false
var move_direction = 0

const SPEED = 50
const GRAVITY = 150
@onready var sprite_2d = $Sprite2D


var highlight = false:
	set(value):
		highlight = value
		if highlight:
			sprite_2d.scale = Vector2.ONE * 1.5
		else:
			sprite_2d.scale = Vector2.ONE 




func _ready():
	move_timer.timeout.connect(_on_move_timer)
	label.visible = false
	label.text = message


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	velocity.x = move_direction * SPEED
	move_and_slide()

func _on_move_timer():
	if moving:
		move_direction = 0
	else:
		move_direction = 1 if randi() % 2 else -1
	moving = !moving
	move_timer.start(randf_range(0, 3))


func talk():
	print("talk")
	if label.visible:
		return
	label.visible = true
	gpu_particles_2d.emitting = true
	await get_tree().create_timer(1).timeout
	label.visible = false
	
