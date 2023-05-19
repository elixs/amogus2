extends Node2D

@export var enemy_scene: PackedScene
@export var limits: Vector2
@onready var timer = $Timer



var enemies: Node2D

func _ready():
	timer.timeout.connect(_spawn_enemy)


func _spawn_enemy():
	if !enemies:
		return
	var enemy = enemy_scene.instantiate()
	var window_size =  get_viewport_rect().size
	var rand_x = 0
	var rand_y = 0
	if randi() % 2:
		# top / down
		rand_x = global_position.x +  randf_range(-limits.x / 2 - window_size.x / 2 ,window_size.x / 2 + limits.x / 2)
		rand_y = global_position.y + ((randi() % 2) * 2 - 1) * (window_size.y / 2 + limits.y / 2)
	else:
		# left / right
		rand_y = global_position.y +  randf_range(-limits.y / 2 - window_size.y / 2 ,window_size.y / 2 + limits.y / 2)
		rand_x = global_position.x + ((randi() % 2) * 2 - 1) * (window_size.x / 2 + limits.x / 2)
	
	
	# position
	enemies.add_child(enemy)
	enemy.global_position = Vector2(rand_x, rand_y)
	
	
