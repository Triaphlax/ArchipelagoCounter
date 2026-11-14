class_name LayoutTool_CheckCounter
extends Label

@export_multiline("Format") var text_format := "{0}/{1}"

func _ready():
	Counter.update.connect(update)


func update():
	var total_checks_digits := len(str(Counter.total_checks))
	var checks := str(Counter.checks).pad_zeros(total_checks_digits)
	var format_values: Array = [checks, Counter.total_checks]

	if text_format.contains("{2}"):
		total_checks_digits = max(5, len(str(Counter.total_checks)))
		checks = str(Counter.checks).pad_zeros(total_checks_digits)
		var total_checks := str(Counter.total_checks).pad_zeros(total_checks_digits)
		var percentage_tenths := 0
		if Counter.total_checks > 0:
			percentage_tenths = roundi(float(Counter.checks) / float(Counter.total_checks) * 1000.0)
		var percentage := str(int(percentage_tenths / 10)).pad_zeros(3)
		percentage += ".{0}".format([percentage_tenths % 10])
		format_values = [checks, total_checks, percentage]

	text = text_format.format(format_values)
