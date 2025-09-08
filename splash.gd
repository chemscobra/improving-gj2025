extends Node2D

@export var fade_duration: float = 2.0
@export var target_scale: Vector2 = Vector2(0.7,0.7)
@export var next_scene_path: String = "res://ruta/a/tu_escena.tscn"

func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property($LosCarpinchos, "modulate:a", 1.0, fade_duration)
	tween.parallel().tween_property($LosCarpinchos, "scale", target_scale, fade_duration)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
