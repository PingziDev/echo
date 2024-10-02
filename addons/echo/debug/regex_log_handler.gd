class_name RegexLogHandler
extends LogHandler
## RegexLogHandler
## 正则式过滤器

## 常用表达式
const ANSI_CONTROL_CODE = "\\x1B(?:[@-Z\\\\-_]|\\[[0-?]*[ -/]*[@-~])"
const PRINT_RICH_TAG = "\\[color=[^\\]]*\\](.*?)\\[\\/color\\]"

# 正则式过滤器提供的功能
enum StripFunction {
	ANSI_CODE = 0,
	RICH_TAG
}

# 纪录使用的功能
var strip_function : StripFunction


# 创建正则表达式对象
var regex = RegEx.new()

func _init(_strip_function : StripFunction) -> void:
	strip_function = _strip_function
	match strip_function:
		StripFunction.ANSI_CODE:
			regex.compile(ANSI_CONTROL_CODE)
			
		StripFunction.RICH_TAG:
			regex.compile(PRINT_RICH_TAG)

	
# 清除 print_rich 标签
func strip_color(colored_message: String) -> String:
	var result = colored_message
	var matches = regex.search_all(colored_message)
	
	for match in matches:
		# 取得第一个捕获组（即颜色标签之间的文本）
		var original_text = match.get_string()
		var inner_text = match.get_string(1)
		result = result.replace(original_text, inner_text)
	
	return result	
	
# 清除 ANSI 控制码的函数
func strip_ansi(text: String) -> String:
	return regex.sub(text, "", true)

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	match strip_function:
		StripFunction.ANSI_CODE:
			_message.data = strip_ansi( _message.data)
		
		StripFunction.RICH_TAG:
			regex.compile(PRINT_RICH_TAG)
			_message.data = strip_color( _message.data)
	
	return true


	
