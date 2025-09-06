extends CanvasLayer

@export var hearts_full: TextureRect

func _ready() -> void:
	GlobalState.health_changed.connect(load_hearts)
	load_hearts()

func load_hearts():
	if hearts_full == null:
		print("Hearts full not assigned in HUD")
		return
	var heart_count = GlobalState.health
	hearts_full.size = Vector2(heart_count * 64, 64)
