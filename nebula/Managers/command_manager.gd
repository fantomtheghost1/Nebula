extends Node

var starbase_gen = preload("res://generators/starbase_generator.gd").new()
var asteroid_gen = preload("res://generators/asteroid_generator.gd").new()
var ship_gen = null

func Init(ship_generator):
	ship_gen = ship_generator
	
	# ----------------------
	#       GENERATORS
	# ----------------------
	Console.create_command("create_asteroid", asteroid_gen.CreateAsteroid, "Creates an asteroid at the given position with the given attributes. \nE.X: create_asteroid [x : float] [z : float] [size : String] [composition : String] \nSizes: small, medium, large, massive\nCompositions: magnesium_alloy, carbon_fiber, graphene, exotic_matter, titanium_alloy")
	Console.create_command("create_ship", ship_gen.CreateShip, "Creates a ship in the current scene at the given location, owned by the given player, and with the given attributes based on the ship_type id. \nE.X: create_ship [x : float] [z : float] [ship_type : String] [is_ai : bool = false] \nShip Types: dummy_zero, dummy_min_mining, dummy_min_combat, dummy_max_mining, dummy_max_combat")
	Console.create_command("create_faction", FactionManager.CreateFactionCommand, "Create a faction with a given name. \nE.X: create_faction [faction_name : String]")
	Console.create_command("create_starbase", starbase_gen.CreateStarbase, "Creates a starbase in the current scene at the given location, owned by the given player, and with the given attributes based on the starbase_type id. \nE.X: create_starbase [x : float] [z : float] [starbase_type : String] [starbase_level : int] \nStarbase Types: hq, mining_base, trade_hub, war_base \nStarbase Levels: 0-4")
	
	# ----------------------
	#        SETTERS
	# ----------------------
	Console.create_command("set_client_credits", SteamManager.client.SetCredits, "Sets the client's credits to the given amount. \nE.X: set_client_credits [amount : int]")
	
	# ----------------------
	#     SHIP COMMANDS
	# ----------------------
	Console.create_command("select_ship", GameManager.ChangePlayerShip, "Changes the player ship to the ship with the given id. \nE.X: change_player_ship [id : int]")
	Console.create_command("damage_ship", GameManager.DamageShip, "Damages a ship determined by id by the given amount. \nE.X: damage_ship [id : int] [damage_amount : int]")
	Console.create_command("teleport", GameManager.Teleport, "Teleports the selected ship to the given coordinates. \nE.X: teleport [id : int] [x : int] [z : int]")
	Console.create_command("warp", GameManager.WarpCommand, "Warps to the given system. \nE.X: warp [ship_id : int] [system_id? : int] [system_name? : String]")
	
	# ----------------------
	#    FACTION COMMANDS
	# ----------------------
	Console.create_command("join_faction", FactionManager.JoinFactionCommand, "Adds the given captain as a member of the given faction. \nE.X: join_faction [faction_name : String] [captain_id : int]")
	Console.create_command("kick_faction", FactionManager.KickFactionCommand, "Kicks the given captain as a member of the given faction. \nE.X: kick_faction [faction_name : String] [captain_id : int]")
	
	# ----------------------
	#        GETTERS
	# ----------------------
	Console.create_command("asteroids", GameManager.GetAsteroidsCommand, "Gets all the asteroids in the scene.")
	Console.create_command("ships", GameManager.GetShipsCommand, "Gets all the ships in the scene.")
	Console.create_command("systems", GameManager.GetSystemsCommand, "Gets all the systems in the scene.")
	Console.create_command("relays", GameManager.GetRelaysCommand, "Gets all the relays in the scene.")
	Console.create_command("captains", CaptainManager.GetCaptainsCommand, "Gets all the active captains in the scene.")
	Console.create_command("starbases", GameManager.GetStarbasesCommand, "Gets all the starbases in the scene.")
	Console.create_command("factions", FactionManager.GetFactionsCommand, "Gets all the factions in the scene.")
	Console.create_command("faction_members", FactionManager.GetFactionMembersCommand, "Gets all the faction members within a faction. \nE.X: get_faction_members [faction_name : String]")
