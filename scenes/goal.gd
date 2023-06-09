extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_player_entered)


func _on_player_entered(player: Player):
	LevelManager.next_level()
