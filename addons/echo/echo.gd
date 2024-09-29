## Echo框架的全局入口
extends Node

##游戏管理（Game）：全局控制游戏进度、速度、难度等。
var game: Game
## 场景管理（Scene）：随时加载、卸载和切换多个游戏场景。
var scene: Node
## 数据管理（Data）：处理游戏的存档与读档，管理动态产生的游戏数据。
var data: Node
## 资源管理（Resource）：高效管理资源加载，支持同步与异步模式，优化内存使用。
var resource: Node
## 实体管理（Entity）：动态创建、显示、隐藏、销毁游戏对象。
var entity: Node
## 输入处理（Input）：统一管理键盘、鼠标、手柄等输入设备的控制。
var input: Node
## 事件系统（Event）：解耦事件与响应逻辑，提供事件管理和触发机制。
var event: Node
## 界面管理（UI）：处理游戏中的用户界面元素，提供流畅的交互体验。
var ui: Node
## 音效管理（Sound）：控制背景音乐和音效，创造沉浸式体验。
var sound: Node
## 调试工具（Debug）：提供开发调试工具，便于问题排查与优化。
var debug: Debug


func _ready() -> void:
	game = load("res://addons/echo/game/game.gd").new()
	game.name = "Game"
	add_child(game)

	debug = load("res://addons/echo/debug/debug.gd").new()
	debug.name = "Debug"
	add_child(debug)
