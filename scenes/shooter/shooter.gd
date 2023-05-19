extends Node2D

@onready var spawner = $Player/Spawner
@onready var enemies = $Enemies



# Called when the node enters the scene tree for the first time.
func _ready():
	spawner.enemies = enemies


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
