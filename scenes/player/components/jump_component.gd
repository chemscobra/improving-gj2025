# extends Node
# 
# @onready var player: CharacterBody2D = get_parent() as CharacterBody2D
# 
# @export var animation_player: AnimationPlayer
# @export var player_sprite: Sprite2D
# @export var jump_audio: AudioStreamPlayer
# @export var run_audio: AudioStreamPlayer
# 
# @export var max_jump_height: float = 130.0
# @export var max_jump_time: float = 0.5
# @export var max_fall_time: float = 0.3
# 
# # Use this as the horizontal push when wall-jumping (away from the wall).
# @export var wall_jump_velocity: float = 220.0
# 
# @export var coyote_time: float = 0.15
# var coyote_timer: float = 0.0
# 
# @export var jump_buffer_time: float = 0.15
# var jump_buffer_timer: float = 0.0
# 
# @export var max_run_speed: float = 180.0
# @export var acceleration: float = 900.0
# @export var deceleration: float = 1000.0
# 
# @export var wall_slide_speed: float = 120.0          # max downward speed while sliding
# @export var wall_coyote_time: float = 0.3           # grace after leaving wall
# var wall_coyote_timer: float = 0.0
# 
# @export var wall_jump_lock_time: float = 0.08        # brief lock to avoid re-grab
# var wall_jump_lock_timer: float = 0.0
# 
# var _jump_velocity: float
# var _jump_gravity: float
# var _fall_gravity: float
# 
# var look_dir_x: int = 1
# 
# func _ready() -> void:
# 	if player == null:
# 		push_error("JumpComponent must be a child of a CharacterBody2D node.")
# 		assert(false, "Error: JumpComponent must be a child of a CharacterBody2D node.")
# 	_calculate_jump_physics()
# 
# func _calculate_jump_physics() -> void:
# 	var v_0y: float = 2.0 * max_jump_height / max_jump_time
# 	var g_asc: float = 2.0 * max_jump_height / pow(max_jump_time, 2.0)
# 	var d_desc: float = 2.0 * max_jump_height / pow(max_fall_time, 2.0)
# 
# 	_jump_velocity = -v_0y
# 	_jump_gravity = g_asc
# 	_fall_gravity = d_desc
# 
# func _physics_process(delta: float) -> void:
# 	# --- Gravity (variable ascend/descend) ---
# 	var g: float = (_fall_gravity if player.velocity.y > 0.0 else _jump_gravity)
# 	player.velocity.y += g * delta
# 
# 	# --- Horizontal input & smoothing (unchanged) ---
# 	var x_input: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
# 	var dir: Vector2 = Vector2(x_input, 0.0)
# 	var velocity_weight: float = delta * (acceleration if x_input != 0.0 else deceleration)
# 	player.velocity = player.velocity.move_toward(dir * max_run_speed, velocity_weight)
# 	
# 	if x_input and player.is_on_floor():
# 		animation_player.play("Run")
# 		run_audio.play()
# 	elif player.is_on_floor():
# 		animation_player.play("Idle")
# 		run_audio.stop()
# 	
# 	if x_input:
# 		player_sprite.flip_h = (x_input < 0.0)
# 
# 	# Track facing (optional)
# 	if x_input != 0.0:
# 		look_dir_x = (1 if x_input > 0.0 else -1)
# 
# 	# --- Floor coyote + variable jump cut ---
# 	if player.is_on_floor():
# 		coyote_timer = coyote_time
# 	else:
# 		coyote_timer -= delta
# 		if Input.is_action_just_released("jump") or player.is_on_ceiling():
# 			player.velocity.y *= 0.6
# 
# 	# --- Jump buffer ---
# 	if Input.is_action_just_pressed("jump"):
# 		jump_buffer_timer = jump_buffer_time
# 	else:
# 		jump_buffer_timer -= delta
# 
# 	# ==== NEW: Wall detection, slide, and coyote ====
# 	var on_wall: bool = player.is_on_wall() and not player.is_on_floor()
# 	# Use previous frame's wall normal; it's valid in physics after a slide move
# 	var wall_normal: Vector2 = player.get_wall_normal() if on_wall else Vector2.ZERO
# 
# 	# Convert to integer signs for comparisons
# 	var x_dir: int = (1 if x_input > 0.0 else (-1 if x_input < 0.0 else 0))
# 	var wall_side: int = (1 if wall_normal.x > 0.0 else (-1 if wall_normal.x < 0.0 else 0))  # +1 = wall on left, -1 = wall on right
# 	var pressing_toward_wall: bool = on_wall and x_dir != 0 and x_dir == -wall_side
# 
# 	# Start/consume wall coyote
# 	if on_wall and wall_jump_lock_timer <= 0.0:
# 		wall_coyote_timer = wall_coyote_time
# 	else:
# 		wall_coyote_timer -= delta
# 
# 	# Wall slide: slow the fall when holding toward the wall
# 	if on_wall and wall_jump_lock_timer <= 0.0 and player.velocity.y > 0.0 and pressing_toward_wall:
# 		player.velocity.y = min(player.velocity.y, wall_slide_speed)
# 
# 	# Short lockout after wall jump to prevent instant re-grab
# 	if wall_jump_lock_timer > 0.0:
# 		wall_jump_lock_timer -= delta
# 	# =================================================
# 
# 	# --- Resolve buffered jump: ground first, then wall ---
# 	if jump_buffer_timer > 0.0:
# 		if (coyote_timer > 0.0) or player.is_on_floor():
# 			# Normal jump
# 			run_audio.stop()
# 			player.velocity.y = _jump_velocity
# 			animation_player.play("Jump")
# 			jump_audio.play()
# 			jump_buffer_timer = 0.0
# 			coyote_timer = 0.0
# 		elif wall_coyote_timer > 0.0:
# 			# Wall jump: up + away from wall
# 			var away_from_wall_x: float = wall_normal.x
# 			if away_from_wall_x == 0.0:
# 				# Fallback if normal is zero this frame
# 				away_from_wall_x = float(-x_dir if x_dir != 0 else -look_dir_x)
# 				
# 				player_sprite.flip_h = (x_dir > 0.0)
# 
# 			player.velocity.y = _jump_velocity
# 			animation_player.play("Jump")
# 			jump_audio.play()
# 			player.velocity.x = away_from_wall_x * wall_jump_velocity
# 			
# 			
# 			jump_buffer_timer = 0.0
# 			wall_coyote_timer = 0.0
# 			coyote_timer = 0.0
# 			wall_jump_lock_timer = wall_jump_lock_time
# 	
# 	if is_equal_approx(player.velocity.y, 0.0) and not player.is_on_floor():
# 		animation_player.play("Peak")
# 	
# 	if player.velocity.y > 0.0 and not player.is_on_floor() and not player.is_on_wall():
# 		animation_player.play("Fall")
# 	
# 	if player.is_on_wall():
# 		animation_player.play("Climb")
# 
# 	player.move_and_slide()

