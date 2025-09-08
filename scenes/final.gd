extends Control


func  _ready() -> void:
	GlobalState.final_trigger.connect(_tween_message)
	Dialogic.start_timeline("final_nero")

func _tween_message():
	var tween = create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($RichTextLabel, "modulate:a", 1.0, 1.0)
	tween.tween_property($Button, "modulate:a", 1.0, 1.0)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
