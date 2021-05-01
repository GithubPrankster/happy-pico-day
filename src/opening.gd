extends Spatial

onready var title = $ui/centerer/pico
onready var fadester = $ui/fadester
onready var adios = $adios
onready var stuff = $stuff
onready var punchy = $punch/AnimationPlayer

const picoday = preload("res://src/picoday.tres")

var fade_out : bool = false
var count : int = 0

var passportUrl = null
var sanity_switch = true

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
		if !sanity_switch:
			OS.shell_open(passportUrl)
			passportUrl = null

func _process(delta):
	if count != picoday.punches:
		count = picoday.punches
		if count == 276:
			$punch.translate(Vector3(0, 0, -1.25))
			if OS.get_name() == "HTML5":
				$NewGroundsAPI.Medal.unlock(63120)
				var result = yield($NewGroundsAPI, 'ng_request_complete')
				if $NewGroundsAPI.is_ok(result):
					print("Birthday boy shall NOT catch a break.")
				else:
					print(result)
		elif count == 1 and OS.get_name() == "HTML5":
			$NewGroundsAPI.Medal.unlock(63119)
			var result = yield($NewGroundsAPI, 'ng_request_complete')
			if $NewGroundsAPI.is_ok(result):
				print("What a nice gift.")
			else:
				print(result)
		stuff.text = "punches: " + str(count)
		stuff.self_modulate = Color(1.0, 0.2, 0.2, 1.0)
		if punchy.is_playing():
			punchy.stop()
		punchy.play("punch")
	if picoday.keyed:
		title.self_modulate.a = clamp(title.self_modulate.a - delta, 0.0, 1.0)
		stuff.self_modulate.a = clamp(stuff.self_modulate.a + delta, 0.0, 1.0)
	fadester.color.a = clamp(fadester.color.a - (delta * 0.5), 0.0, 1.0)
	adios.volume_db = clamp(adios.volume_db + (delta * 5), -40.0, 0.0)
