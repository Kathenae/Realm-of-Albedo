# Realm of Albedo
A simple "endless racer" game being developed using the godot engine. the goal is to
create a relaxing and immersive driving experience where the player feels no pressure to play,
a game that they can simply pickup the controller and drive...

# Progress So Far:

## Week 1 Progress
- [x] Road Generator
- [x] Scenery Along the road
- [x] Traffic Vehicles BOTS
- [x] Traffic Spawner
- [x] Player Vehicle Controller
- [x] Improved Player Vehicle Controller: Vehicle is no longer auto driving on the road path
- [x] Initial Vehicle models
- [x] Main Menu
- [x] Vehicle Purchase/Selection Menu
- [x] Vehicle Color Custumization Menu
- [x] BUGFIX: Changing a player vehicle's color also changes the traffic vehicles using the same mesh
- [x] Better Traffic Spawner
- [x] Support for different Types of Scenery
- [x] BUGFIX: Selected vehicle resets after returning to the main menu from the play scene

## Week 2 Progress
- [x] Refactor and Cleanup Code
- [x] BUGFIX: Traffic vehicles don't despawn once they reach the end of the road, they instead wrap back to the beginning
- [x] BUGFIX: Traffic vehicles would only spawn on two lanes
- [x] BUGFIX: Gaps on the road when there's tight turns (Caused by how i was triangulating the mesh, i needed a way to "share" vertices)
- [x] Add Ingame Screenshots Support
- [x] Foundation for the pickups system
- [x] Switching between follow and Fly Camera
- [x] Vehicle Health
- [x] Better Vehicla data handling, aka, create a class instead of using unnamed dictionaries (NOTE: Still saving data on dictionaries)
- [x] Display the name of a scenery when the player enters into a new scenery
- [x] Coin pickups
- [x] Achievements(Milestones,No Damage, Collection)
- [x] Saving and Loading Game Data (Done but needs some improvements)
- [x] Buying Vehicles
 
## Week 3 Progress:
- [x] Refactor and Cleanup Code
- [x] Bugfix: Vehicle selection not being saved/loaded properly 
- [x] Major Refactor: Make the VehicleFactory more generalized, currently it can only create vehicles for the player
- [x] Magnet Effector
- [ ] Shield Protection
- [ ] Speed Booster
- [ ] Implement Speed, Shield and Magnet Pickups
- [ ] 5 New vehicle models
- [ ] Vehicle Updrages, the upgrages include, engine upgrages(Speed), transmission(acceleration), handling (turning)
- [ ] Random npc drivers that have name's above them
- [ ] interacting/talking to npc's
- [ ] Challanges from npc's
- [ ] Add More Scenery types 
- [ ] Ambience sound based on the Scenery
- [ ] Despawning old road sections and everything related to it
  
 NOTE: Development Halted Indefinely 😑🙃
