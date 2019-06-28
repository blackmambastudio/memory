extends Control

var speed = 200
var open = false
var current_memory = 1
onready var memories = [$Memory1, $Memory2]

func _ready():
	var ActionRouter = get_node("/root/ActionRouter")
	ActionRouter.register_actions(self)

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		$PortionLight.position.x -= speed*delta
	if Input.is_action_pressed("ui_right"):
		$PortionLight.position.x += speed*delta
	if Input.is_action_pressed("ui_up"):
		$PortionLight.position.y -= speed*delta
	if Input.is_action_pressed("ui_down"):
		$PortionLight.position.y += speed*delta

func handle(request):
	match request.action:
		"Memory/current":
			match int(request.value):
				1:
					$Memory1.show()
					$Memory2.hide()
				2:
					$Memory1.hide()
					$Memory2.show()
					$Memory2.mouse_filter = Control.MOUSE_FILTER_STOP
			current_memory = request.value
		"Memory/show":
			open = request.value
			if open:
				$SFX_Memory_Open.playsound()
				memories[current_memory-1].visible = true
			else:
				$SFX_Memory_Close.playsound()
			$AnimationPlayer.play(
				"Show",
				-1, 1.0 if request.value else -1.0,
				!request.value
			)
			yield($AnimationPlayer, "animation_finished")
			if !open:
				memories[current_memory-1].visible = false
		"Memory/create":
			match int(request.id):
				1:
					$Memory1.createMemory(request.memory)
				2:
					$Memory2.createMemory(request.memory)
		"Memory/destroy":
			match int(request.id):
				1:
					$Memory1.destroyMemory(request.memory)
				2:
					$Memory2.destroyMemory(request.memory)
		"Memory/enable_only":
			match int(request.id):
				1:
					$Memory1.enableOnly(request.memories)
				2:
					$Memory2.enableOnly(request.memories)
		"Memory/disable_all":
			match int(request.id):
				1:
					$Memory1.disableAll()
				2:
					$Memory2.disableAll()
		"Memory/M2/clip_left":
			$Memory2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Memory2.clip_left()
			
		"Memory/M2/clip_right":
			$Memory2.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Memory2.clip_right()
		
		"Memory/M2/restore":
			$Memory2.clip_restore()
		
		"Memory/enable_real":
			match int(request.id):
				1:
					$Memory1.enableReal()
				2:
					$Memory2.enableReal()

		_:
			return false
			
#warning-ignore:unreachable_code
	return true
