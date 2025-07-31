extends Path2D
class_name Hand

var curve_length

func _ready():
	update_card_positions()

func update_card_positions():
	curve.get_baked_points()
	curve_length = curve.get_baked_length()
	
	for i in range(get_child_count()):
		if get_child_count() == 1:
			var pos = curve.sample_baked(curve_length/2)
			
			get_child(i).target_position = pos
		else:
			var pos_along_curve = i / float(get_child_count() - 1)
			var dist = pos_along_curve * curve_length
			var pos = curve.sample_baked(dist)
			
			get_child(i).target_position = pos
