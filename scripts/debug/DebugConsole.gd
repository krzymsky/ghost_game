extends Control

const warning_color = Color.crimson
const return_color  = Color.limegreen

var active = false;

onready var input_control  = $Container/Input
onready var output_control = $Container/Output

func _ready():
	set_active(false)
			
func _process(delta):
	if Input.is_action_just_pressed("ui_debug_console"):
		toggle_active_state()
	
func toggle_active_state():
	set_active(not active)

func set_active(_active):
	active = _active
	if active:
		show()
		input_control.grab_focus()
		input_control.clear()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false
		
func push_text_to_output(text):
	output_control.bbcode_text += text + "\n"

func process_command(text:String):
	text = text.strip_edges()
	var words = Array(text.split(" "))
	for w in words:
		words.erase("")
	
	if len(words) > 0:
		var command_name = words.pop_front()
		var command_return = execute_command(command_name, words)
		push_text_to_output(str(command_return))
	
func execute_command(name, args):
	var callback_name = "command_callback_" + name;
	if has_method(callback_name):
		var ret = callv(callback_name, [args])
		return "[color=#%s]%s[/color]" % [return_color.to_html(), ret]
	else:
		return "[color=#%s]command not found[/color]" % warning_color.to_html()

func _on_Input_text_entered(new_text):
	input_control.clear()
	push_text_to_output("> " + new_text)
	process_command(new_text)
	
# --- callback methods
func command_callback_debug_draw(args):
	if len(args) > 0:
		var value = bool(int(args[0]))
		GameGlobals.draw_debug = value
		return "debug_draw: " + str(value)
	else:
		return "[color=#%s]wrong arguments[/color]" % warning_color.to_html()
	
func command_callback_hello(args):
	return "world"
