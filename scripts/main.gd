extends Node

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
var scroll_speed : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const pipe_delay : int = 100
const pipe_range : int = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	game_running = false 
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = 'SCORE: ' + str(score)
	$GameOver.hide()
	get_tree().call_group('pipes', 'queue_free')
	pipes.clear()
	generate_pipes()
	$player.reset()
	

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $player.floating:
						$player.flap()
						check_top()

func start_game():
	game_running = true
	$player.floating = true
	$player.flap()
	#start pipe timer
	$PipeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += scroll_speed
		#scroll resert
		if scroll >= screen_size.x:
			scroll = 0
			#Move ground node
		$Ground.position.x = -scroll
		#move pipes
		for pipe in pipes:
			pipe.position.x -= scroll_speed




func _on_pipe_timer_timeout() -> void:
	generate_pipes()
func generate_pipes():
		var pipe = pipe_scene.instantiate()
		pipe.position.x = screen_size.x + pipe_delay
		pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-pipe_range, pipe_range)
		pipe.hit.connect(player_hit)
		pipe.scored.connect(scored)
		add_child(pipe)
		pipes.append(pipe)
		

func scored():
	score += 1
	$ScoreLabel.text = 'SCORE: ' + str(score)

func check_top():
	if $player.position.y < 0:
		$player.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$player.floating = false 
	game_running = false
	game_over = true
	%GameOver.visible = true
	

func player_hit():
	$player.falling = true
	stop_game()
	

func _on_ground_hit():
	$player.falling = false
	stop_game()
