extends Node

@onready var player: CharacterBody2D = get_parent() as CharacterBody2D


func _ready() -> void:
	if player == null:
		push_error("WallJumpComponent must be a child of a CharacterBody2D node.")
		assert(false, "Error: WallJumpComponent must be a child of a CharacterBody2D node.")