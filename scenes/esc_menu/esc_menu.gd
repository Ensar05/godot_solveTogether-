extends Control

@onready var main_page: VBoxContainer = $MainPage
@onready var settings_page: VBoxContainer = $SettingsPage

@onready var settings_page_children: Array[Node] = settings_page.get_children()
@onready var settings_page_tabs: HBoxContainer = settings_page_children[0]
@onready var tabs: Array[Node] = settings_page_tabs.get_children()
@onready var tab_settings: Array[Node] = settings_page.get_children()
@onready var current_settings_tab = tabs[0].name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_page.hide()
	print(current_settings_tab)
	for button in tabs:
		button.toggle_mode = true
		button.pressed.connect(_on_tab_pressed.bind(button))
		
	update_tab_styles()
	settings_page_children.remove_at(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_pressed() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_settings_pressed() -> void:
	main_page.hide()
	settings_page.show()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_tab_pressed(button: Button) -> void:
	current_settings_tab = button.name
	update_tab_styles()
	print(current_settings_tab)

func update_tab_styles() -> void:
	for button in tabs:
		var is_selected = button.name == current_settings_tab
		button.set_pressed_no_signal(is_selected)
		if (is_selected == true):
			update_settings_tab(button.name)

func update_settings_tab(button) -> void:
	for i in settings_page_children:
		if i.name == button + "Settings":
			print(i.name)
			i.show()
		else: 
			i.hide()
