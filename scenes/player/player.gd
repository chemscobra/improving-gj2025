extends CharacterBody2D

@onready var area: Area2D = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var audios: Array[AudioStreamPlayer]

@export var knockback_force: float = 130.0

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0



func _ready() -> void:
	GlobalState.control_player_changed.connect(stop_player)
	if GlobalState.checkpoint_position != Vector2(-999,-999):
		global_position = GlobalState.checkpoint_position

func stop_player(new_value:bool) -> void:
	if !new_value:
		animation_player.play("Idle")
		for audio in audios:
			audio.stop()
		velocity = Vector2.ZERO

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	animation_player.play("HitFlash")



func _physics_process(delta: float) -> void:
	if GlobalState.player_control_active:
		if knockback_timer > 0.0:
			velocity = knockback
			knockback_timer -= delta
			if knockback_timer <= 0.0:
				knockback = Vector2.ZERO

		move_and_slide()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("enemy") or _area.is_in_group("hazard"):
		GlobalState.health -= 1
		var direction = (global_position - _area.global_position).normalized()
		apply_knockback(direction, knockback_force, 0.2)
		if GlobalState.health <= 0:
			global_position = GlobalState.checkpoint_position
			GlobalState.reset_health()
# 			get_tree().call_deferred("reload_current_scene")
