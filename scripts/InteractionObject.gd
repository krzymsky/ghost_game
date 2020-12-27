extends Spatial

var active = false
var interacted = false
onready var Label = $Viewport/Control/Panel/Label

func _ready():
	var player = get_tree().get_root().find_node("PreacherCharacter",true,false)
	var controller = player.movement_controller
	controller.connect("interaction", self, "handleinteraction")

func handleinteraction():
	if active == true:
		interacted = true

func handle_state():
	# happens every frame, so "interacted" check is called multiple times despite the movement controller being set to "just_pressed" - needs a neater solution
	if active == true and interacted == false:
		Label.set_text("active")
	elif active == true and interacted == true:
		Label.set_text("interacted")
	else:
		Label.set_text("inactive") 

func _on_Area_body_entered(body):
	if body.has_method("set_interactability"):
		active = true
		body.set_interactability()

func _on_Area_body_exited(body):
	if body.has_method("set_interactability"):
		active = false
		body.set_interactability()

func _process(delta):
	handle_state()
