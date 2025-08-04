# Ball.gd - Simplified Version
extends RigidBody2D

signal collision_happened(amount)

func _ready():
	# Set up physics
	gravity_scale = 0
	linear_damp = 0
	
	# Create visual
	var sprite = Sprite2D.new()
	var texture = create_circle_texture()
	sprite.texture = texture
	add_child(sprite)
	
	# Create collision shape
	var collision = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 16
	collision.shape = circle_shape
	add_child(collision)
	
	# Give random initial velocity
	apply_random_impulse()
	
	# Connect collision signal
	body_entered.connect(_on_collision)

func create_circle_texture() -> ImageTexture:
	var size = 32
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	
	# Draw a simple circle
	for x in size:
		for y in size:
			var distance = Vector2(x - size/2, y - size/2).length()
			if distance <= size/2 - 2:
				image.set_pixel(x, y, Color.CYAN)
			else:
				image.set_pixel(x, y, Color.TRANSPARENT)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func apply_random_impulse():
	await get_tree().physics_frame  # Wait for physics to be ready
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var force = direction * randf_range(100, 300)
	apply_central_impulse(force)

func _on_collision(body):
	# Emit signal when hitting anything
	collision_happened.emit(1)
	
	# Visual feedback
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
