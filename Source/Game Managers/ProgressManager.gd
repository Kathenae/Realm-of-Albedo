# Responsible for tracking the progress of the game and notifying interested component abouts that,
# progress may include, the player died or not, if a new milestone or record have been broken, etc

extends Node

signal level_started(level_goals)
signal miles_traveled_changed(new_milage)
signal new_achievement(achievement)
signal achievement_progress(name,progress_percent)
signal coins_changed(new_count)

var miles_traveled = 0.0
var collected_amount = 0
var player : PlayerVehicle

# Reach a certain distance away from the 
var milestone_achievements = [
	{
		"id" : "milestone_0",
		"type" : "milestone",
		"name" : "Baby Steps",
		"short_description" : "Travel 5,000 miles",
		"complete_message" : "You've reached the 5,000 miles mark, Keep Going!",
		"target" : 5000,
		"current" : 0,
		"reward" : 2000,
	},
	{
		"id" : "milestone_1",
		"type" : "milestone",
		"name" : "Getting Somewhere",
		"short_description" : "Travel 10,000 miles",
		"complete_message" : "You've reached the 10,000 miles mark!",
		"target" : 10000,
		"current" : 0,
		"reward" : 4000
	},
	{
		"id" : "milestone_2",
		"type" : "milestone",
		"name" : "Onwards and Away",
		"short_description" : "Travel 20,000 miles",
		"complete_message" : "You've reached the 20,000 miles mark\nCongratulations",
		"target" : 20000,
		"current" : 0,
		"reward" : 8000
		
	},
	{
		"id" : "milestone_3",
		"type" : "milestone",
		"name" : "Steady Progress",
		"short_description" : "Travel 50,000 miles",
		"complete_message" : "You've reached the 50,000 miles mark",
		"target" : 50000,
		"current" : 0,
		"reward" : 16000
		
	},
	{
		"id" : "milestone_4",
		"type" : "milestone",
		"name" : "Far From Home",
		"short_description" : "Travel 80,000 miles",
		"complete_message" : "You've reached the 80,000 miles mark",
		"target" : 80000,
		"current" : 0,
		"reward" : 20000
	}
]

# Reach a certain milage without getting damaged
var damage_achievements = [
	{
		"id" : "safety_0",
		"type" : "safety",
		"name" : "Staying Safe!",
		"short_description" : "Avoid Traffic for 2,000 miles",
		"complete_message" : "You've traveled 2,000 miles without hitting any traffic", 
		"target" : 2500,
		"current" : 0,
		"reward" : 2500,
	},
	{
		"id" : "safety_1",
		"type" : "safety",
		"name" : "Staying Extra Safe",
		"short_description" : "Avoid Traffic for 5,000 miles",
		"complete_message" : "You just travelled 5,000 miles without hitting any traffic",
		"target" : 5000,
		"current" : 0,
		"reward" : 5000,
	},
	{
		"id" : "safety_2",
		"type" : "safety",
		"name" : "Careful Driver",
		"short_description" : "Avoid Traffic for 7,000 miles",
		"complete_message" : "You just travelled 7,000 miles without hitting any traffic!",
		"target" : 7000,
		"current" : 0,
		"reward" : 7000,
	},
	{
		"id" : "safety_3",
		"type" : "safety",
		"name" : "Safety First",
		"short_description" : "Avoid Traffic for 10,000 miles",
		"complete_message" : "You travelled the 10,000 miles without hitting any traffic!",
		"target" : 10000,
		"current" : 0,
		"reward" : 10000,
	},
	{
		"id" : "safety_4",
		"type" : "safety",
		"name" : "A Perfect Run",
		"short_description" : "Avoid Traffic for 15,000 miles",
		"complete_message" : "Wow! 15,000 miles without hitting a single vehicle!",
		"target" : 15000,
		"current" : 0,
		"reward" : 15000,
	}
]

# Collect a certain amount of coins in a single run
var collector_achievements = [
	{
		"id" : "collector_0",
		"type" : "collector",
		"name" : "First of many",
		"short_description" : "Collect 100 coins",
		"complete_message" : "Collect your first 100 coins in a single run", 
		"target" : 100,
		"current" : 0,
		"reward" : 1000,
	},
	{
		"id" : "collector_1",
		"type" : "collector",
		"name" : "A Decent pay",
		"short_description" : "Collect 250 coins",
		"complete_message" : "Collect 250 coins in a single run!", 
		"target" : 250,
		"current" : 0,
		"reward" : 500,
	},
	{
		"id" : "collector_2",
		"type" : "collector",
		"name" : "The Wealth is Near",
		"short_description" : "Collect 500 coins",
		"complete_message" : "Collect 500 coins in a single run", 
		"target" : 500,
		"current" : 0,
		"reward" : 1000,
	},
	{
		"id" : "collector_3",
		"type" : "collector",
		"name" : "Struck Gold!",
		"short_description" : "Collect a 1000 coins",
		"complete_message" : "Collect a 1000 coins in a single run", 
		"target" : 1000,
		"current" : 0,
		"reward" : 3000,
	},
]

