extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 390.0

var dashing = false
var can_dash = true

@onready var animated_sprit: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$dash_stop_timer.start()
		can_dash = false
		$dash_cooldown_timer.start()

	if direction > 0:
		animated_sprit.flip_h = false
	elif direction < 0:
		animated_sprit.flip_h = true

	if dashing:
		var dash_dir = direction
		if dash_dir == 0:
			dash_dir = -1 if animated_sprit.flip_h else 1
		velocity.x = dash_dir * DASH_SPEED
		animated_sprit.play("dash")
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_floor():
			if direction == 0:
				animated_sprit.play("idle")
			else:
				animated_sprit.play("run")
		else:
			animated_sprit.play("jump")

	move_and_slide()


func _on_dash_stop_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
