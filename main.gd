extends Node2D

# Load the ball scene
var ball_scene = preload("res://Ball.tscn")
var money = 99
var ball_cost = 0  # Starting cost for first ball
#var cost_increase = 1  # How much cost goes up each time

var fib_prev = 1  # Previous fibonacci number
var fib_curr = 1  # Current fibonacci number

# Speed boost variables
var speed_boost_cost = 25
var speed_boost_multiplier = 1.3  # Increase speed by 30%


# Win condition
var win_amount = 1000
var game_won = false

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
		
		# Update the attraction system for all balls
		update_attraction_system()
		
		# Increase the cost for next ball
		var next_fib = fib_prev + fib_curr
		ball_cost = next_fib		
		
		fib_prev = fib_curr
		fib_curr = next_fib
		
		# Update displays
		update_money_display()
		update_button_displays()
		

func update_attraction_system():
	# Collect all balls in the scene
	var balls: Array[RigidBody2D] = []
	for child in get_children():

		if child is RigidBody2D and child.has_method("set_other_balls"):
			balls.append(child)
	
	# Update each ball's reference to all other balls
	for ball in balls:
		ball.set_other_balls(balls)
		



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

	check_win_condition()
	

func check_win_condition():
	if money >= win_amount and not game_won:
		game_won = true
		# Wait a moment then go to win screen
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://WinScreen.tscn")

func update_money_display():
	$MoneyLabel.text = "Money: $" + str(money) + " / $" + str(win_amount)

func update_button_displays():
	# Update button text to show cost
	$AddBallButton.text = "Add Ball ($" + str(ball_cost) + ")"
	$AddBallButton.disabled = money < ball_cost
	
	# Update speed boost button
	$SpeedBoostButton.text = "Speed Boost ($" + str(speed_boost_cost) + ")"
	$SpeedBoostButton.disabled = money < speed_boost_cost
