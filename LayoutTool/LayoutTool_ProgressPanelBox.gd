extends PanelContainer

var game := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tint = get_node("Tint")
	modulate.a = 0.0
	game = name
	
	Counter.update.connect(update)
		
	tint.setGame(name)
	
func update():
	if game in Counter.playerNames:
		modulate.a = 1.0

func _process(delta: float) -> void:
	pass
