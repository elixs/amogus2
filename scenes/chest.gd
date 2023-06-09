extends Area2D

var player_inside
@onready var icon: Sprite2D = $Icon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		print("· o ·)/")
		queue_free()

func _on_player_entered(player: Player):
	player_inside = true
	icon.modulate = Color.GREEN

func _on_player_exited(player: Player):
	player_inside = false
	icon.modulate = Color.WHITE
