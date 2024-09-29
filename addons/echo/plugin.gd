@tool
extends EditorPlugin

## 加载全局脚本
const AUTOLOADS = {
	Echo = "res://addons/echo/echo.gd",
	Logger = "res://addons/echo/debug/logger.gd",
}


func _enter_tree() -> void:
	for singleton in AUTOLOADS:
		add_autoload_singleton(singleton, AUTOLOADS[singleton])


func _exit_tree() -> void:
	for singleton in AUTOLOADS:
		remove_autoload_singleton(singleton)
