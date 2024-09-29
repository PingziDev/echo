@tool
extends EditorPlugin

## 加载全局脚本
const AUTOLOADS = {"Echo": "res://addons/echo/echo.gd"}


func _enter_tree() -> void:
	for key in AUTOLOADS:
		add_autoload_singleton(key, AUTOLOADS[key])


func _exit_tree() -> void:
	for key in AUTOLOADS:
		remove_autoload_singleton(key)
