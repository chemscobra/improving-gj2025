extends Node2D

@onready var  animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		GlobalState.checkpoint_position = $Marker2D.global_position
		if GlobalState.previous_checkpoint_node:
			GlobalState.previous_checkpoint_node.update_sprite()
		GlobalState.previous_checkpoint_node = self
		update_sprite()
	

func update_sprite() -> void:
	audio_player.play()
	animation_player.play("Enable")
# 	frame = !bool($Marker2D.global_position == GlobalState.checkpoint_position)