extends Node

@onready var player: CharacterBody2D = get_parent() as CharacterBody2D

@export var animation_player: AnimationPlayer
@export var player_sprite: Sprite2D
@export var jump_audio: AudioStreamPlayer
@export var run_audio: AudioStreamPlayer

@export var max_jump_height: float = 130.0
@export var max_jump_time: float = 0.5
@export var max_fall_time: float = 0.3
@export var wall_jump_velocity: float = 220.0

@export var coyote_time: float = 0.15
var coyote_timer: float = 0.0

@export var jump_buffer_time: float = 0.15
var jump_buffer_timer: float = 0.0

@export var max_run_speed: float = 180.0
@export var acceleration: float = 900.0
@export var deceleration: float = 1000.0

@export var wall_slide_speed: float = 120.0
@export var wall_coyote_time: float = 0.3
var wall_coyote_timer: float = 0.0

@export var wall_jump_lock_time: float = 0.08
var wall_jump_lock_timer: float = 0.0

# --- NUEVO: pequeño lock de animación tras saltar ---
@export var anim_jump_lock_time: float = 0.12
var anim_lock_timer: float = 0.0

var _jump_velocity: float
var _jump_gravity: float
var _fall_gravity: float

var look_dir_x: int = 1

func _ready() -> void:
	if player == null:
		push_error("JumpComponent must be a child of a CharacterBody2D node.")
		assert(false, "Error: JumpComponent must be a child of a CharacterBody2D node.")
	_calculate_jump_physics()

