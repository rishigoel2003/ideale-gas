extends RigidBody2D

var initial_speed
signal collision_happened

# Attraction variables
@export var attraction_strength: float = 10**10  # Adjustable in inspector
var other_balls: Array[RigidBody2D] = []

@export var max_velocity: float = 20000.0  # Adjust as needed

func _ready():
	# Generate random velocity
	var random_x = random_speed()
	var random_y = random_speed()
	
	# Store the initial speed (for boost reference)
	initial_speed = Vector2(random_x, random_y).length()
	
	# Set the initial velocity
	linear_velocity = Vector2(random_x, random_y)
	
	# Connect to contact monitoring for collision detection
	contact_monitor = true
	max_contacts_reported = 10

# Remove the _physics_process function - let physics handle velocity naturally

func random_speed():
	var speed = randf_range(400, 500)
	return speed * (1 if randi() % 2 == 0 else -1)

var was_colliding = false



func _integrate_forces(state):
	
	apply_attractive_forces(state)
	
	if linear_velocity.length() > max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity

	var colliding_now = state.get_contact_count() > 0
	if colliding_now and not was_colliding:
		collision_happened.emit()
	was_colliding = colliding_now

func boost_speed(multiplier):
	# Boost the current velocity by the multiplier
	linear_velocity *= multiplier
	# Update initial_speed for reference
	initial_speed = linear_velocity.length()




func apply_attractive_forces(state):
	for other_ball in other_balls:
		if other_ball != self and is_instance_valid(other_ball):
			var distance_vector = other_ball.global_position - global_position
			var distance = distance_vector.length()
			
			# Avoid division by zero and extreme forces at very close distances
			if distance < 0.0:
				continue
				
			# Calculate attractive force (inverse square law like gravity)
			# F = G * m1 * m2 / r^2, but simplified since masses are equal
			var force_magnitude = attraction_strength / (distance * distance)
			
			# Apply force in direction of other ball
			var force_direction = distance_vector.normalized()
			var force = force_direction * force_magnitude
			
			# Apply the force
			state.apply_central_force(force)



func set_other_balls(balls_array: Array[RigidBody2D]):
	other_balls = balls_array
