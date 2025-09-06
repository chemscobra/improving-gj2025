extends CanvasLayer

@onready var hearts_full: TextureRect = $HeartsFull
@onready var litter_counter_label: Label = $Label

func _ready() -> void:
	GlobalState.health_changed.connect(load_hearts)
	GlobalState.reset_health()
	GlobalState.litter_counter_changed.connect(update_litter_counter)


func load_hearts(new_health: int):
	hearts_full.size = Vector2(new_health * 64, 64)

func update_litter_counter(new_value: int) -> void:
	litter_counter_label.text = str(new_value)
