class_name LayoutTool_ProgressPanel
extends MarginContainer

@export var color_rect: ColorRect
var game := ""
var gameNameLabel
var completionIndicator
var statsLabel

func _ready():
	var HBox = get_node("HBoxContainer")
	gameNameLabel = HBox.get_node("GameName")
	completionIndicator = HBox.get_node("CompletionIndicator")
	statsLabel = HBox.get_node("HBoxContainer").get_node("Stats").get_node("Stats")
	Counter.timer_update.connect(update)
	
	await Counter.loaded()
	
	statsLabel.setGame(game)
	completionIndicator.setGame(game)
	
	update()
	

func setGame(pgame):
	game = pgame
	gameNameLabel.text = game
	statsLabel.setGame(game)
	

func update():
	if game in Counter.playerNames:
		update_checks(Counter.game_checks[game], Counter.total_game_checks[game])
	else:
		modulate.a = 0.0


func update_checks(checks: int, total_checks: int):
	color_rect.material.set(&"shader_parameter/progress", float(checks) / float(total_checks))
