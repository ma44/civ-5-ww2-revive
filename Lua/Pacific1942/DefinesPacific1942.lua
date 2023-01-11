-- DefinesPacific1942
-- Author: bacononaboat
-- DateCreated: 3/23/2017
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

print("Loading Pacific Defines...")
print("-------------------------------------")

----------------------------------------------------------------------------------------------------------------------------
-- Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

REVEAL_ALL_CITIES				= true	-- cities tiles are always visible for every civs
EMBARK_FROM_HARBOR				= true	-- allow embarking only from a city with a port (and adjacent tiles)
BEACHHEAD_DAMAGE				= true	-- Amphibious assault on an empty tile owned by enemy civ will cause damage to the landing unit (not implemented)
CLOSE_MINOR_NEUTRAL_CIV_BORDERS = true	-- if true neutral territories is impassable
RESOURCE_CONSUMPTION			= true	-- Use resource consumption (fuel, ...)
SCENARIO_MATERIEL_PER_TURN		= 500
SCENARIO_PERSONNEL_PER_TURN		= 350
SCENARIO_OIL_PER_TURN			= 100
SCENARIO_MAX_MATERIEL_BONUS		= 2500
SCENARIO_MAX_OIL_BONUS			= 5000
SCENARIO_MAX_PERSONNEL_BONUS	= 2500

----------------------------------------------------------------------------------------------------------------------------
-- AI Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

ALLOW_AI_CONTROL			= true
NO_AI_EMBARKATION			= true -- remove AI ability to embark (to do : take total control of AI unit to embark)
NO_SUICIDE_ATTACK			= true -- If set to true, try to prevent suicide attacks
UNIT_SUPPORT_LIMIT_FOR_AI	= true -- Allow limitation of max number of AI units based on number of supported units
	
AI_LAND_MINIMAL_RESERVE		= 15	
AI_AIR_MINIMAL_RESERVE		= 10	
AI_SEA_MINIMAL_RESERVE		= 8	

----------------------------------------------------------------------------------------------------------------------------
-- Calendar
----------------------------------------------------------------------------------------------------------------------------

REAL_WORLD_ENDING_DATE	= 19470105
--MAX_FALL_OF_FRANCE_DATE = 19420101 -- France will not surrender if Paris fall after this date...

if(PreGame.GetGameOption("PlayEpicGame") ~= nil) and (PreGame.GetGameOption("PlayEpicGame") > 0) then
	g_Calendar = {}
	local monthList = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local dayList = { "1", "5", "10", "15", "20", "25" }
	local turn = 0
	for year = 1942, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 1 and year == 1942) -- Start date !
				if bStart or (year > 1939) then
					local numMonth, numDay
					if month < 10 then numMonth = "0"..month; else numMonth = month; end
					if tonumber(dayList[day]) < 10 then numDay = "0"..dayList[day]; else numDay = dayList[day]; end
					g_Calendar[turn] = { Text = monthList[month] .. " " .. dayList[day] .. ", " .. year, Number = tonumber(year..numMonth..numDay)}
					turn = turn + 1
				end		
			end
		end
	end
end

if(PreGame.GetGameOption("PlayEpicGame") ~= nil) and (PreGame.GetGameOption("PlayEpicGame") == 0) then
	g_Calendar = {}
	local monthList = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local dayList = { "1"}
	local turn = 0
	for year = 1942, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 1 and year == 1942) -- Start date !
				if bStart or (year > 1939) then
					local numMonth, numDay
					if month < 10 then numMonth = "0"..month; else numMonth = month; end
					if tonumber(dayList[day]) < 10 then numDay = "0"..dayList[day]; else numDay = dayList[day]; end
					g_Calendar[turn] = { Text = monthList[month] .. " " .. dayList[day] .. ", " .. year, Number = tonumber(year..numMonth..numDay)}
					turn = turn + 1
				end		
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- Minor Civs ID
-- Must be scenario specific to allow replacing of a major civ reference by a minor...
----------------------------------------------------------------------------------------------------------------------------

