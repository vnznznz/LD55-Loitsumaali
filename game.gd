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

var main_scene = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS	
	menu.pause_mode = Node.PAUSE_MODE_PROCESS	
	main.pause_mode = Node.PAUSE_MODE_STOP
	
	Globals.game = self
	set_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_start():
	state = STATE_START
	start.visible = true
	get_tree().paused = true
	
func set_playing():
	Globals.banished_enemies = 0
	state = STATE_PLAYING
	main.queue_free()
	main = main_scene.instance()
	main.pause_mode = Node.PAUSE_MODE_STOP
	add_child(main)
	menu.visible = false
	start.visible = false
	
	get_tree().paused = false
	
func set_victory():
	state = STATE_VICTORY
	get_tree().paused = true
	for child in menu.get_children():
		child.visible = false
	
	menu.visible = true
	banished.visible = true
	banished.text = "Enemies banished: %s" %[Globals.banished_enemies]
	victory.visible = true

func set_defeat():
	state = STATE_DEFEAT
	get_tree().paused = true
	for child in menu.get_children():
		child.visible = false
	
	menu.visible = true
	banished.visible = true
	banished.text = "Enemies banished: %s" %[Globals.banished_enemies]
	defeat.visible = true
	

func _input(event:InputEvent):
	if event.is_action("interact"):
		if state != STATE_PLAYING:
			set_playing()
	
	
