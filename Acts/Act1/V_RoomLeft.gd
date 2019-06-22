extends "res://Acts/ViewScene.gd"

# possible status for claire
# 0
# 
func _ready():
	var claire_status = VariableBoard.suscribe("view_claire_status", self, "update_claire")
	update_claire(claire_status)

func update_claire(status):
	match status:
		"1":
			set_background("RoomLeft_claire1")
		"2":
			set_background("RoomLeft_claire2")
		"3":
			set_background("RoomLeft_claire3")
		"4":
			set_background("RoomLeft_claire4")
		"0":
			for child in $Backgrounds.get_children():
				child.visible = false
