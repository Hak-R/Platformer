extends Control

onready var label: Label = get_node("Label")

func _ready() -> void:
	if PlayerData.death == 0:
		label.text = "Your final score is %s \n You haven't died!"
		label.text = label.text % PlayerData.score
	elif PlayerData.death == 1:
		label.text = "Your final score is %s \n You died %s time"
		label.text = label.text % [PlayerData.score, PlayerData.death]
	else:
		label.text = label.text % [PlayerData.score, PlayerData.death]		
