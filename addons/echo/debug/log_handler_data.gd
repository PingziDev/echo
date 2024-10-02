class_name LogHandlerData
extends LogHandler
## LogHandlerData
## LogHandler 资料传递的基础类别，将类别名称放置于 tag

var tag
var data : Dictionary = {}
 
func _init(tag="LogHandlerData") ->void:
	self.tag = tag
 