CANADA		= GameInfo.MinorCivilizations.MINOR_CIV_CANADA.ID
--CHINA		= GameInfo.MinorCivilizations.MINOR_CIV_CHINA.ID
MEXICO		= GameInfo.MinorCivilizations.MINOR_CIV_MEXICO.ID
MONGOLIA	= GameInfo.MinorCivilizations.MINOR_CIV_MONGOLIA.ID
NETHERLANDS = GameInfo.MinorCivilizations.MINOR_CIV_NETHERLANDS.ID
AUSTRALIA = GameInfo.MinorCivilizations.MINOR_CIV_AUSTRALIA.ID
NEWZEALAND = GameInfo.MinorCivilizations.MINOR_CIV_NEWZEALAND.ID
THAILAND	= GameInfo.MinorCivilizations.MINOR_CIV_THAILAND.ID
--USSR		= GameInfo.MinorCivilizations.MINOR_CIV_USSR.ID


----------------------------------------------------------------------------------------------------------------------------
-- Buildings (see RedDefines.lua for IDs)
----------------------------------------------------------------------------------------------------------------------------

-- no override here, use default tables from RedDefines.lua...

----------------------------------------------------------------------------------------------------------------------------
-- Units (see RedDefines.lua for IDs)
----------------------------------------------------------------------------------------------------------------------------
-- Modifier for maintenance free units
g_Units_Maintenance_Modifier = {
	[ENGLAND] = 20,
	[USSR] = 30,
	[AMERICA] = 30,
	[JAPAN] = 60,
	[CHINA] = 20,
}

-- Combat type ratio restriction used by AI
g_Combat_Type_Ratio = { 
	-- Air		<= military units / air units
	-- Sea		<= military units / sea units
	-- Land		<= military units / land units
	-- ( 1 = no limit )
	[ENGLAND]	= {Air = 100,	Sea = 100,	Land = 1.1,	},--Air = 4
	[USSR]		= {Air = 10,	Sea = 10,	Land = 1.2,	},--Air = 5
	[AMERICA]	= {Air = 8,		Sea = 4,	Land = 1.4,	},--Air = 4
	[JAPAN]		= {Air = 8,		Sea = 5,	Land = 1.6,	},--Air = 5
	[CHINA]		= {Air = 100,	Sea = 100,	Land = 1.4,	},--Air = 4
	[MINOR]		= {Air = 10,	Sea = 5,	Land = 1.6,	},--Air = 5
}

-- Land type ratio restriction used by AI
g_Max_Land_SubClass_Percent = {		-- max num	<= land units / type units possible
	[ENGLAND]	= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 3, [CLASS_MECHANIZED_INFANTRY] = 3, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 15, [CLASS_CRUISER_TANK] = 20, [CLASS_TANK] = 10, [CLASS_HEAVY_TANK] = 10, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 0,	},	
	
	[USSR]		= {	[CLASS_INFANTRY] = 25, [CLASS_INFANTRY_2] = 5, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 5, [CLASS_CRUISER_TANK] = 6, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 7, [CLASS_LIGHT_TANK_DESTROYER] = 3, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 4,	},	

	[AMERICA]	= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 5, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 5,	
				[CLASS_LIGHT_TANK] = 15, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 25, [CLASS_HEAVY_TANK] = 5, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 5,  [CLASS_ASSAULT_GUN] = 0,	},	
	
	[JAPAN]		= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 3,	
				[CLASS_LIGHT_TANK] = 20, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 15, [CLASS_LIGHT_TANK_DESTROYER] = 5, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 2,	},	
	
	[CHINA]		= {	[CLASS_INFANTRY] = 40, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 25,  [CLASS_AA_GUN] = 0,	
				[CLASS_LIGHT_TANK] = 30, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 0, [CLASS_HEAVY_TANK] = 0, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 0,	},	

}

-- Air type ratio restriction used by AI
g_Max_Air_SubClass_Percent = {		-- max num	<= air units / type units possible
	[ENGLAND]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 10,	},
	[USSR]		= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 10,	},
	[AMERICA]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 10, [CLASS_ATTACK_AIRCRAFT] = 0,  [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 20, [CLASS_HEAVY_BOMBER] = 20,	},
	[JAPAN]		= { [CLASS_FIGHTER] = 50, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 10, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 0,	},
	[CHINA]		= {	[CLASS_FIGHTER] = 60, [CLASS_FIGHTER_BOMBER] = 0,  [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 0,  [CLASS_FAST_BOMBER] = 0,  [CLASS_BOMBER] = 40, [CLASS_HEAVY_BOMBER] = 0,	},
}

