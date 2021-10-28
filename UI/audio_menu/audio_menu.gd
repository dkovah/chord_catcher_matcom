extends Control

func _ready():
	$ost/slider.value = Settings.settings["ost"]
	$sfx/slider.value = Settings.settings["sfx"]

func _on_slider_value_changed(value, bus):
	Settings.set_volume(bus, value)
