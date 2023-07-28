extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var lr = false
var dead = false

@onready var player_node = get_node("../../Player/Player")
@onready var anim = get_node("AnimatedSprite2D")

func _physics_process(delta):
	if !dead:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			if velocity.y >= 0:
				anim.play("fall")
		if chase == true:
			var direction = player_node.global_position - self.global_position
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
				lr = 1
			else:
				get_node("AnimatedSprite2D").flip_h = false
				lr = -1
			velocity.x = lr * SPEED
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				anim.play("jump")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				anim.play("idle")
		move_and_slide()
	

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true




func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_hurtbox_body_entered(body):
	if body.name == "Player":
		dead = true
		player_node.velocity.y = -400
		anim.play("death")
		await anim.animation_finished
		queue_free()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		player_node.health -= 3
		player_node.hitstun = 10

