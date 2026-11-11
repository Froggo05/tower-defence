class_name GameOverMenu extends Menu

@export var ScoreLabel: Label

func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	ScoreLabel.text = "You made it to day " + str(Global.dayCount) + "\n" + "You killed " + str(Global.enemiesKilled) + " monsters"
	MenuManager.getPlayerInventory().disable()

func _on_restart_button_pressed() -> void:
	Global.restart()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
