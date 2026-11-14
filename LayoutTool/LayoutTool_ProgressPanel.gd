class_name LayoutTool_ProgressPanel
extends MarginContainer

const MAX_GAME_NAME_FONT_SIZE := 22
const MIN_GAME_NAME_FONT_SIZE := 12

@export var color_rect: ColorRect
var game := ""
var gameNameLabel
var gameNameLabelSettings: LabelSettings
var completionIndicator
var statsLabel

func _ready():
	var HBox = get_node("HBoxContainer")
	gameNameLabel = HBox.get_node("GameNameArea/GameName")
	gameNameLabel.label_settings = gameNameLabel.label_settings.duplicate()
	gameNameLabelSettings = gameNameLabel.label_settings
	gameNameLabel.resized.connect(_fit_game_name)
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
	call_deferred("_fit_game_name")
	

func _fit_game_name():
	if gameNameLabel.size.x <= 0.0:
		return

	var font := gameNameLabelSettings.font
	var font_size := MAX_GAME_NAME_FONT_SIZE
	while font_size > MIN_GAME_NAME_FONT_SIZE and font.get_string_size(
		game, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size
	).x > gameNameLabel.size.x:
		font_size -= 1

	gameNameLabelSettings.font_size = font_size


func update():
	if game in Counter.playerNames:
		update_checks(Counter.game_checks[game], Counter.total_game_checks[game])
	else:
		modulate.a = 0.0


func update_checks(checks: int, total_checks: int):
	color_rect.material.set(&"shader_parameter/progress", float(checks) / float(total_checks))
