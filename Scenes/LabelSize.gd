class_name FitLabel
extends Label


func resize():
	label_settings.font_size = 16
	var string_size = get_theme_font("font").get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label_settings.font_size).x
	while string_size > get_rect().size.x:
		label_settings.font_size -= 1
		string_size = get_theme_font("font").get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, label_settings.font_size).x
