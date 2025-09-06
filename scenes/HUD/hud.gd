extends CanvasLayer

@onready var hearts_full: TextureRect = $HeartsFull
@onready var litter_counter_label: Label = $Label

func _ready() -> void:
	GlobalState.health_changed.connect(load_hearts)
	GlobalState.litter_counter_changed.connect(update_litter_counter)
	load_hearts()

func load_hearts():
	if hearts_full == null:
		print("Hearts full not assigned in HUD")
		return
	var heart_count = GlobalState.health
	hearts_full.size = Vector2(heart_count * 64, 64)

func update_litter_counter(new_value: int) -> void:
	litter_counter_label.text = str(new_value)
