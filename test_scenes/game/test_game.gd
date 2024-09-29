extends Node2D


func _ready() -> void:
	Echo.game.set_game_paused(true)

	Logger.info("Echo.game.gamepaused ====", Echo.game.gamepaused)  #LOG
