extends Spatial

onready var title = $ui/centerer/pico
onready var hint = $ui/hint

onready var fadester = $ui/fadester
onready var adios = $adios
onready var stuff = $ui/stuff
onready var punchy = $punch/AnimationPlayer

onready var logger = $ui/logger

const picoday = preload("res://src/picoday.tres")

var fade_out : bool = false
var count : int = 0

var passportUrl = null
var sanity_switch = true

func ng_unlock(id : int, funny : String) -> void:
	$NewGroundsAPI.Medal.unlock(id)
	var result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(result):
		print(funny)
	else:
		print(result)

# Ready to jack in. (that sounds funny)
func jackin():
	if picoday.keyed:
		OS.shell_open(passportUrl)
		passportUrl = null
		logger.visible = false

func _ready():
	fadester.color.a = 1.0
	stuff.self_modulate.a = 0.0
	
	if OS.get_name() == "HTML5":
		$NewGroundsAPI.App.startSession()
		var result = yield($NewGroundsAPI, 'ng_request_complete')
		if $NewGroundsAPI.is_ok(result):
			$NewGroundsAPI.session_id = result.response.session.id
			passportUrl = result.response.session.passport_url
			
			if result.response.session.expired:
				print('Session: Expired')
			else:
				print('Session: Valid')
		else:
			print(result.error)
		logger.connect("pressed", self, "jackin")
	else:
		logger.visible = false

func _process(delta):
	if picoday.locked:
		logger.visible = false
	if count != picoday.punches:
		count = picoday.punches
		if count == 276:
			$punch.translate(Vector3(0, 0, -1.25))
			if OS.get_name() == "HTML5":
				ng_unlock(63120, "Birthday boy shall NOT catch a break.")
		elif count == 1 and OS.get_name() == "HTML5":
			if OS.get_name() == "HTML5":
				ng_unlock(63119, "What a nice gift.")
		stuff.text = "punches: " + str(count)
		stuff.self_modulate = Color(1.0, 0.2, 0.2, 1.0)
		if punchy.is_playing():
			punchy.stop()
		punchy.play("punch")
	if picoday.locked:
		title.self_modulate.a = clamp(title.self_modulate.a - delta, 0.0, 1.0)
		hint.self_modulate.a = clamp(hint.self_modulate.a - delta, 0.0, 1.0)
		stuff.self_modulate.a = clamp(stuff.self_modulate.a + delta, 0.0, 1.0)
	fadester.color.a = clamp(fadester.color.a - (delta * 0.5), 0.0, 1.0)
	adios.volume_db = clamp(adios.volume_db + (delta * 5), -40.0, 0.0)
