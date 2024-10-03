class_name CategoryLogHandler
extends LogHandler
## CategoryLogHandler
## 开发者自定义处理器
## 展示如何分类讯息


@export var show_category: Array[String] = [
	"echo",
]

func _handle(_level: LogLevel, _timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	# 没有附加资料一律通过
	if _custom_data:
		var data = _custom_data.data
		if not data.has("category"):
			return true
		# # 带有category，且在显示清单才通过
		return show_category.has(data.get("category",""))

	return true
