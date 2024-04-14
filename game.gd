extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const STATE_START = "start"
const STATE_PLAYING = "playing"
const STATE_DEFEAT = "defeat"
const STATE_VICTORY = "victory"
const STATE_BOOK = "book"

var state = STATE_START


onready var main = $main
onready var menu = $menu

onready var victory = $menu/Victory
onready var defeat = $menu/Defeat
onready var banished = $menu/banished
onready var start = $menu/Start


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS	
	menu.pause_mode = Node.PAUSE_MODE_PROCESS	
	main.pause_mode = Node.PAUSE_MODE_STOP
	
	set_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_start():
	state = STATE_START
	start.visible = true
	get_tree().paused = true
	
func set_playing():
	state = STATE_PLAYING
	menu.visible = false
	start.visible = false
	get_tree().paused = false
	
func _input(event:InputEvent):
	if event.is_action("interact"):
		if state == STATE_START:
			set_playing()
	
	
