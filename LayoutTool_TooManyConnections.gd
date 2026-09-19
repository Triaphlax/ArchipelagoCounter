extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Counter.too_many_connections.connect(show_warning)
	Counter.normal_connections_again.connect(hide_warning)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_warning():
	show()

func hide_warning():
	hide()
