extends Control

export(String, FILE, "*.tscn") var main_scene

func _ready():
	pass

func to_main():
	ProjectSettings.set("application/run/main_scene", main_scene)
	FadeSystem.change_scene(main_scene)
