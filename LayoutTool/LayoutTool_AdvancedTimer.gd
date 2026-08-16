class_name LayoutTool_AdvancedTimer
extends Label

@export_multiline var text_format := "{0}"
var game := ""

func _ready():
	Counter.timer_update.connect(update)
	Counter.active_player_changed.connect(change_game)
	await Counter.loaded()
	update()


func update():
	if game == "":
		text = ""
		return
	
	var time: float = Counter.save.game_timer[game] if game in Counter.save.game_timer else 0.0
	
	var percentage := time / Counter.save.timer if Counter.save.timer > 0.0 else 0.0
	percentage *= 100
	var percent := str(percentage)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	text = text_format.format([Utils.seconds_to_hms(time), percent])
	
func change_game(active_players: Array):
	var player_count = active_players.size()
	if player_count > 1:
		var x = 3
	elif player_count == 0:
		game = ""
	else:
		game = Counter.get_slot_from_id(active_players[0])
	update()
		
