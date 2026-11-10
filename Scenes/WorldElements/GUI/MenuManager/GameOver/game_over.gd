class_name GameOverMenu extends Menu

@export var ScoreLabel: Label

func activate()->void:
	show()
	ScoreLabel.text = "You made it to day " + str(DayNightManager.dayCount) + "\n" + "You killed " + str(Global.enemiesKilled) + " monsters"
	MenuManager.getPlayerInventory().disable()

func _on_restart_button_pressed() -> void:
	Global.restart()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
