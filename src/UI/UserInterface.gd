extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var score: Label = get_node("Label")
onready var pause_title: Label = get_node("PauseOverlay/Title")
onready var mobile_menu: TouchScreenButton = get_node("PauseOverlay/MobileControl/Menu")
onready var settings_menu: ColorRect = get_node("Settings")

var paused: = false setget set_paused
var settings: = false setget set_settings

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()
	
func _process(delta: float) -> void:
	$HealthBar/Health.set_text(str($"/root/PlayerData".player_health))
	$HealthBar.value = $"/root/PlayerData".player_health
	
	if $Settings/ScreenMode.selected == 0:
		OS.window_fullscreen = true
	elif $Settings/ScreenMode.selected == 1:
		OS.window_fullscreen = false
		

func _on_Settings_button_up() -> void:
	self.settings = not settings
		
func _on_PlayerData_player_died() -> void:
	yield(get_tree().create_timer(3), "timeout")
	self.paused = true
	pause_title.text = ":("


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and pause_title.text != ":(":
		self.paused = not paused
	if event.is_action_pressed("pause") and settings == true:
		self.paused = false
		self.settings = false

func update_interface() -> void:
	score.text = "Score: %s" % PlayerData.score

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func set_settings(value: bool) -> void:
	scene_tree.paused = value
	settings = value
	settings_menu.visible = value

