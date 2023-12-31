extends Node

var guardAwareness : int = 0
var storyBeat : int = 0
var playing : bool = false

func start_play():
	load_scene("party", func():
		guardAwareness = 0
		storyBeat = 0
		playing = true
	)
	
func _process(_delta):
	if !playing:
		return
		
	if storyBeat == 0:
		var gameText = Utils.find_game_text()
		if gameText:
			gameText.display("This is it...\nTime to make these bastards bleed...", Color.WHITE, "Nyx", Color.YELLOW, 0, false)
			gameText.display("My contact said he was wearing a T-shirt, should be easy to spot!", Color.WHITE, "Nyx", Color.YELLOW, 0, false)
			gameText.display("He has the code in his back pocket...", Color.WHITE, "Nyx", Color.YELLOW, 0, false)
			
			storyBeat = 1
	
func change_guard_awareness(delta):
	guardAwareness += delta
	
	if guardAwareness == 1:
		var gameText = Utils.find_game_text()
		gameText.display("The guards are starting to look at you more closely...", Color.RED, "", Color.WHITE, 2, false)
	elif guardAwareness == 3:
		var gameText = Utils.find_game_text()
		gameText.display("The guards are raising the alarm...", Color.RED, "", Color.WHITE, 2, false)
	elif guardAwareness > 3:
		# Go for game over
		load_scene("caught")
		return
	
func load_scene(sceneName, callback : Callable = func(): pass):
	Utils.find_fader().fade_out(
		func(): 
			var resourceSceneName = "res://scenes/%s.tscn" % sceneName;
			get_tree().change_scene_to_file(resourceSceneName);
			callback.call()
	)
