extends Node

var intro_scene = preload("res://Scenes/Cutscene.tscn")
var play_scene = preload("res://Scenes/Playscene.tscn")
var menu_scene = preload("res://Scenes/Menu.tscn")

# Player Data
var player_balance = 0
var player_highcore = 0
var max_magnets = 2
var max_shields = 2
var completed_achievements = {}

func _enter_tree():
	load_data()

func save_data():
	
	var save_file = File.new()
	var open_result = save_file.open("user://data.sav",File.WRITE)
	
	if open_result != OK:
		print("[Game Data] Couldn't save data")
		return
	
	var game_info = {
		"name" : "Demo",
		"version" : 0,
	}
	var player_data = {
		"highscore" : player_highcore,
		"balance" : player_balance,
		"completed_achievements" : completed_achievements,
	}
	
	save_file.store_line(JSON.print(game_info))
	save_file.store_line(JSON.print(player_data))
	
	PlayerGarage.save_data(save_file)
	
	save_file.close()

func load_data():
	
	var save_file = File.new()
	var open_result = save_file.open("user://data.sav",File.READ)
	
	if open_result != OK:
		print("[Game Data] Couldn't load data, is this the first time we're running the game?")
		return
	
	var game_info = JSON.parse(save_file.get_line()).result
	var player_data = JSON.parse(save_file.get_line()).result
	
	player_highcore = player_data.highscore
	player_balance = player_data.balance
	completed_achievements = player_data.completed_achievements
	
	PlayerGarage.load_data(save_file)
	
	save_file.close()
