extends Menu

func _on_back_button_pressed() -> void:
	exit_menu.emit()


func _on_menu_2_button_pressed() -> void:
	change_menu.emit("SampleMenu2")
