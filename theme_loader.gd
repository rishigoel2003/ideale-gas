# theme_setup.gd
# Attach this script to a Node that runs at startup
extends Node

func _ready():
	var theme = Theme.new()

	# === FONT ===
	var font = FontFile.new()
	font.load("res://fonts/Roboto-Regular.ttf")  # put any TTF/OTF here
	
	# Label font
	theme.set_font("font", "Label", font)
	theme.set_font_size("font_size", "Label", 24)

	# Button font
	theme.set_font("font", "Button", font)
	theme.set_font_size("font_size", "Button", 22)

	# === COLORS ===
	var main_color = Color.hex("4a90e2")   # blue
	var hover_color = Color.hex("5aa0ff")
	var pressed_color = Color.hex("2f6bb2")
	var text_color = Color.white

	# === BUTTON STYLE ===
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = main_color
	style_normal.corner_radius_all = 12
	style_normal.content_margin_left = 16
	style_normal.content_margin_right = 16
	style_normal.content_margin_top = 8
	style_normal.content_margin_bottom = 8

	var style_hover = style_normal.duplicate()
	style_hover.bg_color = hover_color

	var style_pressed = style_normal.duplicate()
	style_pressed.bg_color = pressed_color

	theme.set_stylebox("normal", "Button", style_normal)
	theme.set_stylebox("hover", "Button", style_hover)
	theme.set_stylebox("pressed", "Button", style_pressed)

	theme.set_color("font_color", "Button", text_color)
	theme.set_color("font_hover_color", "Button", text_color)
	theme.set_color("font_pressed_color", "Button", text_color)

	# === LABEL STYLE ===
	theme.set_color("font_color", "Label", Color.white)

	# === APPLY THEME GLOBALLY ===
	get_tree().root.theme = theme
