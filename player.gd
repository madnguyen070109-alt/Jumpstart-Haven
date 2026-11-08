extends CharacterBody2D


const SPEED = 200.0
const CLIMB_SPEED = 200.0
const JUMP_VELOCITY = -400.0
const WORLD_LAYER = 1  # 1-based layer your tiles are on (check the TileSet physics layer)

signal score_changed(new_score: int)

var ladders_touching := 0
var climbing := false
var score := 0

func _ready() -> void:
	floor_max_angle = deg_to_rad(50.0)  # default 45° treats your 45° slope as a wall
	floor_snap_length = 8.0

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func _physics_process(delta: float) -> void:
	var grounded := is_on_floor()
	var on_ladder := ladders_touching > 0
	var horizontal_dir := Input.get_axis("ui_left", "ui_right")
	var vertical_dir := Input.get_axis("ui_up", "ui_down")
	
	# Ladder state
	if not on_ladder:
		climbing = false
	elif vertical_dir != 0.0:
		climbing = true
	elif horizontal_dir != 0.0:
		climbing = false  # step off the ladder

	# Ignore the map only while climbing
	set_collision_mask_value(WORLD_LAYER, not climbing)

	if Input.is_action_just_pressed("ui_accept") and (grounded or climbing):
		climbing = false
		set_collision_mask_value(WORLD_LAYER, true)
		velocity.y = JUMP_VELOCITY
	elif climbing:
		velocity.y = vertical_dir * CLIMB_SPEED
	elif not grounded:
		velocity += get_gravity() * delta

	if climbing:
		velocity.x = 0.0
	elif horizontal_dir:
		velocity.x = horizontal_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
