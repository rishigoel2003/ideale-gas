extends Control

func _ready():
	# Connect the begin button
	$BeginButton.pressed.connect(_on_begin_button_pressed)

func _on_begin_button_pressed():
	# Switch to the main game scene
	get_tree().change_scene_to_file("res://Main.tscn")
