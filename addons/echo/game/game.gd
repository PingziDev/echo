class_name Game extends Node

## TODO 讨论全局配置方式

var gamepaused: bool = false:
	set = set_game_paused

var gamespeed: float = 1:
	set = _set_gamespeed


func set_game_paused(paused):
	gamepaused = paused
	#Logger.info('game paused',paused)
	get_tree().paused = paused
	if paused:
		PhysicsServer2D.set_active(true)


func _set_gamespeed(speed: float):
	gamespeed = speed
	Engine.time_scale = speed
	gamepaused = speed == 0
