extends Spatial

onready var anim = $AnimationPlayer
onready var tim = $timer

onready var streamer = $player
onready var suffer = $gplayer

const face = preload("res://assets/pico/FACE.tres")
const head = preload("res://assets/pico/HEAD_SKIN.tres")

export (Array, StreamTexture) var pico_states
export (Array, StreamTexture) var pico_punches

export (Array, AudioStream) var sounds
export (Array, AudioStream) var grunts

const picoday = preload("res://src/picoday.tres")

func _ready():
	randomize()
	tim.connect("timeout", self, "refresh")
	yield(get_tree().create_timer(3.0),"timeout")
	picoday.keyed = true

func refresh():
	if picoday.ultraviolence == 4:
		anim.play("ded-loop")
	else:
		anim.play("idle-loop")
	face.albedo_texture = pico_states[picoday.ultraviolence]

func punch():
	if anim.is_playing():
		anim.stop()
	
	if picoday.ultraviolence == 4:
		anim.play("hit-ded")
	else:
		anim.play("hit-0")
	
	picoday.punches += 1
	if picoday.punches > 1: #FFC372
		picoday.ultraviolence = 1
	if picoday.punches > 50:
		picoday.ultraviolence = 2
		head.albedo_color = Color("#f2b58b")
	if picoday.punches > 125:
		picoday.ultraviolence = 3
		head.albedo_color = Color("#e6a67b")
	if picoday.punches > 275:
		picoday.ultraviolence = 4
		head.albedo_color = Color("#e68d64")
	
	face.albedo_texture = pico_punches[picoday.ultraviolence]
	
	streamer.stream = sounds[int(rand_range(0.0, sounds.size()))]
	streamer.pitch_scale = rand_range(0.8,1.0)
	streamer.play()
	
	if picoday.punches < 276:
		suffer.stream = grunts[int(rand_range(0.0, grunts.size() - 1))]
		suffer.play()
	elif picoday.punches == 276:
		suffer.stream = grunts[3]
		suffer.play()
	
	tim.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("punch") and picoday.keyed:
		punch()
