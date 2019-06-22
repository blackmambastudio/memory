extends Control

var colliding = false
var car_speed = 100

func _ready():
	$Arrow.connect("area_entered", self, "car_entered")
	$Arrow.connect("area_exited", self, "car_exited")

func car_entered(area):
	colliding = true

func car_exited(area):
	colliding = false

func run_car():
	$Hidden.show()
	$Car.position.x = 50
	randomize()
	self.car_speed = randi()%150 + 100

func _process(delta):
	
	$Car.position.x += self.car_speed*delta
	if car_speed > 0 and Input.is_action_just_pressed("ui_accept"):
		self.stop_car()

func stop_car():
	print(colliding)
	$Hidden.hide()
	car_speed = 0
	if colliding:
		$AnimationPlayer.play("End_good")
	else:
		$AnimationPlayer.play("End")
	yield($AnimationPlayer, "animation_finished")
	self.run_car()
	
