class_name LayoutTool_CheckCounterAdvanced
extends LayoutTool_CheckCounter

var game := ""

func _ready():
	Counter.update.connect(update)
	Counter.active_player_changed.connect(change_game)
	await Counter.loaded()
	update()


func update():
	if game == "":
		text = ""
	else:
		update_text(Counter.game_checks[game], Counter.total_game_checks[game])

func update_text(checks: int, total_checks: int):
	var total_checks_digits := len(str(total_checks))
	var checks_str := str(checks).pad_zeros(total_checks_digits)
	var percent := str((float(checks) / float(total_checks)) * 100)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	var cpm := str(60.0 * (float(checks) / Counter.save.timer))
	cpm = cpm.pad_decimals(4)
	
	text = text_format.format([checks, total_checks, game])

func change_game(active_players: Array):
	var player_count = active_players.size()
	if player_count > 1:
		game = "Too many games!!!"
	elif player_count == 0:
		game = ""
	else:
		game = Counter.get_slot_from_id(active_players[0])
	update()
		
