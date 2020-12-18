extends KinematicBody

const ANIMATIONS = {
	"idle": "preacher_mixamo_looking_around-loop",
	"walking": "preacher_mixamo_walking-loop"
}
var current_animation = ""

var movement_controller = preload("res://scripts/CharacterMovementController.gd").new()
var velocity = Vector3.ZERO

onready var animation_player = $Model/AnimationPlayer

func _ready():
	play_animation(ANIMATIONS.idle)
	DebugLayer.draw.add_property_vector(self, "velocity")
	#DebugLayer.draw.add_quad(self)
	
func _process(delta):
	movement_controller.handle_input(delta)
	movement_controller.velocity = move_and_slide(movement_controller.velocity, Vector3.UP)
	velocity = movement_controller.velocity
	rotation.y = movement_controller.rotation_dir
	
	if movement_controller.velocity != Vector3.ZERO:
		play_animation(ANIMATIONS.walking)
	else:
		play_animation(ANIMATIONS.idle)
	
func play_animation(animation):
	if current_animation != animation:
		current_animation = animation
		animation_player.play(current_animation)
