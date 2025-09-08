extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !GlobalState.toad_talked:
			GlobalState.player_control_active = false
			Dialogic.start_timeline("timeline")
