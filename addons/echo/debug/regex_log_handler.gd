class_name RegexLogHandler
extends LogHandler
## RegexLogHandler
## 正则式过滤器

## 常用表达式
const ANSI_CONTROL_CODE = "\\x1B(?:[@-Z\\\\-_]|\\[[0-?]*[ -/]*[@-~])"

# 创建正则表达式对象
var regex = RegEx.new()

func _init(rule:String = ANSI_CONTROL_CODE) -> void:
	# 编译正则表达式模式
	regex.compile(rule)
	
# 清除 ANSI 控制码的函数
func strip_ansi(text: String) -> String:
	return regex.sub(text, "", true)

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> void:
	_message.data = strip_ansi( _message.data)
