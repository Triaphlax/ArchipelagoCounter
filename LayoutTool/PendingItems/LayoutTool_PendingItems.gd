class_name LayoutTool_PendingItems
extends PanelContainer

@export var panel_style_selected_even: StyleBox
@export var panel_style_selected_odd: StyleBox
@export var panel_style_even: StyleBox
@export var panel_style_odd: StyleBox

var scroll: ScrollContainer
var rows_that_fit: int
var last_received_items: Dictionary[String, int] = {}
var total_items: int = 0
var items_this_join: int = 0
var current_player_by_log: String
var width_default_pending: int = 1676

# relates slots to a dictionary relating logical advancement items to their counts, for items that have not yet been used
var pending_items: Dictionary[String, Dictionary] = {}

func _ready() -> void:
	Counter.log.connect(log_received)
	Counter.update.connect(generate_grid)
	
	var hbox = get_node("HBoxContainer")
	scroll = hbox.get_node("ScrollContainer")
	
	await Counter.loaded()
	
	for log_entry in Counter.save.log:
		update_pending_items_list(log_entry)
	
	generate_grid()


func log_received(log_message: LogMessage):
	update_pending_items_list(log_message)


func update_pending_items_list(log_message: LogMessage):
	if log_message is LogMessage_Item:
		items_this_join += 1
		total_items += 1
		var item: LogMessage_Item = log_message
		if item.flags & 1 == 0: # Not a Logical advancement item
			return
		
		var receiver := Counter.get_player_name_from_id(item.receiver_id)
		var item_name := Counter.get_item_name_from_id(item.receiver_id, item.item_id)
		
		## Don't count items received by an active player
		if item.receiver_id in Counter.active_players or receiver == current_player_by_log:
			return
		
		if receiver not in pending_items:
			pending_items[receiver] = {}
		if item_name not in pending_items[receiver]:
			pending_items[receiver][item_name] = 0
		
		pending_items[receiver][item_name] += 1
		last_received_items[receiver] = total_items
	
	elif log_message is LogMessage_SlotEvent:
		var event: LogMessage_SlotEvent = log_message
		if event.type not in [LogMessage_SlotEvent.TYPE.JOIN, LogMessage_SlotEvent.TYPE.PART]:
			return
		
		var player_name := Counter.get_player_name_from_id(event.slot)
		if event.type == LogMessage_SlotEvent.TYPE.JOIN:
			current_player_by_log = player_name
		if event.type == LogMessage_SlotEvent.TYPE.PART:
			current_player_by_log = ""
			if player_name in pending_items and event.slot in Counter.active_players and items_this_join > 0:
				items_this_join = 0
				pending_items[player_name] = {}


func generate_grid():
	# check is connected here
	var grid = scroll.get_node("GridContainer")
	var count := 0
	var panel_style
	for child in grid.get_children():
		child.queue_free()
		
	for playerId in Counter.active_players:
		var player = Counter.get_slot_from_id(playerId)
		if player not in pending_items.keys():
			continue
		for item in pending_items[player].keys():
			panel_style = panel_style_selected_even if count % 2 == 0 else panel_style_selected_odd
			add_to_grid(player, item, grid, panel_style)
			count += 1
	
	var pi_keys = pending_items.keys()
	pi_keys.sort_custom(func(a, b): return last_received_items[a] > last_received_items[b])
	for player in pi_keys:
		if Counter.get_slot_id_from_name(player) in Counter.active_players:
			continue
		for item in pending_items[player].keys():
			panel_style = panel_style_even if count % 2 == 0 else panel_style_odd
			add_to_grid(player, item, grid, panel_style)
			count += 1


func add_to_grid(player, item, grid, panel_style):
	var player_entry := LayoutTool_PendingItems_Entry.instantiate(player, Counter.get_color_for_slot(player), true)
	var item_entry := LayoutTool_PendingItems_Entry.instantiate(item, Counter.settings.log_item_color, true, HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT)
	var count_text := "x" + str(pending_items[player][item]) if pending_items[player][item] > 1 else ""
	var count_entry := LayoutTool_PendingItems_Entry.instantiate(count_text, Color.WHITE, false)
	
	item_entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	player_entry.add_theme_stylebox_override(&"panel", panel_style)
	player_entry.custom_minimum_size.x = 0.07 * width_default_pending
	item_entry.add_theme_stylebox_override(&"panel", panel_style)
	item_entry.custom_minimum_size.x = 0.25 * width_default_pending
	item_entry.label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	count_entry.add_theme_stylebox_override(&"panel", panel_style)
	count_entry.custom_minimum_size.x = 0.03 * width_default_pending
	
	grid.add_child(player_entry)
	grid.add_child(item_entry)
	grid.add_child(count_entry)
