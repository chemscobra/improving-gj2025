extends Node

@onready var player: CharacterBody2D = get_parent() as CharacterBody2D


@export var max_run_speed: float = 180.0
@export var acceleration: float = 200.0
@export var deceleration: float = 250.0


func _ready() -> void:
	if player == null:
		push_error("RunComponent must be a child of a CharacterBody2D node.")
		assert(false, "Error: RunComponent must be a child of a CharacterBody2D node.")
		

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dir: Vector2 = Vector2(x_input, 0)
	var velocity_weight: float = delta * (acceleration if x_input else deceleration)
	# use move_toward to smoothly change the velocity
	player.velocity = player.velocity.move_toward(dir * max_run_speed, velocity_weight)
	player.move_and_slide()