-- Sea type ratio restriction used by AI
g_Max_Sea_SubClass_Percent = {
		-- max num	<= sea units / type units possible
	[ENGLAND]	= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 5, [CLASS_BATTLESHIP] = 10,	 [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 15, [CLASS_SUBMARINE_2] = 10,	[CLASS_CARRIER] = 5,},
	[USSR]		= {	[CLASS_DESTROYER] = 30, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 20, [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 0,},
	[AMERICA]	= {	[CLASS_DESTROYER] = 15, [CLASS_DESTROYER_2] = 10, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 5,},
	[JAPAN]		= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 25, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 20, [CLASS_SUBMARINE_2] = 5,	[CLASS_CARRIER] = 5,},
	[CHINA]		= {	[CLASS_DESTROYER] = 0,  [CLASS_CRUISER] = 0,  [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 0,  [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 0,	[CLASS_CARRIER] = 0,},
}


-- Order of Battle
-- group size = 7 units max placed in (and around) plot (x,y), except air placed only in central plot (should be city plot)
-- we can initialize any units for anyone here, no restriction by nation like in build list
g_Initial_OOB = { 
	{Name = "British Indian Army", X = 18, Y = 47, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, AT_GUN, AT_GUN, ARTILLERY, UK_A24}, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "British Hong Kong Garrison", X = 33, Y = 47, Domain = "City", CivID = ENGLAND, Group = {UK_INFANTRY}, UnitsXP = {9}  },
	{Name = "British Singapore Garrison", X = 24, Y = 32, Domain = "City", CivID = ENGLAND, Group = {UK_INFANTRY}, UnitsXP = {9}  },
	{Name = "British Indian Aviation", X = 8, Y = 49, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE_V, UK_SPITFIRE_V}, UnitsXP = {9,9}  },
	{Name = "British Pacific Navy", X = 26, Y = 32, Domain = "Sea", CivID = ENGLAND, Group = {UK_J, UK_LEANDER, UK_BATTLESHIP_2}, UnitsName = { "HMS Jupiter", "HMS Leander", "HMAS Prince of Wales"}, UnitsXP = {9,9,9}  },
	{Name = "B One", X = 17, Y = 47, Domain = "Land", CivID = ENGLAND, Group = {FORTIFIED_GUN}, UnitsName = {"Bunker One"},  },
	{Name = "B Two", X = 18, Y = 46, Domain = "Land", CivID = ENGLAND, Group = {FORTIFIED_GUN}, UnitsName = {"Bunker Two"},  },
		

	{Name = "Japanese Home Army", X = 45, Y = 57, Domain = "Land", CivID = JAPAN, Group = {JP_INFANTRY, JP_INFANTRY}, UnitsXP = {9,9}  }, 
	{Name = "Japan-China Army North", X = 32, Y = 62, Domain = "City", CivID = JAPAN, Group = {JP_INFANTRY, AT_GUN, JP_INFANTRY, ARTILLERY, JP_INFANTRY, AT_GUN}, UnitsXP = {9,9,9,9,9,9}  },
	{Name = "Japan-China Army Mid", X = 33, Y = 57, Domain = "Land", CivID = JAPAN, Group = {JP_INFANTRY, AT_GUN, JP_INFANTRY, ARTILLERY, JP_INFANTRY, AT_GUN, JP_TYPE1}, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "Japan-China Army South", X = 27, Y = 46, Domain = "Land", CivID = JAPAN, Group = {JP_INFANTRY, AT_GUN, JP_INFANTRY, ARTILLERY, JP_INFANTRY, AT_GUN}, UnitsXP = {9,9,9,9,9,9} },	
	{Name = "Japan Phillipines Assault", X = 34, Y = 43, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY, JP_INFANTRY}, UnitsXP = {9,9}  },
	{Name = "Japan Japyara Garrison", X = 45, Y = 26, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY, JP_INFANTRY, AT_GUN}, UnitsXP = {9,9,9} },
	{Name = "Japan Guam Garrison", X = 49, Y = 41, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9}  },
	{Name = "Japan Wake Garrison", X = 63, Y = 42, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9}  },
	{Name = "Japan Iwo Garrison", X = 49, Y = 50, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9} },
	{Name = "Japan Okinawa Garrison", X = 39, Y = 52, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9} },
	{Name = "Japan Saipan Garrison", X = 50, Y = 43, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9}  },
	{Name = "Japan Palau Garrison", X = 45, Y = 37, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9}  },
	{Name = "Japan Tarawa Garrison", X = 56, Y = 34, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {9}  },
	{Name = "Japan Manadao Garrison", X = 37, Y = 32, Domain = "City", CivID = JAPAN,  Group = {JP_INFANTRY, JP_INFANTRY}, UnitsXP = {9,9}  },
	{Name = "Japan Banjarmsin Assault", X = 32, Y = 30, Domain = "Land", CivID = JAPAN, Group = {JP_INFANTRY, JP_INFANTRY, ARTILLERY}, UnitsXP = {9,9,9}  },
	{Name = "Japan Home Air", X = 45, Y = 57, Domain = "Air", CivID = JAPAN, Group = {JP_KI43, JP_KI43, JP_KI51, JP_KI44, JP_KI44, JP_KI51}, UnitsXP = {9,9,9,9,9,9}  },
	{Name = "Japan Shanghai Air", X = 35, Y = 52, Domain = "Air", CivID = JAPAN, Group = {JP_KI43, JP_KI43, JP_KI51, JP_AICHI}, UnitsXP = {9,9,9,9}  },
	{Name = "Japan Jaypara Air", X = 44, Y = 27, Domain = "Air", AI = true, CivID = JAPAN, Group = {JP_A6M2, JP_A6M2, JP_KI21, JP_KI21}, UnitsXP = {9,9,9,9}  },
	{Name = "Japan Home Fleet", X = 42, Y = 61, Domain = "Sea", CivID = JAPAN, Group = {JP_KAGERO, JP_KAGERO, JP_BATTLESHIP_2, JP_BATTLESHIP, JP_BATTLESHIP, JP_TAKAO, JP_TAKAO}, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "Japan Home Fleet Auxillary", X = 42, Y = 61, Domain = "Sea", AI = true, CivID = JAPAN, Group = {JP_KAGERO, JP_KAGERO, JP_BATTLESHIP_2, JP_BATTLESHIP, JP_BATTLESHIP, JP_SUBMARINE, JP_SUBMARINE}, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "Japan Palau Fleet", X = 44, Y = 39, Domain = "Sea", CivID = JAPAN, Group = {JP_KAGERO, JP_KAGERO, JP_KAGERO, JP_MYOKO, JP_MYOKO, JP_SUBMARINE, JP_SUBMARINE }, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "Japan Guadalcanal Fleet", X = 59, Y = 21, Domain = "Sea", AI = true, CivID = JAPAN, Group = {JP_KAGERO, JP_KAGERO, JP_SUBMARINE, JP_SUBMARINE }, UnitsXP = {9,9,9,9}  },
	{Name = "Jakarta Invasion 1", X = 28, Y = 24, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {15}, },	
	{Name = "Jakarta Invasion 2", X = 28, Y = 24, Domain = "Land", AI = true, CivID = JAPAN, Group = {ARTILLERY}, UnitsXP = {15}, },	
	{Name = "Medan Invasion", X = 21, Y = 31, Domain = "Land", CivID = JAPAN, Group = {JP_INFANTRY, JP_INFANTRY, ARTILLERY}, UnitsXP = {15, 15, 15}, },		
	{Name = "Timor Invasion 1", X = 37, Y = 24, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {15}, },		
	{Name = "Timor Invasion 2", X = 37, Y = 24, Domain = "Land", AI = true, CivID = JAPAN, Group = {ARTILLERY}, UnitsXP = {15}, },		
	{Name = "Singapore Invasion 1", X = 23, Y = 33, Domain = "Land", AI = true, CivID = JAPAN, Group = {JP_INFANTRY}, UnitsXP = {15}, },	
	{Name = "Singapore Invasion 2", X = 23, Y = 33, Domain = "Land", AI = true, CivID = JAPAN, Group = {ARTILLERY}, UnitsXP = {15}, },	
	{Name = "Davao Invasion 1", X = 38, Y = 37, Domain = "Land", AI = true, CivID = JAPAN,	Group = {JP_INFANTRY}, UnitsXP = {15}, },	
	{Name = "Davao Invasion 2", X = 38, Y = 37, Domain = "Land", AI = true, CivID = JAPAN, Group = {ARTILLERY}, UnitsXP = {15}, },	


	{Name = "American Home Army", X = 103, Y = 55, Domain = "Land", CivID = AMERICA, Group = {US_INFANTRY, US_INFANTRY, US_INFANTRY, AT_GUN, AT_GUN, ARTILLERY, US_SHERMAN}, UnitsXP = {9,9,9,9,9,9,9}  },
	{Name = "American Aviation West Coast", X = 102, Y = 54, Domain = "Air", CivID = AMERICA, Group = {US_P40, US_P40}, UnitsXP = {9,9}  },
	{Name = "American West Coast Navy", X = 99, Y = 54, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_BATTLESHIP}, UnitsXP = {9,9,9,9}  },
	{Name = "American Pearl Harbor Navy", X = 77, Y = 42, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9}  },
	{Name = "American Noumea Navy", X = 58, Y = 15, Domain = "Sea", AI = true, CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_SUBMARINE}, UnitsXP = {9,9,9}  },

	{Name = "Chinese Chunking Army", X = 30, Y = 52, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, ARTILLERY, CH_INFANTRY}, UnitsXP = {9,9,9,9}  },
	{Name = "Chinese Taiuan Army", X = 30, Y = 56, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, ARTILLERY, CH_INFANTRY}, UnitsXP = {9,9,9,9}  },
	
	{Name = "Dutch Banjarmasin Fleet", X = 30, Y = 28, Domain = "Sea", CivID = NETHERLANDS, IsMinor = true, Group = {DESTROYER, CRUISER, SUBMARINE, SUBMARINE}, UnitsXP = {9,9,9,9}  },
	{Name = "Banjarmasin Garrison", X = 32, Y = 29, Domain = "Land", CivID = NETHERLANDS, IsMinor = true, Group = {INFANTRY}, UnitsXP = {9}  },
	{Name = "Medan Garrison", X = 21, Y = 32, Domain = "Land", CivID = NETHERLANDS, IsMinor = true, Group = {INFANTRY}, UnitsXP = {9}  },
}

