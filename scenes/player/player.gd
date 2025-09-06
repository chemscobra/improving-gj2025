extends CharacterBody2D

@onready var area: Area2D = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	animation_player.play("HitFlash")



func _physics_process(delta: float) -> void:
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
		apply_knockback(direction, 300.0, 0.2)
		if GlobalState.health <= 0:
			get_tree().reload_current_scene()
