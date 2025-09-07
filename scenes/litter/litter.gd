extends Node2D

@export var offset_s: float = 20.0       # How far up/down (pixels)
@export var duration: float = 1.0      # Duration for each leg

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

@export var regions: Array[Rect2] = [
	Rect2(3525.0,  3181.0, 518.0, 355.0),
	Rect2(4602.0, 3188.0, 517.0, 355.0),
	Rect2(3602.0,  3908.0, 431.0, 620.0),
	Rect2(4717.0,  3762.0, 285.0, 798.0),
	Rect2(3431.0,  4800.0, 806.0, 561.0),
	Rect2(4519.0,  4735.0, 677.0, 702.0),
]

func _ready() -> void:
	sprite.region_filter_clip_enabled = true
	sprite.region_rect = regions.pick_random()
	start_up_down_tween()

func start_up_down_tween() -> void:
	var start_y := position.y
	var up_y := start_y - offset_s
	
	var t := create_tween().set_loops()  # infinite
    # Go up, then back to the start. Next loop starts already at start_y → no snap.
	t.tween_property(self, "position:y", up_y,    duration).from(start_y)
	t.tween_property(self, "position:y", start_y, duration).from(up_y)


func _on_area_2d_area_entered(_area:Area2D) -> void:
	if _area.is_in_group("player"):
		GlobalState.increment_litter(1)
		queue_free()
