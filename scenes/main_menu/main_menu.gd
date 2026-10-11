extends Control

@onready var monitor_size: Vector2i = DisplayServer.screen_get_size() 
@onready var content_size = get_tree().root.content_scale_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		setup_initial_window()
	#get_window().size = Vector2i(content_size)
	#DisplayServer.window_set_size(Vector2i(1920, 1080))

func setup_initial_window() -> void:
	# Aktuellen Monitor bestimmen
	var screen_id := DisplayServer.window_get_current_screen()

	# Nutzbaren Bereich des Monitors holen
	var usable_rect := DisplayServer.screen_get_usable_rect(screen_id)

	# Windowed Mode
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


	DisplayServer.window_set_size(usable_rect.size)

	# Fenster zentrieren
	#var window_position := usable_rect.position + usable_rect.size / 2
	#DisplayServer.window_set_position(window_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("Start button pressed!")
	get_tree().change_scene_to_file("res://scenes/lobby_map/lobby_map.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.
	
	
