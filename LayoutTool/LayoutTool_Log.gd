class_name Log
extends PanelContainer

@export var label: RichTextLabel
@export var print_excluded_locations := false
@export_multiline var message_template := \
	"[color=#{timestamp_color}][{timestamp}][/color] [b][color=#{sender_color}]{sender}[/color][/b] sent " + \
	"{bold_tag_start}[color=#{item_color}]{item}[/color]{bold_tag_end} to [b]{receiver}[/b] " + \
	"[b][color=#{location_color}]({location})[/color][/b]"
var full_text := ""

func _ready():
	Counter.log.connect(print_log)
	
	await Counter.loaded()
	
	for log_entry in Counter.save.log:
		print_log(log_entry)


func print_log(log_message: LogMessage):
	if log_message is LogMessage_Item:
		print_item(log_message)


func print_item(log_message: LogMessage_Item):
	if not print_excluded_locations and Counter.is_location_excluded(log_message.sender_id, log_message.location_id):
		return
	
	var source_player := Counter.get_player_name_from_id(log_message.sender_id)
	var destination_player := Counter.get_player_name_from_id(log_message.receiver_id)
	var item_name := Counter.get_item_name_from_id(log_message.receiver_id, log_message.item_id)
	var location_name := Counter.get_location_name_from_id(log_message.sender_id, log_message.location_id)
	var item_color
	if log_message.flags == 0: #filler
		item_color = Counter.settings.log_item_color_filler.to_html()
	elif log_message.flags == 1: #progression
		item_color = Counter.settings.log_item_color_prog.to_html()
	elif log_message.flags == 2: #useful
		item_color = Counter.settings.log_item_color_useful.to_html()
	else:
		item_color = Counter.settings.log_item_color.to_html()
	
	var msg := message_template.format(
		{
			"sender": source_player,
			"receiver": destination_player,
			"item": item_name,
			"location": location_name,
			"sender_color": Counter.get_color_for_slot(source_player).to_html(),
			"receiver_color": Counter.get_color_for_slot(destination_player).to_html(),
			"item_color": item_color,
			"location_color": Counter.settings.log_location_color.to_html(),
			"timestamp_color": Counter.settings.log_timestamp_color.to_html(),
			"timestamp": Utils.seconds_to_hms(log_message.timestamp),
			"bold_tag_start": "[b]" if log_message.flags == 1 else "",
			"bold_tag_end": "[/b]" if log_message.flags == 1 else ""
		})
	
	full_text += "\n" + msg
	queue_redraw()


func _draw() -> void:
	label.text = full_text
