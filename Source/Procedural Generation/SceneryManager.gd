extends Node

signal scenery_changed(new_scenery)

var last_scenery_index
var sceneries = []

# The scenery the player is currently in
var active_scenery

func setup():
	sceneries = get_children()
	
	for scenery in sceneries:
		scenery.setup()

func _on_road_generator_section_created(road_section, section_points, section_bases):
	# Create the Scenery
	var section_scenery = create_new_scenery(section_points,section_bases)
	road_section.set_meta("scenery", section_scenery)

func create_new_scenery(section_points,section_bases):
	
	var chosen_index = randi() % sceneries.size()
	
	# Make sure we don´t use the same scenery consecutively
	while chosen_index == last_scenery_index and sceneries.size() > 0:
		chosen_index = randi() % sceneries.size()
	
	last_scenery_index = chosen_index
	
	var scenery = sceneries[chosen_index]
	scenery.create_section(section_points,section_bases)
	print("[Scenery Manager] Created new Scenery ", scenery.name)
	return scenery

func _on_player_vehicle_moved_to_new_section(road_section):
	
	var scenery = road_section.get_meta("scenery")
	
	if scenery == active_scenery:
		return
	
	active_scenery = scenery
	emit_signal("scenery_changed",active_scenery)
