# Box.gd
extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var walls: Node2D = $Walls

var current_size: Vector2 = Vector2(400, 300)

func _ready():
	setup_box_visual()
	setup_walls()

func setup_box_visual():
	# Create a simple rectangle outline
	var line = Line2D.new()
	line.width = 3
	line.default_color = Color.WHITE
	
	# Draw rectangle outline
	line.add_point(Vector2(0, 0))
	line.add_point(Vector2(current_size.x, 0))
	line.add_point(Vector2(current_size.x, current_size.y))
	line.add_point(Vector2(0, current_size.y))
	line.add_point(Vector2(0, 0))
	
	add_child(line)

func setup_walls():
	# Create collision areas for each wall
	create_wall("TopWall", Vector2(current_size.x/2, -5), Vector2(current_size.x, 10))
	create_wall("BottomWall", Vector2(current_size.x/2, current_size.y + 5), Vector2(current_size.x, 10))
	create_wall("LeftWall", Vector2(-5, current_size.y/2), Vector2(10, current_size.y))
	create_wall("RightWall", Vector2(current_size.x + 5, current_size.y/2), Vector2(10, current_size.y))

func create_wall(name: String, pos: Vector2, size: Vector2):
	var area = Area2D.new()
	area.name = name
	area.position = pos
	
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = size
	collision.shape = rect_shape
	
	area.add_child(collision)
	walls.add_child(area)
	
	# Connect collision signal for money generation
	area.body_entered.connect(_on_wall_collision)

func _on_wall_collision(body):
	# When a ball hits a wall, give money
	var game_manager = get_node("/root/Main/GameManager")
	if game_manager:
		game_manager.add_money(1)

func update_box_size(new_size: Vector2):
	current_size = new_size
	
	# Update visual
	var line = get_child(1) if get_child_count() > 1 else null
	if line and line is Line2D:
		line.clear_points()
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(current_size.x, 0))
		line.add_point(Vector2(current_size.x, current_size.y))
		line.add_point(Vector2(0, current_size.y))
		line.add_point(Vector2(0, 0))
	
	# Update wall positions and sizes
	update_walls()

func update_walls():
	# Clear existing walls
	for child in walls.get_children():
		child.queue_free()
	
	# Wait a frame for cleanup
	await get_tree().process_frame
	
	# Recreate walls with new size
	setup_walls()
