extends CanvasLayer

var to_scene=""
export var anim_speed = 1.5

onready var anim_player = $AnimationPlayer

func _ready():
	set_process(false)

func is_playing():
	return $AnimationPlayer.is_playing()

func play(anim, speed = anim_speed):
	anim_player.playback_speed = speed
	anim_player.play(anim)

func change_scene(scene, speed = anim_speed):
	to_scene = scene
	play("out", speed)
	get_tree().paused = true
	set_process(true)

func reload_current_scene():
	change_scene("RELOAD")

func _process(_delta):
	if not is_playing():
		if to_scene == "RELOAD":
			var _e = get_tree().reload_current_scene()
		else:
			var _e = get_tree().change_scene(to_scene)
		play("in")
		get_tree().paused=false
		set_process(false)
