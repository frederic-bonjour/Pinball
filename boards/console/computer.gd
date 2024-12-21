@tool
extends Node2D

@onready var screen_contents = $ScreenContents
@onready var animation_player = $AnimationPlayer

@export var activated: bool = false:
	set(v):
		activated = v
		if is_node_ready():
			_update_screen_contents()

@export var started: bool = false:
	set(v):
		if v and not started:
			animation_player.play(&"start")
		started = v

@export var backup_done: bool = false:
	set(v):
		backup_done = v
		if is_node_ready():
			_update_screen_contents()


var is_complete: bool:
	get:
		return started and activated and backup_done

func _ready():
	screen_contents.text = ""


func _on_animation_player_animation_finished(_anim_name: StringName):
	_update_screen_contents()


func _update_screen_contents() -> void:
	var c : = PackedStringArray()
	if started:
		c.append("System starting...")
	if activated:
		c.append("System activated.")
	if backup_done:
		c.append("Backup done.")
	screen_contents.text = "\n".join(c)
