extends RigidBody2D

signal cutie_left_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "Cutie"
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	cutie_left_screen.emit()