g_MinorMobilization_OOB = { 
	{Name = "Port Moresby Garrison", X = 47, Y = 24, Domain = "Land", CivID = AUSTRALIA, IsMinor = true, Group = {INFANTRY, INFANTRY, ARTILLERY}, UnitsName = {"1st Australian Infantry Divison", "2nd Australian Infantry Divison", "1st Australian Artillery Regiment"}, UnitsXP = {9,9,9}  },
	{Name = "Sydney Garrison", X = 48, Y = 9, Domain = "Land", CivID = AUSTRALIA, IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY, AT_GUN, AT_GUN}, UnitsName = {"3rd Australian Infantry Divison", "4th Australian Infantry Divison", "5th Australian Infantry Divison", "2nd Australian Artillery Regiment", "3rd Australian Artillery Regiment"}, UnitsXP = {9,9,9,9,9}  },
	{Name = "Australia Fleet", X = 44, Y = 22, Domain = "Sea", CivID = AUSTRALIA, IsMinor = true, Group = {UK_TRIBA, UK_TRIBA, UK_PERTH, UK_PERTH}, UnitsName = {"HMAS Warramunga", "HMAS Arunta", "HMAS Sydney", "HMAS Perth"}, UnitsXP = {9,9,9,9}  },
	{Name = "Australia Air Force", X = 40, Y = 13, Domain = "Air", CivID = AUSTRALIA, IsMinor = true, Group = {UK_SPITFIRE, UK_SPITFIRE}, UnitsName = {"1st Australian Fighter Squadron", "2nd Australian Fighter Squadron"}, UnitsXP = {9,9}  },
	}


