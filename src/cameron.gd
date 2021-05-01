extends Camera

var final_pos : Vector3 = Vector3(-0.186, 1.03, 1.111)
var final_angle : float = 56.476

const picoday = preload("res://src/picoday.tres")

func _ready():
	randomize()
	yield(get_tree().create_timer(3.0), "timeout")
	final_pos = translation

func _process(delta):
	if Input.is_action_just_pressed("punch") and picoday.locked:
		translate_object_local((Vector3((randf() - 0.5) * 2, (randf() - 0.5) * 2, 0.0) * 0.025))
	translation = lerp(translation, final_pos, delta)
	rotation_degrees.y = lerp(rotation_degrees.y, final_angle, delta)
