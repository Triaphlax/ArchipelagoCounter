extends ProgressBar

func _ready():
	Counter.update.connect(update)
	await Counter.loaded()
	update()

func update():
	if Counter.total_checks <= 0:
		value = 0.0
		return

	value = clampf(float(Counter.checks) / float(Counter.total_checks) * 100.0, min_value, max_value)
