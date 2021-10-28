extends Node

export(bool) var mobile_testing = false
export var encrypt_pass = "AUTO"

var on_desktop = false

var settings = {
	#Sonido
	"ost" : 100,
	"sfx" : 100,
}

func _ready():
	
	randomize()
	
	if OS.has_feature("Windows"):
		on_desktop = true
		
	if mobile_testing:
		on_desktop = false
	
	if on_desktop:
		get_tree().set_auto_accept_quit(true)
		get_tree().set_quit_on_go_back(true)
	
	load_settings()
	if encrypt_pass == "AUTO":
		encrypt_pass = OS.get_unique_id()


func save_settings():
	var f = File.new()
	f.open("user://settings.data", File.WRITE)
	f.store_line(to_json(settings))
	f.close()
	
func load_settings():
	var data_checker = File.new()
	if not data_checker.file_exists("user://settings.data"):
		save_settings()
		return
	else:
		var f = File.new()
		f.open("user://settings.data", File.READ)
		settings = parse_json(f.get_line())
		f.close()
		set_volume("ost", settings["ost"])
		set_volume("sfx", settings["sfx"])

func set_volume(var bus, var linear_vol):
	linear_vol = float(linear_vol) / 100.0
	var db_vol = linear2db(linear_vol)
	var sfx_id = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(sfx_id, db_vol)
	
	settings[bus] = int(clamp(linear_vol * 100, 0 , 100))
