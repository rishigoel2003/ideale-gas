extends Node2D

# Load the ball scene
var ball_scene = preload("res://Ball.tscn")
var money = 10
var ball_cost = 0  # Starting cost for first ball
#var cost_increase = 1  # How much cost goes up each time

var fib_prev = 1  # Previous fibonacci number
var fib_curr = 1  # Current fibonacci number

# Speed boost variables
var speed_boost_cost = 25
var speed_boost_multiplier = 1.3  # Increase speed by 30%

func _ready():
	# Connect the button to our function
	$AddBallButton.pressed.connect(_on_add_ball_button_pressed)
	$SpeedBoostButton.pressed.connect(_on_speed_boost_button_pressed)
	# Update the displays
	update_money_display()
	update_button_displays()

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
		update_button_displays()

func _on_speed_boost_button_pressed():
	# Check if player has enough money
	if money >= speed_boost_cost:
		# Subtract the cost
		money -= speed_boost_cost
		
		# Boost speed of all existing balls
		boost_all_ball_speeds()
		
		# Increase cost for next speed boost
		speed_boost_cost = int(speed_boost_cost * 1.5)  # Cost increases by 50% each time
		
		# Update displays
		update_money_display()
		update_button_displays()

func boost_all_ball_speeds():
	# Find all ball nodes and increase their speed
	for child in get_children():
		if child.has_method("boost_speed"):
			child.boost_speed(speed_boost_multiplier)


func _on_collision_detected():
	money += 1
	$clack.stop()
	$clack.play()
	update_money_display()
	update_button_displays()  # Update button availability

func update_money_display():
	$MoneyLabel.text = "Money: $" + str(money)

func update_button_displays():
	# Update button text to show cost
	$AddBallButton.text = "Add Ball ($" + str(ball_cost) + ")"
	$AddBallButton.disabled = money < ball_cost
	
	# Update speed boost button
	$SpeedBoostButton.text = "Speed Boost ($" + str(speed_boost_cost) + ")"
	$SpeedBoostButton.disabled = money < speed_boost_cost
