extends Node3D

@export var possibleItems : PackedStringArray

var stolen : bool = false
var gameText : GameText = null

func on_interact(_what, _who, _count):
	if !gameText:
		gameText = Utils.find_game_text()

	if stolen:
		gameText.display("Nothing to steal!", Color.RED, "", Color.WHITE, 2, true)
		return
		
	var item = possibleItems[randi() % possibleItems.size()]
	gameText.display("You stole %s!" % get_display_name(item), Color.YELLOW, "", Color.WHITE, 2, true)
	
	var player = Utils.find_player()
	player.add_item(item)

	GameManager.change_guard_awareness(1)
	
	stolen = true
	
func get_display_name(n : String):
	return n.replace("_", " ")
