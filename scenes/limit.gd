extends Area2D


func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().global_position = GlobalState.checkpoint_position
# 		get_tree().call_deferred("reload_current_scene")
