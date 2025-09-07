# GlobalState.gd
extends Node

signal health_changed(new_value: int)
signal litter_counter_changed(new_value: int)

var _health: int = 3
var _litter_counter: int = 0


var health: int:
	set(value):
		_health = max(0, value)  # Prevent negative health
		emit_signal("health_changed", _health)
	get:
		return _health


var litter_counter: int:
	set(value):
		_litter_counter = max(0, value)
		emit_signal("litter_counter_changed", _litter_counter)
	get:
		return _litter_counter

var checkpoint_position: Vector2 = Vector2(-999, -999)
var previous_checkpoint_node: Node2D = null

func reset_counters():
	checkpoint_position = Vector2(118.0, 200)
	previous_checkpoint_node = null
	self.health = 3
	self.litter_counter = 0

func reset_health():
	self.health = 3


func increment_litter(amount: int = 1):
	litter_counter += amount
