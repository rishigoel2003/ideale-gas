extends Control

func _ready():
	# Connect the play again button
	$PlayAgainButton.pressed.connect(_on_play_again_pressed)

func _on_play_again_pressed():
	# Go back to title screen
	get_tree().change_scene_to_file("res://title_screen.tscn")
