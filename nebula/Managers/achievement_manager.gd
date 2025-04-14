extends Node

var achievements = {
	"DEBUG_RELAY" : 
		{
			"RELAYS_USED" : 0,
			"ACHIEVEMENT_COMPLETED" : false
		}
}

#func _ready():
#	Steam.resetAllStats(true)

func GetAchievements():
	return achievements

func CompleteAchievement(achievement : String):
	
	if !achievements[achievement].ACHIEVEMENT_COMPLETED:
		achievements[achievement].ACHIEVEMENT_COMPLETED = true
		Steam.setAchievement(achievement)
		Steam.storeStats()
	else:
		print("you already have this achievement")

func ProgressAchievement(achievement : String, amount : int):
	if !achievements[achievement].ACHIEVEMENT_COMPLETED:
		achievements[achievement].RELAYS_USED += amount
		print(achievements[achievement].RELAYS_USED)
		Steam.setStatInt("RELAYS_USED", achievements[achievement].RELAYS_USED)
		
		if achievements[achievement].RELAYS_USED > 3:
			Steam.setAchievement(achievement)
			
		Steam.storeStats()
		print(Steam.getStatInt("RELAYS_USED"))
