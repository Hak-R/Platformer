extends RigidBody2D

func _ready():
	for girl in get_tree().get_nodes_in_group("Girl"):
		girl.connect("in_bullet", self, "bullet_queue_free")

func _on_body_entered(body):
	$Circle.visible = false

func bullet_queue_free():
	queue_free()
