extends RigidBody2D

var initial_speed
signal collision_happened

func _ready():
	# Generate random velocity
	var random_x = randf_range(-200, 200)
	var random_y = randf_range(-200, 200)
	
	# Store the initial speed
	initial_speed = Vector2(random_x, random_y).length()
	
	# Set the initial velocity
	linear_velocity = Vector2(random_x, random_y)
	
	# Connect to contact monitoring for wall collisions
	contact_monitor = true
	max_contacts_reported = 10

func _physics_process(_delta):
	# Maintain constant speed
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * initial_speed


# Alternative method - use integration forces
func _integrate_forces(state):
	# Check for contacts (collisions) this frame
	if state.get_contact_count() > 0:

		$AudioStreamPlayer2D.play()
		collision_happened.emit()
