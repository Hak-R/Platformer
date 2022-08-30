extends Label

func _ready() -> void:
	visible = true
	rect_pivot_offset = rect_size / 2
	rect_scale = Vector2(0,0)

func _process(delta: float) -> void:
	if text != PlayerData.text_box:
		$Tween.remove_all()
		if PlayerData.text_box == "":
			$Tween.interpolate_property(self,"rect_scale",null,Vector2(0,0),0.4,Tween.TRANS_SINE,Tween.EASE_OUT)
		else:
			$Tween.interpolate_property(self,"rect_scale",null,Vector2(1,1),0.4,Tween.TRANS_BACK,Tween.EASE_OUT)
		text = PlayerData.text_box
		$Tween.start()
