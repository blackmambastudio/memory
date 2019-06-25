extends "res://Acts/ViewScene.gd"

# possible status for lucia
# 0
# 
func _ready():
	var lucia_status = VariableBoard.suscribe("view_lucia_status", self, "update_lucia")
	update_lucia(lucia_status)

func update_lucia(status):
	match status:
		"1":
			set_background("Kitchen_lucia1")
		"2":
			set_background("Kitchen_lucia2")
		"3":
			set_background("Kitchen_lucia3")
		"0":
			for child in $Backgrounds.get_children():
				child.visible = false

func lock_view():
	$ChangeZones/to_left.visible = false
	$ChangeZones/to_right.visible = false