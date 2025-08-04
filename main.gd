# GameManager.gd - Simplified Version
extends Node2D

# Game state
var money: int = 0
var ball_count: int = 3
var box_size: Vector2 = Vector2(400, 300)

# Node references
var money_label: Label
var ball_container: Node2D

# Ball scene
var ball_scene = preload("res://Ball.tscn")

func _ready():
	setup_scene()
	setup_ui()
	spawn_initial_balls()

func setup_scene():
	# Center the game area
	position = Vector2(100, 100)
	
	# Create ball container
	ball_container = Node2D.new()
	ball_container.name = "BallContainer"
	add_child(ball_container)
	
	# Draw box outline
	draw_box()

func setup_ui():
	# Create UI layer
	var ui = CanvasLayer.new()
	add_child(ui)
	
	# Money label
	money_label = Label.new()
	money_label.text = "Money: $0"
	money_label.position = Vector2(10, 10)
	money_label.add_theme_font_size_override("font_size", 24)
	ui.add_child(money_label)
	
	# Simple button
	var button = Button.new()
	button.text = "Add Ball - $10"
	button.position = Vector2(10, 50)
	button.size = Vector2(150, 40)
	button.pressed.connect(buy_ball)
	ui.add_child(button)

func draw_box():
	# Create static walls
	create_wall(Vector2(0, 0), Vector2(box_size.x, 10))  # Top
	create_wall(Vector2(0, box_size.y-10), Vector2(box_size.x, 10))  # Bottom
	create_wall(Vector2(0, 0), Vector2(10, box_size.y))  # Left
	create_wall(Vector2(box_size.x-10, 0), Vector2(10, box_size.y))  # Right

func create_wall(pos: Vector2, size: Vector2):
	var wall = StaticBody2D.new()
	wall.position = pos
	
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = size
	collision.shape = rect_shape
	collision.position = size / 2  # Center the collision shape
	
	# Visual representation
	var color_rect = ColorRect.new()
	color_rect.size = size
	color_rect.color = Color.WHITE
	
	wall.add_child(collision)
	wall.add_child(color_rect)
	add_child(wall)

func spawn_initial_balls():
	for i in ball_count:
		spawn_ball()

func spawn_ball():
	if not ball_scene:
		print("Ball scene not loaded!")
		return
		
	var ball = ball_scene.instantiate()
	if not ball:
		print("Failed to instantiate ball!")
		return
		
	# Random position within box bounds
	var margin = 30
	ball.position = Vector2(
		randf_range(margin, box_size.x - margin),
		randf_range(margin, box_size.y - margin)
	)
	
	ball_container.add_child(ball)
	
	# Connect the ball's collision signal
	if ball.has_signal("collision_happened"):
		ball.collision_happened.connect(add_money)

func add_money(amount: int = 1):
	money += amount
	update_ui()

func update_ui():
	if money_label:
		money_label.text = "Money: $%d" % money

func buy_ball():
	if money >= 10:
		money -= 10
		spawn_ball()
		update_ui()
