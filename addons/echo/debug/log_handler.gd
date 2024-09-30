# LogHandler.gd
extends Object
## 所有Handler都會在線程裡面運行，所以嚴禁場景樹相關操作
# 基礎的 LogHandler 類別
class_name LogHandler

enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}

# 處理日誌訊息的方法，需在子類別中實作
func handle(_level: LogLevel, _timestamp: String, _message: String) -> void:
	pass
