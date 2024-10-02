
class_name LogHandler
extends Object
## LogHandler
## 基础类别，让其他log_handler继承，统一接口
## 禁止在LogHandler里面使用log，避免无穷回圈
## 所有Handler都会在线程里面运行，所以严禁场景树相关操作

enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}
	
# 处理日志讯息的方法，需在子类别中实作
func _handle(_level: LogLevel, _timestamp: String, _message: String, _custom_data: LogHandlerData) -> void:
	pass

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
