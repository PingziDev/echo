class_name LogHandler
extends RefCounted 
## LogHandler
## 基础类别，让其他log_handler继承，统一接口
## 禁止在LogHandler里面使用log，避免无穷回圈
## 所有Handler都会在线程里面运行，所以严禁场景树相关操作

# 定义标准颜色
enum LogColor {
	FG_BLACK = 0,
	FG_RED,
	FG_GREEN,
	FG_YELLOW,
	FG_BLUE,
	FG_MAGENTA,
	FG_CYAN,
	FG_WHITE,
	FG_ORANGE,
	FG_GRAY,
	FG_PINK,
	FG_PURPLE,

	BG_BLACK,
	BG_RED,
	BG_GREEN,
	BG_YELLOW,
	BG_BLUE,
	BG_MAGENTA,
	BG_CYAN,
	BG_WHITE,
	BG_ORANGE,
	BG_GRAY,
	BG_PINK,
	BG_PURPLE
}

enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}
	
# 处理日志讯息的方法，需在子类别中实作
# 讯息以字典方式封装才能达到内容直接修改效果
## 讯息被包装于 data 变量
## 回傳是否繼續往下傳遞
func _handle(_level: LogLevel, _timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	return true

func get_level_string(level: LogLevel) -> String:
	match level:
		LogHandler.LogLevel.DEBUG:
			return "DEBUG"
		LogHandler.LogLevel.INFO:
			return "INFO"
		LogHandler.LogLevel.WARNING:
			return "WARNING"
		LogHandler.LogLevel.ERROR:
			return "ERROR"
		_:
			return "UNKNOWN"
