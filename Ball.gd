extends RigidBody2D

var initial_speed
signal collision_happened




func _ready():
	# Generate random velocity
	
	
	var random_x = random_speed()
	var random_y = random_speed()

	
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


func random_speed():
	var speed = randf_range(400, 500)
	return speed * (1 if randi() % 2 == 0 else -1)


var was_colliding = false

func _integrate_forces(state):
	var colliding_now = state.get_contact_count() > 0

	if colliding_now and not was_colliding:
		
		collision_happened.emit()

	was_colliding = colliding_now


func boost_speed(multiplier):
	initial_speed *= multiplier
	# Also boost current velocity to match
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * initial_speed