----------------------------------------------------------------------------------------------------------------------------
-- Projects (see RedDefines.lua for IDs and data table)
----------------------------------------------------------------------------------------------------------------------------

-- projects available at start of scenario
g_ProjectsAvailableAtStart = {
	[ENGLAND] = {PROJECT_MATILDAI, PROJECT_MATILDAII, PROJECT_VALENTINE, PROJECT_MOSQUITO, PROJECT_BISHOP, PROJECT_HALIFAX, PROJECT_CRUISER_III, PROJECT_CRUISER_IV, PROJECT_A15, PROJECT_A15_MKIII, PROJECT_A13, PROJECT_CAVALIER, PROJECT_CHURCHILL, PROJECT_HURRICANE_II, PROJECT_SPITFIRE_V, PROJECT_U_CLASS, PROJECT_LANCASTER, PROJECT_BEAUFIGHTER, PROJECT_CHALLENGER, PROJECT_SPITFIRE_IX, PROJECT_TETRARCH, PROJECT_WHIRLWIND, PROJECT_TYPHOON },
	[AMERICA] = {PROJECT_A20, PROJECT_B24, PROJECT_PRIEST, PROJECT_M3A1HT, PROJECT_M5STUART, PROJECT_P38, PROJECT_P40, PROJECT_M4SHERMAN, PROJECT_B25, PROJECT_FLETCHER, PROJECT_IOWA, PROJECT_M12, PROJECT_M10},
	[JAPAN]   = {PROJECT_G4M3, PROJECT_A6M2, PROJECT_KI43, PROJECT_I400, PROJECT_YAMATO, PROJECT_TYPE4_CHITO, PROJECT_HO_NI_I, PROJECT_A6M5, },
}
----------------------------------------------------------------------------------------------------------------------------
-- Diplomacy
----------------------------------------------------------------------------------------------------------------------------