# Maybe add a goal to reach a certain milage under some time limit
# but this type of goals might not be ideal for the chill
# and laid back mood we're trying to create in this game

var levels = [
	# Level 1
	[milestone_achievements[0], collector_achievements[0]],
	
	# Level 2
	[milestone_achievements[1], damage_achievements[0]],
	
	# Level 3
	[damage_achievements[1], collector_achievements[2]],
	
	# Level 4
	[ milestone_achievements[2], damage_achievements[2]],
	
	# Level 5
	[collector_achievements[3], damage_achievements[3]],
]

var current_level_index = 0;
var current_level = levels[current_level_index]

func setup(player_vehicle : PlayerVehicle):
	emit_signal("coins_changed",GameData.player_balance)
	emit_signal("level_started", current_level)
	self.player = player_vehicle

func _process(delta):
	process_milage(delta)

func process_milage(_delta : float):
	var new_milage = get_current_milage()
	
	if new_milage > miles_traveled:
		
		var mile_displacement = new_milage - miles_traveled;
		
		process_displacement_achievements(mile_displacement)
		check_for_highscore(new_milage)
	
		miles_traveled = new_milage
		emit_signal("miles_traveled_changed",new_milage)
		

func get_current_milage():
	return player.current_point_index * 3

func _on_pickup_manager_collected(pickup_type, pickup_node):
	
	if pickup_type == Pickup.Type.COIN:
		GameData.player_balance += 1
		emit_signal("coins_changed",GameData.player_balance)
		collected_amount += 1
		
		process_pickup_achievements(1)

func process_displacement_achievements(miles_displacement : float):
	
	var displacement_achievements = milestone_achievements + damage_achievements
	
	for achievement in current_level:
		
		if achievement.type == "milestone" or achievement.type == "safety":
			achievement.current += miles_displacement
			notify_achievement_progress(achievement)
			try_finishing_achievent(achievement)
		
	

func process_pickup_achievements(amount_collected):
	
	for achievement in current_level:
		
		if achievement.type == "collector":
			achievement.current += amount_collected
			notify_achievement_progress(achievement)
			try_finishing_achievent(achievement)
	

func _on_player_damaged(percent_left):
	
	for achievement in current_level:
		
		if achievement.type == "safety":
			achievement.current = 0
			notify_achievement_progress(achievement)
	

func notify_achievement_progress(achievement):
	var progress_percent = inverse_lerp(0,achievement.target, achievement.current)
	emit_signal("achievement_progress",achievement,progress_percent)

func try_finishing_achievent(achievement):
	if achievement.current >= achievement.target and is_achievement_complete(achievement) == false:
		mark_achievement_as_complete(achievement)
		notify_achievemnt_completed(achievement)
		apply_achievement_reward(achievement)
		try_start_new_level(achievement)
	elif is_achievement_complete(achievement):
		try_start_new_level(achievement)

func try_start_new_level(achievement):
	
	if current_level.has(achievement):
		current_level.erase(achievement)
	
	for achivement in current_level:
		if is_achievement_complete(achievement) == false:
			return
	
	current_level_index += 1
	current_level = levels[current_level_index]
	emit_signal("level_started", current_level)
	
	GameData.save_data()


func notify_achievemnt_completed(achievement):
	emit_signal("new_achievement",achievement)

func apply_achievement_reward(achievement):
	GameData.player_balance += achievement.reward
	emit_signal("coins_changed",GameData.player_balance)

func mark_achievement_as_complete(achievement):
	GameData.completed_achievements[achievement.id] = true
	GameData.save_data()

func is_achievement_complete(achievement):
	return  GameData.completed_achievements.has(achievement.id)



## HIGHSCORE STUFF

var target_to_beat = null
var has_beat_highscore
var new_highscore_played = false

func check_for_highscore(new_milage : float):
	
	if target_to_beat == null:
		target_to_beat = GameData.player_highcore * 2
		
		if target_to_beat == 0:
			target_to_beat = 8000
	
	if new_milage > GameData.player_highcore:
		
		if GameData.player_highcore == 0:
			new_highscore_played = true
		
		GameData.player_highcore = new_milage
		
		if new_highscore_played == false:
			var milestone = {"name" : "Breaking Bounds", "complete_message" : "You've passed your highscore!"}
			emit_signal("new_achievement",milestone)
			new_highscore_played = true
			target_to_beat = GameData.player_highcore * 2
			GameData.save_data()
	
	if new_milage > target_to_beat and target_to_beat != 0:
		var milestone = {"name" : "New Frontiers", "complete_message" : "Congratulations! You've traveled further than ever, Keep Going!"}
		emit_signal("new_achievement",milestone)
		target_to_beat = GameData.player_highcore * 2
		GameData.save_data()
