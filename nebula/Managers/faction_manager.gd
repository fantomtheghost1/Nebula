extends Node

var factions = []

func CreateFaction(faction_name):
	factions.append(Faction.new(faction_name, "DEV"))
