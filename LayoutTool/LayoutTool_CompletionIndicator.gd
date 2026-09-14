class_name LayoutTool_CompletionIndicator
extends TextureRect

var game = ""

func _ready():
	Counter.update.connect(update)
	
	
func setGame(game):
	game = game

func update():
	modulate.a = 1.0 if game in Counter.completed_games else 0.0
