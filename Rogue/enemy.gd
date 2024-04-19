extends RigidBody2D

@export var speed = 200
var target # The player node
var velocity = Vector2.ZERO # The enemy's movement vector
var screen_size # Size of the game window
var withinRange = false # Variable to track if enemy is within range
var despawn_timer = 3.0 # Despawn timer in seconds
var despawn_countdown = despawn_timer # Countdown timer for despawning
var isLunge = false

func _ready():
	target = get_node("/root/Main/Player")
	screen_size = get_viewport_rect().size

func _process(delta):
	if target:
		var direction = (target.position - position).normalized()
		velocity = direction * speed
		
		# Calculate distance between enemy and player
		var distance = position.distance_to(target.position)
		
		if distance <= 100:
			withinRange = true
		else:
			withinRange = false
		
		if withinRange:
			# Do something when within range (e.g., attack)
			$AnimatedSprite2D.stop()
			var lunge_start_position = target.position - direction * 50
			linear_velocity = (target.position - lunge_start_position).normalized() * speed * 5
			# Start the despawn countdown when enemy lunges
			isLunge = true
			
		else:
			# Do something when not within range (e.g., move towards player)
			$AnimatedSprite2D.play()
			position += velocity * delta
			position = position.clamp(Vector2(90, 75), screen_size - Vector2(90, 180))
			
			if velocity.x != 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				# Start the despawn countdown
			
			# Update the despawn countdown
			if isLunge:
				despawn_countdown -= delta
				if despawn_countdown <= 0:
					queue_free() # Despawn the enemy
	else:
		$AnimatedSprite2D.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	# pass # Replace with function body.
