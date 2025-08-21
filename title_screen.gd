extends Control

var ball_scene = preload("res://Ball.tscn")


func _ready():
	# Connect the begin button
	$BeginButton.pressed.connect(_on_begin_button_pressed)
	
	for i in 10:
		
		var new_ball = ball_scene.instantiate()
		new_ball.z_index = -1 
			
		# Position it randomly within the walls
		var random_x = randf_range(-3000, 3000)
		var random_y = randf_range(-2800, 1800)
		new_ball.position = Vector2(random_x, random_y)
		
		add_child(new_ball)
			

func _on_begin_button_pressed():
	# Switch to the main game scene
	get_tree().change_scene_to_file("res://Main.tscn")
