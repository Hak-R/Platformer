extends Area2D

export(String, MULTILINE) var message_text = "PLEASE SET TEXT"


func _on_Sign_body_entered(body):
	PlayerData.text_box = message_text


func _on_Sign_body_exited(body):
	if PlayerData.text_box == message_text:
		PlayerData.text_box = ""

