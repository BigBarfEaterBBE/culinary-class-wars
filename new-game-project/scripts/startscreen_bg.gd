extends TextureRect
@export var scroll_speed:float = 10.0
@export var texture_path: String = "res://assets/startscreen_bg.png"
var current_uv_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if material == null:
		material = CanvasItemMaterial.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance_moved = scroll_speed * delta
	var uv_scroll_amount = distance_moved / texture.get_width()
	current_uv_offset.x -= uv_scroll_amount
	current_uv_offset.x = fmod(current_uv_offset.x,1.0)
	material.scroll_base_offset = current_uv_offset
