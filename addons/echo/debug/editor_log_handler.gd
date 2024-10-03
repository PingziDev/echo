class_name EditorLogHandler
extends LogHandler
## EditorLogHandler
## godot 编辑器 调试工具/错误标签页
## 因为 EditorLogHandler 会列印出堆栈内容，所以放在filter由主线程处里才能正确显示堆栈内容

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	var log_message
	# 编辑器本身自带分类，不需要再输出Level字串
	match level:
		LogHandler.LogLevel.WARNING:
			log_message = "[%s] %s" % [timestamp, message]
			push_warning(log_message)

		LogHandler.LogLevel.ERROR:
			log_message = "[%s] %s" % [timestamp, message]
			push_error(log_message)
	
	return true
