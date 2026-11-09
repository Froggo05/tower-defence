extends Menu

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	change_menu.emit("GameplayGUI")
	Global.gameActive = true
