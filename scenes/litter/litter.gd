extends Sprite2D

@export var offset_s: float = 20.0       # How far up/down (pixels)
@export var duration: float = 1.0      # Duration for each leg

@onready var area: Area2D = $Area2D

func _ready() -> void:
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
