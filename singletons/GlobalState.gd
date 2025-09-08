# GlobalState.gd
extends Node

signal health_changed(new_value: int)
signal litter_counter_changed(new_value: int)
signal control_player_changed
signal final_trigger

var _health: int = 3
var _litter_counter: int = 0

var _player_control_active = true
var toad_talked = false
var mountain_talked = false


var player_control_active: bool:
	set(value):
		_player_control_active = value
		emit_signal("control_player_changed", _player_control_active)
	get:
		return _player_control_active

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
	self.player_control_active = true

func reset_health():
	self.health = 3


func increment_litter(amount: int = 1):
	litter_counter += amount


func toad_finished()-> void:
	activate_controls()
	toad_talked = true


func end_game()-> void:
	get_tree().change_scene_to_file("res://scenes/final.tscn")

func activate_controls() -> void:
	player_control_active = true

func emit_final_trigger() -> void:
	emit_signal("final_trigger")