func _calculate_jump_physics() -> void:
	var v_0y: float = 2.0 * max_jump_height / max_jump_time
	var g_asc: float = 2.0 * max_jump_height / pow(max_jump_time, 2.0)
	var d_desc: float = 2.0 * max_jump_height / pow(max_fall_time, 2.0)
	_jump_velocity = -v_0y
	_jump_gravity = g_asc
	_fall_gravity = d_desc

func _physics_process(delta: float) -> void:
	# timers
	if wall_jump_lock_timer > 0.0:
		wall_jump_lock_timer -= delta
	if anim_lock_timer > 0.0:
		anim_lock_timer -= delta

	# --- input + física ---
	var x_input: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dir: Vector2 = Vector2(x_input, 0.0)
	var velocity_weight: float = delta * (acceleration if x_input != 0.0 else deceleration)

	# Gravedad
	var g: float = (_fall_gravity if player.velocity.y > 0.0 else _jump_gravity)
	player.velocity.y += g * delta

	# Horizontal
	player.velocity = player.velocity.move_toward(dir * max_run_speed, velocity_weight)

	# Mirada
	if x_input != 0.0:
		look_dir_x = (1 if x_input > 0.0 else -1)
		player_sprite.flip_h = (x_input < 0.0)

	# Coyote suelo + corte de salto
	if player.is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
		if Input.is_action_just_released("jump") or player.is_on_ceiling():
			player.velocity.y *= 0.6

	# Buffer de salto
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# ¡Mueve primero para que is_on_wall/get_wall_normal sean fiables!
	player.move_and_slide()

	# Datos de pared tras mover
	var on_floor := player.is_on_floor()
	var on_wall := player.is_on_wall() and not on_floor
	var wall_normal: Vector2 = player.get_wall_normal() if on_wall else Vector2.ZERO
	var x_dir: int = (1 if x_input > 0.0 else (-1 if x_input < 0.0 else 0))
	var wall_side: int = (1 if wall_normal.x > 0.0 else (-1 if wall_normal.x < 0.0 else 0))  # +1 pared izq, -1 pared der
	var pressing_toward_wall := on_wall and x_dir != 0 and x_dir == -wall_side

	# Coyote de pared
	if on_wall and wall_jump_lock_timer <= 0.0:
		wall_coyote_timer = wall_coyote_time
	else:
		wall_coyote_timer -= delta

	# Wall slide
	if on_wall and wall_jump_lock_timer <= 0.0 and player.velocity.y > 0.0 and pressing_toward_wall:
		player.velocity.y = min(player.velocity.y, wall_slide_speed)

	# --- Resolver salto con prioridad (y activar lock de animación) ---
	var did_jump := false
	if jump_buffer_timer > 0.0:
		if on_floor or (coyote_timer > 0.0):
			run_audio.stop()
			player.velocity.y = _jump_velocity
			_play_anim_once("Jump")
			jump_audio.play()
			jump_buffer_timer = 0.0
			coyote_timer = 0.0
			did_jump = true
		elif wall_coyote_timer > 0.0:
			var away_x: float = wall_normal.x
			if away_x == 0.0:
				away_x = float(-x_dir if x_dir != 0 else -look_dir_x)
			player.velocity.y = _jump_velocity
			player.velocity.x = away_x * wall_jump_velocity
			_play_anim_once("Jump")
			jump_audio.play()
			jump_buffer_timer = 0.0
			wall_coyote_timer = 0.0
			coyote_timer = 0.0
			wall_jump_lock_timer = wall_jump_lock_time
			# orientar sprite al alejarse
			if away_x != 0.0:
				player_sprite.flip_h = (away_x < 0.0)
			did_jump = true

	if did_jump:
		# bloquea animaciones rivales por unos ms
		anim_lock_timer = anim_jump_lock_time

	# --- Animaciones de locución, sólo si NO hay lock ---
	if anim_lock_timer <= 0.0:
		if on_wall and player.velocity.y > 0.0 and pressing_toward_wall:
			_play_anim_once("Climb")   # tu anim de wall slide
		elif not on_floor and player.velocity.y > 0.0:
			_play_anim_once("Fall")
		elif not on_floor and is_equal_approx(player.velocity.y, 0.0):
			_play_anim_once("Peak")
		elif on_floor:
			if abs(x_input) > 0.0:
				_play_anim_once("Run")
				if not run_audio.playing:
					run_audio.play()
			else:
				_play_anim_once("Idle")
				run_audio.stop()

func _play_anim_once(anim_name: String) -> void:
	if animation_player and animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
