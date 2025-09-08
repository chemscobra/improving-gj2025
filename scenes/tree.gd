extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GlobalState.litter_counter >= 6:
			GlobalState.player_control_active = false
			Dialogic.start_timeline("worthy")
		else:
			GlobalState.player_control_active = false
			Dialogic.start_timeline("not_worthy")
