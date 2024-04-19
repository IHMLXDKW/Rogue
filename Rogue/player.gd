extends Area2D
signal hit

@export var speed = 300 # Regular speed (pixels/sec)
@export var sprint_speed = 550 # Sprint speed (pixels/sec)
var screen_size # Size of the game window
var is_sprinting = false # Flag to track sprinting state

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.

	# Check sprint input
	var current_speed = speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * current_speed
		$AnimatedSprite2D.play() # same as get_node("AnimatedSprite2D").play() ($ = get_node())
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	position += velocity * delta
	position = position.clamp(Vector2(90, 70), screen_size - Vector2(93, 195))
	# position = position.clamp(Vector2.ZERO, screen_size)
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		hide()  # Hides the player when colliding with an enemy
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	# elif body.is_in_group("wall"):
		# hide() # Player disappears after being hit.
		# print("WALL!")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
