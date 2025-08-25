extends Control

var ball_scene = preload("res://Ball.tscn")


func _ready():
	# Connect the play again button
	$PlayAgainButton.pressed.connect(_on_play_again_pressed)
	
	for i in 10:
		
		var new_ball = ball_scene.instantiate()
		new_ball.z_index = -1 
			
		# Position it randomly within the walls
		var random_x = randf_range(-3000, 3000)
		var random_y = randf_range(-2800, 1800)
		new_ball.position = Vector2(random_x, random_y)
		
		add_child(new_ball)

func _on_play_again_pressed():
	# Go back to title screen
	get_tree().change_scene_to_file("res://title_screen.tscn")
