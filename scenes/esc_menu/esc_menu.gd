extends Control

@onready var main_page: VBoxContainer = $MainPage
@onready var settings_page: VBoxContainer = $SettingsPage

@onready var settings_page_children: Array[Node] = settings_page.get_children()
@onready var settings_page_tabs: HBoxContainer = settings_page_children[0]

@onready var tabs: Array[Node] = settings_page_tabs.get_children()
@onready var current_settings_tab = tabs[0].name

@onready var window_button: OptionButton = $"SettingsPage/GraphicsSettings/Window Mode/WindowButton"
@onready var resolution_button: OptionButton = $SettingsPage/GraphicsSettings/Resolution/ResolutionButton
@onready var framerate_button: OptionButton = $SettingsPage/GraphicsSettings/Framerate/FramerateButton
@onready var vsync_button: OptionButton = $SettingsPage/GraphicsSettings/Vsync/VsyncButton
@onready var game_data_ui: Control = $"../../CanvasLayer2/Game_Data"

@onready var player: CharacterBody3D = $"../.."

@export var normal_style: StyleBoxFlat
@export var selected_style: StyleBoxFlat

@onready var FOV_slider: HSlider = $SettingsPage/GeneralSettings/Panel2/FOV_Slider
@onready var FOV_counter: Label = $SettingsPage/GeneralSettings/Panel2/FOV_Slider/FOVCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in tabs:
		button.pressed.connect(_on_tab_pressed.bind(button))
		
	update_tab_styles()
	settings_page_children.remove_at(0)
	init_window_graphic_settings()
	init_resolution_graphic_settings()
	init_vsync_graphic_settings()
	init_framerate_visibility()
	init_fov_slider()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.toggleMove()

func _on_settings_pressed() -> void:
	main_page.hide()
	settings_page.show()
	settings_page_tabs.show()
	# Exit button
	settings_page_children[3].show()

# exit from settings
func _on_exit_pressed() -> void:
	settings_page.hide()
	main_page.show()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_tab_pressed(button: Button) -> void:
	current_settings_tab = button.name
	update_tab_styles()

func _on_main_menu_pressed() -> void:
	main_page.hide()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

# Initialize default Settings

func init_window_graphic_settings() -> void:
	var window_mode = DisplayServer.window_get_mode()
	match window_mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_button.selected = 0
		DisplayServer.WINDOW_MODE_WINDOWED:
			window_button.selected = 1

func init_resolution_graphic_settings() -> void:
	var current_resolution: Vector2i = DisplayServer.window_get_size()
	resolution_button.set_item_text(
		0,
		"%d x %d" % [current_resolution.x, current_resolution.y]
	)

func init_vsync_graphic_settings() -> void:
	var vsync_mode: int = DisplayServer.window_get_vsync_mode()
	if vsync_mode == 0:
		vsync_button.selected = 0
	elif vsync_mode == 1:
		vsync_button.selected = 1
		update_framerate_visibility(true)
		var vsync_framerate: String = str(int(DisplayServer.screen_get_refresh_rate()))
		init_framerate_limit_settings(vsync_framerate)

func init_framerate_limit_settings(frames: String) -> void:
	for i in framerate_button.item_count:
		if framerate_button.get_item_text(i) == frames:
			print("found! ", i)
			framerate_button.select(i)
			break

func init_framerate_visibility() -> void:
	_on_show_framerate_item_selected(0)

func init_fov_slider() -> void:
	_on_fov_slider_value_changed(70)

# Update functions

func update_tab_styles() -> void:
	for button in tabs:
		var is_selected = button.name == current_settings_tab
		button.set_pressed_no_signal(is_selected)
		if (is_selected == true):
			button.add_theme_stylebox_override("normal", selected_style)
			update_settings_tab(button.name)
		else:
			button.add_theme_stylebox_override("normal", normal_style)

func update_settings_tab(button) -> void:
	for i in settings_page_children:
		if i.name == button + "Settings":
			print(i.name)
			i.show()
		else: 
			i.hide()
			if i.name == "Exit": i.show()

func update_window_setting(index: int) -> void:
	window_button.selected = index
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)	
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func update_framerate_visibility(value: bool) -> void:
	var show_framerate_option = $"SettingsPage/GraphicsSettings/Show Framerate/ShowFramerateButton"
	show_framerate_option.disabled = value

# On Item Selected Signals

func _on_window_mode_item_selected(index: int) -> void:
	update_window_setting(index)

func _on_resolution_item_selected(index: int) -> void:
	match index:
		1:
			#var item_value = resolution_button.get_item_index(1)
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2: 
			DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on_vsync_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			update_framerate_visibility(false)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			update_framerate_visibility(true)
	print("vsync ", DisplayServer.window_get_vsync_mode())

func _on_show_framerate_item_selected(index: int) -> void:
	match index:
		0:
			game_data_ui.hide()
		1:
			game_data_ui.show()

func _on_framerate_item_selected(index: int) -> void:
	var fps_text = $SettingsPage/GraphicsSettings/Framerate/Framerate/OptionButton.get_item_text(index)
	var fps: int = int(fps_text)
	
	Engine.max_fps = fps


func _on_fov_slider_value_changed(value: float) -> void:
	FOV_counter.text = str(int(value))