-- Virtual allies
g_Allied = {
	[USSR] = true,
	[ENGLAND] = true,
	[CHINA] = true,
	[AMERICA] = true,
}
g_Axis = {
	[JAPAN] = true,
}


-- Victory types
g_Victory = {
	[JAPAN] = "VICTORY_AXIS_PACIFIC",
	[ENGLAND] = "VICTORY_ALLIED_PACIFIC",
	[AMERICA] = "VICTORY_ALLIED_PACIFIC",
}

-- Major Civilizations
-- to do in all table : add entry bCheck = function() return true or false, apply change only if true or nill
g_Major_Diplomacy = {
	[19420101] = { 
		{Type = DOW, Civ1 = JAPAN, Civ2 = CHINA},
		{Type = DOW, Civ1 = JAPAN, Civ2 = AMERICA},
		{Type = DOW, Civ1 = JAPAN, Civ2 = ENGLAND},
		{Type = PEA, Civ1 = ENGLAND, Civ2 = AMERICA},
		{Type = PEA, Civ1 = ENGLAND, Civ2 = CHINA},
		{Type = PEA, Civ1 = AMERICA, Civ2 = CHINA},
	},
}

-- Minor Civilizations
g_Minor_Relation = {
	[19420101] = { 
		{Value = 120, Major = ENGLAND, Minor = CANADA},
		{Value = 120, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 120, Major = ENGLAND, Minor = AUSTRALIA},
		{Value = 120, Major = ENGLAND, Minor = NEWZEALAND},
		{Value = 120, Major = AMERICA, Minor = NETHERLANDS},
		{Value = 120, Major = AMERICA, Minor = CANADA},
		{Value = 120, Major = AMERICA, Minor = AUSTRALIA},
		{Value = 120, Major = AMERICA, Minor = NEWZEALAND},
		{Value = 120, Major = CHINA, Minor = NETHERLANDS},
		{Value = 120, Major = CHINA, Minor = CANADA},
		{Value = 120, Major = CHINA, Minor = AUSTRALIA},
		{Value = 120, Major = CHINA, Minor = NEWZEALAND},
		{Value = -120, Major = JAPAN, Minor = NETHERLANDS},
		{Value = -120, Major = JAPAN, Minor = CANADA},
		{Value = -120, Major = JAPAN, Minor = AUSTRALIA},
		{Value = -120, Major = JAPAN, Minor = NEWZEALAND},
	},
	[19420125] = { 
		{Value = 120, Major = JAPAN, Minor = THAILAND},
	},
	[19420822] = { 
		{Value = 120, Major = AMERICA, Minor = MEXICO},
		{Value = 120, Major = ENGLAND, Minor = MEXICO},
		{Value = 120, Major = CHINA, Minor = MEXICO},
	},						
}

g_MinorProtector = {
	[THAILAND] = {JAPAN, }, 
	[MONGOLIA] = {USSR, }, 
	[NETHERLANDS] = {ENGLAND, AMERICA}, 
	[CANADA] = {ENGLAND, AMERICA }, 
	[AUSTRALIA] = {ENGLAND, AMERICA }, 
	[NEWZEALAND] = {ENGLAND, AMERICA }, 
	[MEXICO] = {AMERICA, },
}






----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
