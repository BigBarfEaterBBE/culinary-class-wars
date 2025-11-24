extends ParallaxBackground
@export var scroll_speed = -5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_base_offset.x -= scroll_speed * delta
	
