class_name LayoutTool_CheckCounterAdvanced
extends LayoutTool_CheckCounter

var game := ""

func _ready():
	Counter.update.connect(update)
	await Counter.loaded()
	update()

func setGame(pgame):
	game = pgame
	update()

func update():
	if game not in Counter.playerNames:
		modulate.a = 0.0
	else:
		modulate.a = 1.0
		update_text(game, Counter.game_checks[game], Counter.total_game_checks[game])

func update_text(game: String, checks: int, total_checks: int):
	var total_checks_digits := len(str(total_checks))
	var checks_str := str(checks).pad_zeros(total_checks_digits)
	var total_checks_str := str(total_checks).pad_zeros(total_checks_digits)
	var percentage_hundredths := 0
	if total_checks > 0:
		percentage_hundredths = roundi(float(checks) / float(total_checks) * 10000.0)
	var percent := str(int(percentage_hundredths / 100)).pad_zeros(3)
	percent += ".{0}".format([str(percentage_hundredths % 100).pad_zeros(2)])
	
	#var cpm := str(60.0 * (float(checks) / Counter.save.timer))
	#cpm = cpm.pad_decimals(4)
	var game_time := 0
	if game in Counter.save.game_timer.keys():
		game_time = Counter.save.game_timer[game]
	text = text_format.format([checks_str, total_checks_str, percent, Utils.seconds_to_hms(game_time)])
		
