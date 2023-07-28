extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var facing_right = true
var direction = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10
var hitstun = 0
var knockback = -1
var is_dead = false


@onready var anim = get_node("AnimationPlayer") 

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if hitstun == 0:
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
				knockback = 1
			elif direction == 1:
				get_node("AnimatedSprite2D").flip_h = false
				knockback = -1
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("idle")
		if velocity.y > 0:
			anim.play("fall")
	if hitstun > 0:
		if health <= 0:
			anim.play("death")
			await anim.animation_finished
			get_tree().change_scene_to_file("res://main.tscn")
		else:
			anim.play("hurt")
			hitstun -= 1
			velocity.x = knockback * 300
			velocity.y = -100

	move_and_slide()
