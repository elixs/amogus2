extends ParallaxBackground

@onready var parallax_layer_5: ParallaxLayer = $ParallaxLayer5



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parallax_layer_5.motion_offset.x += delta * 10
