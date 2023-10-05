# FILEPATH: /home/canopus/Projects/Galactic_Equinox/Games/is_blue/scripts/player/Player.gd
extends Area2D

signal hit

# The speed at which the player moves
@export var speed = 175

# The size of the game screen
var screen_size

# The animated for the player's sprite
@onready var animated = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

func _ready():
	# Set the screen size to the size of the game viewport
	screen_size = get_viewport_rect().size
	# Hide the player sprite
	# hide()
	
func _process(delta):
	# Calculate the player's velocity based on input
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):		
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	# If the player is moving, set the velocity to the normalized velocity times the speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# Play the player's running animation
		animated.play()		
	else:
		# If the player is not moving, play the idle animation in the direction the player was last moving
		if animated.animation == "iso_run_left":
			animated.play("iso_idle_left")
		elif animated.animation == "iso_run_right":
			animated.play("iso_idle_right")
		elif animated.animation == "iso_run_up":
			animated.play("iso_idle_up")
		elif animated.animation == "iso_run_down":
			animated.play("iso_idle_down")

	# Move the player based on their velocity and delta time, and clamp their position to the screen size
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Choose the appropriate animation based on the player's velocity
	if velocity.x != 0:
		if velocity.x < 0:
			animated.animation = "iso_run_left"			
		else:
			animated.animation = "iso_run_right"			
	elif velocity.y != 0:
		if velocity.y < 0:
			animated.animation = "iso_run_up"			
		else:
			animated.animation = "iso_run_down"

func start(pos):
	position = pos
	show()
	collision.disabled = false

func _on_body_entered(body:Node2D):
	hide()
	hit.emit()
	collision.set_deferred("disabled", true)
