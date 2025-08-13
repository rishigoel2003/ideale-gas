extends Node2D

# Load the ball scene
var ball_scene = preload("res://Ball.tscn")
var money = 10
var ball_cost = 0  # Starting cost for first ball
#var cost_increase = 1  # How much cost goes up each time

var fib_prev = 1  # Previous fibonacci number
var fib_curr = 1  # Current fibonacci number


func _ready():
	# Connect the button to our function
	$AddBallButton.pressed.connect(_on_add_ball_button_pressed)
	# Update the displays
	update_money_display()
	update_button_display()

func _on_add_ball_button_pressed():
	# Check if player has enough money
	if money >= ball_cost:
		# Subtract the cost
		money -= ball_cost
		
		# Create a new ball instance
		var new_ball = ball_scene.instantiate()
		
		# Position it randomly within the walls
		var random_x = randf_range(-1800, 1800)
		var random_y = randf_range(-1800, 1800)
		new_ball.position = Vector2(random_x, random_y)
		
		# Connect the ball's collision signal to our money function
		new_ball.collision_happened.connect(_on_collision_detected)
		
		# Add it to the scene
		add_child(new_ball)
		
		# Increase the cost for next ball
		var next_fib = fib_prev + fib_curr
		ball_cost = next_fib		
		
		fib_prev = fib_curr
		fib_curr = next_fib
		
		# Update displays
		update_money_display()
		update_button_display()

func _on_collision_detected():
	money += 1
	update_money_display()
	update_button_display()  # Update button availability

func update_money_display():
	$MoneyLabel.text = "Money: $" + str(money)

func update_button_display():
	# Update button text to show cost
	$AddBallButton.text = "Add Ball ($" + str(ball_cost) + ")"
	
	# Enable/disable button based on money
	if money >= ball_cost:
		$AddBallButton.disabled = false
	else:
		$AddBallButton.disabled = true
