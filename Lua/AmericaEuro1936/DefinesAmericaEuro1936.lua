-- RedAmericaEurope1936Defines
-- Author: Gedemon
-- DateCreated: 7/9/2011
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

print("Loading America/Euro 1936 Defines...")
print("-------------------------------------")

----------------------------------------------------------------------------------------------------------------------------
-- Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

WAR_MINIMUM_STARTING_TURN		= 5
REVEAL_ALL_CITIES				= false	-- cities tiles are always visible for every civs
EMBARK_FROM_HARBOR				= false	-- allow embarking only from a city with a port (and adjacent tiles)
BEACHHEAD_DAMAGE				= true	-- Amphibious assault on an empty tile owned by enemy civ will cause damage to the landing unit (not implemented)
CLOSE_MINOR_NEUTRAL_CIV_BORDERS = true	-- if true neutral territories is impassable
RESOURCE_CONSUMPTION			= true	-- Use resource consumption (fuel, ...)

----------------------------------------------------------------------------------------------------------------------------
-- AI Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

ALLOW_AI_CONTROL = true -- Allow the use of functions to (try to) control the AI units and build list
NO_AI_EMBARKATION			= true -- remove AI ability to embark (to do : take total control of AI unit to embark)
	
AI_LAND_MINIMAL_RESERVE		= 15	
AI_AIR_MINIMAL_RESERVE		= 10	
AI_SEA_MINIMAL_RESERVE		= 8	

if(HARDCORE_MODE) then 
	 NO_SUICIDE_ATTACK			= false -- If set to true, try to prevent suicide attacks
	 UNIT_SUPPORT_LIMIT_FOR_AI	= false -- Allow limitation of max number of AI units based on number of supported units
	 ALLOW_AI_UNITS_LIMIT		= false	-- Allow limitation of max number of AI military unit
else 
	 NO_SUICIDE_ATTACK			= true -- If set to true, try to prevent suicide attacks
	 UNIT_SUPPORT_LIMIT_FOR_AI	= true -- Allow limitation of max number of AI units based on number of supported units
	 ALLOW_AI_UNITS_LIMIT		= true	-- Allow limitation of max number of AI military unit
end
----------------------------------------------------------------------------------------------------------------------------
-- Calendar
----------------------------------------------------------------------------------------------------------------------------

REAL_WORLD_ENDING_DATE	= 19470105
MAX_FALL_OF_FRANCE_DATE = 19470101 -- France will not surrender if Paris fall after this date...

if(PreGame.GetGameOption("PlayEpicGame") ~= nil) and (PreGame.GetGameOption("PlayEpicGame") > 0) then
	g_Calendar = {}
	local monthList = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local dayList = { "1", "5", "10", "15", "20", "25" }
	local turn = 0
	for year = 1939, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 1 and year == 1939) -- Start date !
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
	for year = 1939, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 1 and year == 1939) -- Start date !
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

ALBANIA = GameInfo.MinorCivilizations.MINOR_CIV_ALBANIA.ID
ARABIA = GameInfo.MinorCivilizations.MINOR_CIV_ARABIA.ID
AUSTRIA = GameInfo.MinorCivilizations.MINOR_CIV_AUSTRIA.ID
BELGIUM = GameInfo.MinorCivilizations.MINOR_CIV_BELGIUM.ID
BULGARIA = GameInfo.MinorCivilizations.MINOR_CIV_BULGARIA.ID
CANADA = GameInfo.MinorCivilizations.MINOR_CIV_CANADA.ID
CZECHOSLOVAKIA = GameInfo.MinorCivilizations.MINOR_CIV_CZECHOSLOVAKIA.ID
DENMARK = GameInfo.MinorCivilizations.MINOR_CIV_DENMARK.ID
ESTONIA = GameInfo.MinorCivilizations.MINOR_CIV_ESTONIA.ID
FINLAND = GameInfo.MinorCivilizations.MINOR_CIV_FINLAND.ID
GREECE = GameInfo.MinorCivilizations.MINOR_CIV_GREECE.ID
HUNGARY = GameInfo.MinorCivilizations.MINOR_CIV_HUNGARY.ID
IRELAND = GameInfo.MinorCivilizations.MINOR_CIV_IRELAND.ID
LATVIA = GameInfo.MinorCivilizations.MINOR_CIV_LATVIA.ID
LITHUANIA = GameInfo.MinorCivilizations.MINOR_CIV_LITHUANIA.ID
NSPAIN = GameInfo.MinorCivilizations.MINOR_CIV_NATIONALISTSPAIN.ID
NETHERLANDS = GameInfo.MinorCivilizations.MINOR_CIV_NETHERLANDS.ID
NORWAY = GameInfo.MinorCivilizations.MINOR_CIV_NORWAY.ID
POLAND = GameInfo.MinorCivilizations.MINOR_CIV_POLAND.ID
PORTUGAL = GameInfo.MinorCivilizations.MINOR_CIV_PORTUGAL.ID
RSPAIN = GameInfo.MinorCivilizations.MINOR_CIV_REPUBLICANSPAIN.ID
ROMANIA = GameInfo.MinorCivilizations.MINOR_CIV_ROMANIA.ID
SLOVAKIA = GameInfo.MinorCivilizations.MINOR_CIV_SLOVAKIA.ID
SWEDEN = GameInfo.MinorCivilizations.MINOR_CIV_SWEDEN.ID
SWITZERLAND = GameInfo.MinorCivilizations.MINOR_CIV_SWITZERLAND.ID
TURKEY = GameInfo.MinorCivilizations.MINOR_CIV_TURKEY.ID
VICHY = GameInfo.MinorCivilizations.MINOR_CIV_VICHY.ID
YUGOSLAVIA = GameInfo.MinorCivilizations.MINOR_CIV_YUGOSLAVIA.ID


----------------------------------------------------------------------------------------------------------------------------
-- Buildings (see RedDefines.lua for IDs)
----------------------------------------------------------------------------------------------------------------------------

-- no override here, use default tables from RedDefines.lua...

----------------------------------------------------------------------------------------------------------------------------
-- Units (see RedDefines.lua for IDs)
----------------------------------------------------------------------------------------------------------------------------

-- Modifier for maintenance free units
g_Units_Maintenance_Modifier = {
	[FRANCE] = 30,
	[ENGLAND] = 30,
	[USSR] = 40,
	[GERMANY] = 40,
	[ITALY] = 30,
	[AMERICA] = 40,
}

-- Available units for minor civs
g_Minor_Units = {}

-- unit type called when AI need reserve troops
g_Reserve_Unit = {
	[FRANCE] = { {Prob = 50, ID = FR_INFANTRY}, {Prob = 10, ID = FR_AMR35}, {Prob = 10, ID = FR_FCM36}, {Prob = 5, ID = FR_AMC35}, {Prob = 5, ID = FR_CHAR_D1}, {Prob = 5, ID = FR_CHAR_D2}, },
	[ENGLAND] = { {Prob = 50, ID = UK_INFANTRY}, {Prob = 20, ID = UK_VICKERS_MK6B}, {Prob = 10, ID = UK_MATILDA_II}, {Prob = 5, ID = UK_MATILDA_I},  },
	[USSR] = { {Prob = 50, ID = RU_INFANTRY}, {Prob = 20, ID = RU_T26}, {Prob = 15, ID = RU_T28},  },
	[GERMANY] = { {Prob = 50, ID = GE_INFANTRY}, {Prob = 20, ID = GE_PANZER_I}, {Prob = 15, ID = GE_PANZER_35},  },
	[ITALY] = { {Prob = 50, ID = IT_INFANTRY}, {Prob = 20, ID = IT_L6_40}, {Prob = 15, ID = IT_M11_39},  },
	[AMERICA] = { {Prob = 50, ID = US_INFANTRY}, {Prob = 20, ID = US_M3STUART}, {Prob = 15, ID = US_SHERMAN},  },
}





-- Thresholds used to check if AI need to call reserve troops
g_Reserve_Data = { 
	-- UnitThreshold : minimum number of land units left
	-- LandThreshold : minimum number of plot left
	-- LandUnitRatio : ratio between lands and units, use higher ratio when the nation as lot of space between cities
	[FRANCE] = {	UnitThreshold = 8, LandThreshold = 108, LandUnitRatio = 10,
					},
					-- initial plots = 216, France won't get reinforcement once Paris is captured
	[ENGLAND] = {	UnitThreshold = 14, LandThreshold = 100, LandUnitRatio = 5,
					},
					-- initial plots = 111
	[USSR] = {		UnitThreshold = 20, LandThreshold = 2350, LandUnitRatio = 50,
					},
					-- initial plots = 2469
	[GERMANY] = {	UnitThreshold = 20, LandThreshold = 300, LandUnitRatio = 10,
					Condition = function() local turn = Game.GetGameTurn(); return turn > 5; end},
					-- initial plots = 204 : German AI get reinforcement almost immediatly (after 5 turns)
	[ITALY] = {		UnitThreshold = 12, LandThreshold = 90, LandUnitRatio = 5,
					},
					-- initial plots = 114
}

-- Combat type ratio restriction used by AI
g_Combat_Type_Ratio = { 
	-- Air		<= military units / air units
	-- Sea		<= military units / sea units
	-- Land		<= military units / land units
	-- ( 1 = no limit )
	[FRANCE] 	= {Air = 10,		Sea = 10,	 	Land = 1.4,	}, -- Air = 5
	[ENGLAND]	= {Air = 8,		Sea = 4,		Land = 2,	}, -- Air = 4
	[USSR]		= {Air = 10,		Sea = 10,		Land = 1.4,	}, -- Air = 5
	[GERMANY]	= {Air = 6,		Sea = 6.6,		Land = 1.6,	}, -- Air = 4
	[ITALY]		= {Air = 10,		Sea = 5,		Land = 1.6,	}, -- Air = 5
	[AMERICA]	= {Air = 8,		Sea = 4,		Land = 2,	}, -- Air = 4
	[MINOR]		= {Air = 5,		Sea = 5,		Land = 1.6,	}, -- Air = 5
}

-- Land type ratio restriction used by AI
g_Max_Land_SubClass_Percent = {		-- max num	<= land units / type units possible
	[FRANCE]	= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 8, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 15,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 15, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 15, [CLASS_HEAVY_TANK] = 10, [CLASS_LIGHT_TANK_DESTROYER] = 2, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 3,	},	
	
	[ENGLAND]	= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 3, [CLASS_MECHANIZED_INFANTRY] = 3, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 15, [CLASS_CRUISER_TANK] = 20, [CLASS_TANK] = 10, [CLASS_HEAVY_TANK] = 10, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 0,	},	
	
	[USSR]		= {	[CLASS_INFANTRY] = 25, [CLASS_INFANTRY_2] = 5, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 5, [CLASS_CRUISER_TANK] = 6, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 7, [CLASS_LIGHT_TANK_DESTROYER] = 3, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 4,	},	

	[GERMANY]	= {	[CLASS_INFANTRY] = 16, [CLASS_INFANTRY_2] = 10, [CLASS_PARATROOPER] = 8, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 15,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 10, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 5, [CLASS_LIGHT_TANK_DESTROYER] = 3, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 2,	},	

	[ITALY]		= {	[CLASS_INFANTRY] = 33, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 5, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 15,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 10, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 5, [CLASS_LIGHT_TANK_DESTROYER] = 3, [CLASS_TANK_DESTROYER] = 3,  [CLASS_ASSAULT_GUN] = 2,	},	

	[AMERICA]	= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 5, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 5, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 5,	
				[CLASS_LIGHT_TANK] = 15, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 25, [CLASS_HEAVY_TANK] = 5, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 5,  [CLASS_ASSAULT_GUN] = 0,	},	
	
}

-- Air type ratio restriction used by AI
g_Max_Air_SubClass_Percent = {		-- max num	<= air units / type units possible
	[FRANCE]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 20, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 0,  [CLASS_HEAVY_BOMBER] = 0,	},
	[ENGLAND]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 10,	},
	[USSR]		= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 10,	},
	[GERMANY]	= {	[CLASS_FIGHTER] = 35, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 5,  [CLASS_HEAVY_BOMBER] = 5,	},
	[ITALY]		= {	[CLASS_FIGHTER] = 40, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 0,	},
	[AMERICA]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 10, [CLASS_ATTACK_AIRCRAFT] = 0,  [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 20, [CLASS_HEAVY_BOMBER] = 20,	},
}

-- Sea type ratio restriction used by AI
g_Max_Sea_SubClass_Percent = {
		-- max num	<= sea units / type units possible
	[FRANCE]	= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 25, [CLASS_CARRIER] = 5,},
	[ENGLAND]	= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 5, [CLASS_BATTLESHIP] = 10,	 [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 15, [CLASS_SUBMARINE_2] = 10,	[CLASS_CARRIER] = 5,},
	[USSR]		= {	[CLASS_DESTROYER] = 30, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 20, [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 0,},
	[GERMANY]	= {	[CLASS_DESTROYER] = 15, [CLASS_DESTROYER_2] = 10, [CLASS_CRUISER] = 10, [CLASS_HEAVY_CRUISER] = 10, [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 20, [CLASS_SUBMARINE_2] = 15,	[CLASS_CARRIER] = 5,},
	[ITALY]		= {	[CLASS_DESTROYER] = 15, [CLASS_CRUISER] = 10,  [CLASS_HEAVY_CRUISER] = 20, [CLASS_DREADNOUGHT] = 10, [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 5,},
	[AMERICA]	= {	[CLASS_DESTROYER] = 15, [CLASS_DESTROYER_2] = 10, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 5,},
}



-- Available units for minor civs
g_Minor_Units = {}


-- Order of Battle
-- group size = 7 units max placed in (and around) plot (x,y), except air placed only in central plot (should be city plot)
-- we can initialize any units for anyone here, no restriction by nation like in build list
g_Initial_OOB = {
	{Name = "French north army", X = 76, Y = 45, Domain = "Land", CivID = FRANCE, Group = {FR_INFANTRY, FR_INFANTRY, FR_AMR35, FR_B1, FR_S35, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "French south army", X = 74, Y = 35, Domain = "Land", AI = true, CivID = FRANCE, Group = {FR_INFANTRY, FR_INFANTRY, FR_CHAR_D1, AT_GUN}, UnitsXP = {9,9,9,9},  },
	{Name = "French metr. aviation", X = 73, Y = 45, Domain = "Air", CivID = FRANCE, Group = {FR_MS406, FR_MS406 }, UnitsXP = {9,9},  },
	{Name = "French metr. aviation AI Bonus", X = 75, Y = 38, Domain = "Air", AI = true, CivID = FRANCE, Group = {FR_HAWK75, FR_MB152 }, UnitsXP = {9,9},  },
	{Name = "French Mediteranean fleet", X = 76, Y = 30, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_SUBMARINE, FR_GALISSONIERE, FR_GALISSONIERE, FR_BATTLESHIP, FR_BATTLESHIP_2}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "French North Africa", X = 64, Y = 18, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_AMC35, FR_CHAR_D2}, UnitsXP = {9,9,9},  },
	{Name = "French Syria", X = 126, Y = 10, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_FCM36}, UnitsXP = {9,9},  },
	{Name = "French Oceanic fleet", X = 62, Y = 45, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_GALISSONIERE, FR_SUBMARINE, FR_SUBMARINE, FR_GALISSONIERE, FR_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9,9},  },

	{Name = "England Metropole army", X = 71, Y = 52, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_INFANTRY, AT_GUN, UK_CRUISER_I, UK_VICKERS_MK6B}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England Exped. corp Egypt", X = 115, Y = 2, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_INFANTRY, UK_CRUISER_I, UK_VICKERS_MK6B, AT_GUN}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England Metropole RAF", X = 72, Y = 52, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE, UK_HURRICANE, UK_WELLINGTON, UK_WELLINGTON}, UnitsXP = {9,9,9,9},  },
	{Name = "England Metropole RAF AI", X = 70, Y = 54, Domain = "Air", AI = true, CivID = ENGLAND, Group = {UK_SPITFIRE, UK_HURRICANE}, UnitsXP = {9,9},  },
	{Name = "England Malta RAF", X = 86, Y = 14, Domain = "Air", CivID = ENGLAND, Group = {UK_HURRICANE}, UnitsXP = {9},  },
	{Name = "England Nicosia RAF", X = 119, Y = 12, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE}, UnitsXP = {9},  },
	{Name = "England Egypt RAF", X = 111, Y = 2, Domain = "Air", CivID = ENGLAND, Group = {UK_HURRICANE}, UnitsXP = {9},  },
	{Name = "England Home fleet", X = 57, Y = 54, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_BATTLESHIP, UK_BATTLESHIP_2, UK_ELIZABETH}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "England Home fleet North", X = 75, Y = 68, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER, UK_BATTLESHIP_2}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England West Mediterranean fleet", X = 50, Y = 23, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England East Mediterranean fleet", X = 118, Y = 6, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_LEANDER, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9,9},  },
	{Name = "England Home fleet AI Bonus", X = 67, Y = 50, Domain = "Sea", AI = true, CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER}, UnitsXP = {9,9,9,9},  },

 	{Name = "USSR central army", X = 111, Y = 51, Domain = "Land", CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_INFANTRY, RU_BT2, RU_T26, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  }, 
	{Name = "USSR moscow army", X = 115, Y = 57, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_KV1, RU_BT2, AT_GUN, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "USSR north army", X = 109, Y = 84, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },
	{Name = "USSR south army", X = 109, Y = 43, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },	
	{Name = "USSR central aviation", X = 117, Y = 58, Domain = "Air", CivID = USSR, Group = {RU_I16, RU_I16}, UnitsXP = {9,9},  },
	{Name = "USSR central aviation AI Bonus", X = 113, Y = 51, Domain = "Air", AI = true,CivID = USSR, Group = {RU_I16, RU_I16, RU_TB3, RU_TB3}, UnitsXP = {9,9,9,9},  },
	{Name = "USSR South fleet", X = 115, Y = 32, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_GANGUT, RU_KIROV, RU_GNEVNY}, UnitsXP = {9,9,9,9},  },
	{Name = "USSR North fleet", X = 113, Y = 85, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_SUBMARINE, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR Central fleet", X = 109, Y = 64, Domain = "Sea", AI = true, CivID = USSR, Group = {RU_GANGUT, RU_KIROV, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR fortification", X = 108, Y = 65, Domain = "Land", AI = true, CivID = USSR, Group = {FORTIFIED_GUN}, UnitsName = {"Krepost Oreshek"}, },

	{Name = "German central army", X = 84, Y = 47, Domain = "Land", CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_I, GE_PANZER_II, GE_PANZER_III, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "German north army", X = 86, Y = 52, Domain = "Land", CivID = GERMANY, Group = {GE_MARDER_I, GE_INFANTRY, GE_PANZER_I, GE_PANZER_II, GE_PANZER_III, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "German east army", X = 93, Y = 46, Domain = "City", AI = true, CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_I, GE_PANZER_II, GE_PANZER_III, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "German Berlin army", X = 89, Y = 50, Domain = "City", AI = true, CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_II, GE_PANZER_III, GE_PANZER_I, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "German Luftwaffe", X = 89, Y = 50, Domain = "Air", CivID = GERMANY, Group = {GE_BF109, GE_BF109, GE_HE111, GE_HE111, GE_JU87, GE_JU87, GE_JU87}, UnitsXP = {9,9,9,9,9,9,9},  }, 
	{Name = "German Luftwaffe AI Bonus", X = 93, Y = 46, Domain = "Air", AI = true, CivID = GERMANY, Group = {GE_BF109, GE_BF109, GE_HE111, GE_JU87}, UnitsXP = {9,9,9,9}, },
	{Name = "German Fleet", X = 92, Y = 55, Domain = "Sea", CivID = GERMANY, Group = {GE_BATTLESHIP_2, GE_DESTROYER, GE_BATTLESHIP, GE_DESTROYER}, UnitsXP = {9,9,9,9},  },
	{Name = "German Submarine Fleet", X = 89, Y = 55, Domain = "Sea", CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE, GE_DESTROYER, GE_DEUTSCHLAND}, UnitsXP = {9,9,9,9,9},  },
	{Name = "German Submarine AI Bonus", X = 40, Y = 53, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE}, UnitsXP = {9,9,9,9,9}, },
	{Name = "German Fleet AI bonus", X = 87, Y = 62, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_LEIPZIG, GE_DESTROYER, GE_DESTROYER, GE_DESTROYER}, UnitsXP = {9,9,9,9},  },

	{Name = "Italian army", X = 82, Y = 35, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, AT_GUN, ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "Italian colonial army", X = 98, Y = 5, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, AT_GUN, IT_INFANTRY, ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "Italian air", X = 84, Y = 28, Domain = "Air", CivID = ITALY, Group = {IT_CR42, IT_CR42, IT_CR42}, UnitsXP = {9,9,9},  },
	{Name = "Italian air AI Bonus", X = 84, Y = 28, Domain = "Air", AI = true, CivID = ITALY, Group = {IT_CR42, IT_SM79, IT_SM79}, UnitsXP = {9,9,9},  },
	{Name = "Italian fleet", X = 82, Y = 26, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_SUBMARINE, IT_DI_CAVOUR, IT_SUBMARINE, IT_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet 2", X = 93, Y = 18, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_DI_CAVOUR, IT_ZARA, IT_BATTLESHIP, IT_SUBMARINE}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet AI Bonus", X = 91, Y = 6, Domain = "Sea", AI = true, CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_SUBMARINE}, UnitsXP = {9,9,9},  },

	{Name = "US north army", X = 1, Y = 41, Domain = "Land", CivID = AMERICA, Group = {US_INFANTRY, US_INFANTRY, US_INFANTRY}, UnitsXP = {9,9,9},  },
	{Name = "US south army", X = 1, Y = 18, Domain = "Land", CivID = AMERICA, Group = {US_INFANTRY, US_INFANTRY, US_INFANTRY}, UnitsXP = {9,9,9},  },
	{Name = "US air force", X = 0, Y = 32, Domain = "Air", CivID = AMERICA, Group = {US_P36, US_P36}, UnitsXP = {9,9},  },
	{Name = "US north fleet", X = 8, Y = 46, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_BALTIMORE, US_PENNSYLVANIA, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "US south fleet", X = 4, Y = 17, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_BALTIMORE, US_PENNSYLVANIA, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9,9,9},  },
}
-- Options
if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 1", X = 80, Y = 42, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"SF de Mulhouse"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 2", X = 80, Y = 43, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"SF de Colmar"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 3", X = 81, Y = 45, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Hochwald"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 4", X = 80, Y = 45, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Simserhof"},  })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 5", X = 80, Y = 46, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage de Fermont"}, })
end

if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Westwall 1", X = 82, Y = 42, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Isteiner Klotz"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 2", X = 83, Y = 44, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Offenburger Riegel"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 3", X = 82, Y = 46, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Ettlinger Riegel"}, })																																 
	table.insert (g_Initial_OOB,	{Name = "Westwall 4", X = 80, Y = 47, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Spichernstellung"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 5", X = 80, Y = 49, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Orscholzriegel"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 6", X = 80, Y = 51, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Huertgenwald"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 7", X = 81, Y = 53, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Geldernstellung"}, })
end

g_MinorMobilization_OOB = { 

	{Name = "Finland army",				X = 105, Y = 68,	Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, FI_BT42, ARTILLERY} },
	{Name = "Finland fortification",	X = 106, Y = 66,	Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },
	{Name = "Finland fortification",	X = 107, Y = 67,	Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },
	{Name = "Poland army",				X = 98, Y = 46,		Domain = "Land",	CivID = POLAND,		IsMinor = true, Group = {PL_INFANTRY, PL_VICKERS_MKE_A, PL_INFANTRY, PL_10TP, PL_7TP} },
	{Name = "Poland fortification",     X = 97, Y = 49,		Domain = "Land",	CivID = POLAND,		IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Twierdza Modlin"}, },
	{Name = "Poland air force",			X = 98, Y = 48,		Domain = "Air",		CivID = POLAND,		IsMinor = true, Group = {PL_PZL37, PL_P11, } },
	{Name = "Poland fleet",				X = 95, Y = 56,		Domain = "Sea",		CivID = POLAND,		IsMinor = true, Group = {PL_SUBMARINE} },
	{Name = "Belgian army",				X = 77, Y = 49,		Domain = "City",	CivID = BELGIUM,	IsMinor = true, Group = {INFANTRY, DU_VICKERS_M1936} },
	{Name = "Netherlands army",			X = 79, Y = 52,		Domain = "City",	CivID = NETHERLANDS,	IsMinor = true, Group = {DU_INFANTRY, DU_VICKERS_M1936, DU_MTSL} },
	{Name = "Netherlands AF",			X = 79, Y = 52,		Domain = "Air",		CivID = NETHERLANDS,	IsMinor = true, Group = {DU_FOKKER_DXXI, DU_FOKKER_GI, DU_FOKKER_TV} },
	{Name = "Slovakia army",			X = 94, Y = 42,		Domain = "Land",	CivID = SLOVAKIA,	IsMinor = true, Group = {GE_INFANTRY, GE_PANZER_35, ARTILLERY} },
	{Name = "Slovakia army 2",			X = 101, Y = 40,	Domain = "Land",	CivID = SLOVAKIA,	IsMinor = true, Group = {GE_INFANTRY, GE_PANZER_35, AT_GUN} },
	{Name = "Romania army",				X = 107, Y = 34,	Domain = "Land",	CivID = ROMANIA,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, INFANTRY, RO_TACAM, ARTILLERY} },
	{Name = "Yugoslavia army",			X = 94, Y = 33,		Domain = "Land",	CivID = YUGOSLAVIA,	IsMinor = true, Group = {INFANTRY, INFANTRY, AT_GUN, INFANTRY, YU_SKODA, YU_SKODA, ARTILLERY} },
	{Name = "Bulgaria army",			X = 105, Y = 28,	Domain = "Land",	CivID = BULGARIA,	IsMinor = true, Group = {HU_INFANTRY, AT_GUN, HU_INFANTRY, ARTILLERY} },
	{Name = "Hungary army",				X = 96, Y = 37,		Domain = "Land",	CivID = HUNGARY,	IsMinor = true, Group = {HU_INFANTRY, HU_INFANTRY, HU_INFANTRY, HU_38M_TOLDI, HU_38M_TOLDI, HU_40M_TURAN, ARTILLERY} },
	{Name = "Hungary air force",		X = 96, Y = 38,		Domain = "Air",		CivID = HUNGARY,	IsMinor = true, Group = {HU_RE2000, HU_RE2000, HU_CA135} },
	{Name = "Sweden army",				X = 94, Y = 64,		Domain = "Land",	CivID = SWEDEN,		IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, ARTILLERY} },
	{Name = "Greece army",				X = 99, Y = 19,		Domain = "Land",	CivID = GREECE,		IsMinor = true, Group = {GR_INFANTRY, GR_INFANTRY, GR_INFANTRY, GR_VICKERS_MKE} },
	{Name = "Greece air force",			X = 101, Y = 17,	Domain = "Air",		CivID = GREECE,		IsMinor = true, Group = {GR_P24, GR_P24 } },
	{Name = "Greece fleet",				X = 103, Y = 20,	Domain = "Sea",		CivID = GREECE,		IsMinor = true, Group = {GR_GEORGIOS, GR_GEORGIOS, GR_SUBMARINE} },

	{Name = "Generic army",			X = 78, Y = 39,		Domain = "City",	CivID = SWITZERLAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 52, Y = 29,		Domain = "City",	CivID = PORTUGAL,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 126, Y = 0,		Domain = "City",	CivID = ARABIA,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 111, Y = 24,	Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 118, Y = 22,	Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 85, Y = 59,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 88, Y = 57,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AA_GUN} },
	{Name = "Generic army",			X = 65, Y = 59,		Domain = "City",	CivID = IRELAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 89, Y = 66,		Domain = "City",	CivID = NORWAY,		IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 96, Y = 24,		Domain = "City",	CivID = ALBANIA,	IsMinor = true, Group = {INFANTRY, AT_GUN} },

}
----------------------------------------------------------------------------------------------------------------------------
-- Units Classes (see RedDefines.lua for IDs and data table)
----------------------------------------------------------------------------------------------------------------------------
g_Minor_UU = {
	[POLAND] = {
				[CLASS_TANK] = PL_10TP,
				[CLASS_INFANTRY] = PL_INFANTRY,
				[CLASS_FIGHTER] = PL_P11,
	},
	[HUNGARY] = {
				[CLASS_TANK] = HU_40M_TURAN,
				[CLASS_INFANTRY] = HU_INFANTRY,
	},
	[BULGARIA] = {
				[CLASS_INFANTRY] = HU_INFANTRY,
	},
	[CANADA] = {
				[CLASS_INFANTRY] = CA_INFANTRY,
	},
	[NETHERLANDS] = {
				[CLASS_INFANTRY] = DU_INFANTRY,
	},
	[SWEDEN] = {
				[CLASS_INFANTRY] = SW_INFANTRY,
	},

}

----------------------------------------------------------------------------------------------------------------------------
-- Projects (see RedDefines.lua for IDs and data table)
----------------------------------------------------------------------------------------------------------------------------


-- projects available at start of scenario
g_ProjectsAvailableAtStart = {
	[FRANCE] = {PROJECT_MB152},
	[USSR] = {PROJECT_KV1},
	[ITALY] = {PROJECT_M11_39, PROJECT_L6_40, PROJECT_G50 },
	[GERMANY] = {PROJECT_PANZER_III,  PROJECT_PANZER_IV,},
	[ENGLAND] = {PROJECT_MATILDAII, PROJECT_MATILDAI, PROJECT_TETRARCH, },
	[AMERICA] = { },

}


----------------------------------------------------------------------------------------------------------------------------
-- Diplomacy
----------------------------------------------------------------------------------------------------------------------------

-- Victory types
g_Victory = {
	[FRANCE] = "VICTORY_ALLIED_EUROPE",
	[ENGLAND] = "VICTORY_ALLIED_EUROPE",
	[USSR] = "VICTORY_USSR_EUROPE",
	[GERMANY] = "VICTORY_GERMANY_EUROPE",
	[ITALY] = "VICTORY_AXIS_EUROPE",
	[AMERICA] = "VICTORY_ALLIED_EUROPE",
}

-- Virtual allies
g_Allied = {
	[FRANCE] = true,
	[ENGLAND] = true,
	[USSR] = true,
	[AMERICA] = true,
}
g_Axis = {
	[GERMANY] = true,
	[ITALY] = true,
}

-- Major Civilizations
-- to do in all table : add entry bCheck = function() return true or false, apply change only if true or nill
g_Major_Diplomacy = {
	[19390701] = { 
		{Type = DEN, Civ1 = FRANCE, Civ2 = GERMANY},
		{Type = DEN, Civ1 = ENGLAND, Civ2 = GERMANY},
	},
	[19390901] = { 
		{Type = DEN, Civ1 = ITALY, Civ2 = FRANCE},
		{Type = DEN, Civ1 = ITALY, Civ2 = ENGLAND},
		{Type = DOF, Civ1 = GERMANY, Civ2 = USSR},
	},
	
	[19390905] = { 
		{Type = PEA, Civ1 = FRANCE, Civ2 = ENGLAND},
		{Type = DOW, Civ1 = FRANCE, Civ2 = GERMANY},
		{Type = DOW, Civ1 = ENGLAND, Civ2 = GERMANY},
	},	
	
	[19400201] = { 
		{Type = DOF, Civ1 = GERMANY, Civ2 = USSR},
	},
	[19400610] = { 
		{Type = DOW, Civ1 = ITALY, Civ2 = FRANCE},
		{Type = DOW, Civ1 = ITALY, Civ2 = ENGLAND},
		{Type = PEA, Civ1 = GERMANY, Civ2 = ITALY},
	},
	[19410622] = { 
		{Type = DOW, Civ1 = GERMANY, Civ2 = USSR},
		{Type = DOW, Civ1 = ITALY, Civ2 = USSR},
		{Type = DOF, Civ1 = FRANCE, Civ2 = USSR},
		{Type = DOF, Civ1 = ENGLAND, Civ2 = USSR},
	},
	[19411207] = { 
		{Type = DOW, Civ1 = GERMANY, Civ2 = AMERICA},
		{Type = DOW, Civ1 = ITALY, Civ2 = AMERICA},
		{Type = PEA, Civ1 = FRANCE, Civ2 = AMERICA},
		{Type = PEA, Civ1 = ENGLAND, Civ2 = AMERICA},
		{Type = DOF, Civ1 = USSR, Civ2 = AMERICA},
		{Type = DOF, Civ1 = FRANCE, Civ2 = USSR},
		{Type = DOF, Civ1 = ENGLAND, Civ2 = USSR},

	},				
}

-- Minor Civilizations
g_Minor_Relation = {
	[19390101] = { 
		{Value = 50, Major = USSR, Minor = RSPAIN},
		{Value = -50, Major = USSR, Minor = FINLAND},
		{Value = 50, Major = GERMANY, Minor = NSPAIN},
		{Value = 50, Major = GERMANY, Minor = SLOVAKIA},
		{Value = 50, Major = GERMANY, Minor = HUNGARY},		
		{Value = 50, Major = GERMANY, Minor = ROMANIA},
		{Value = 50, Major = GERMANY, Minor = BULGARIA},
		{Value = 50, Major = GERMANY, Minor = SWEDEN},	
		{Value = 120, Major = ENGLAND, Minor = CANADA},
		{Value = 50, Major = ENGLAND, Minor = SWEDEN},
		{Value = 120, Major = FRANCE, Minor = CANADA},
		{Value = 50, Major = FRANCE, Minor = SWEDEN},
		{Value = 120, Major = ITALY, Minor = ALBANIA},
		{Value = 50, Major = ITALY, Minor = NSPAIN},
		{Value = 50, Major = ITALY, Minor = SLOVAKIA},
		{Value = 50, Major = ITALY, Minor = HUNGARY},		
		{Value = 50, Major = ITALY, Minor = ROMANIA},
		{Value = 50, Major = ITALY, Minor = BULGARIA},


	},
	[19390601] = { 
		{Value = 120, Major = ENGLAND, Minor = POLAND},
		{Value = 120, Major = FRANCE, Minor = POLAND},
		{Value = 50, Major = ENGLAND, Minor = BELGIUM},
		{Value = 50, Major = FRANCE, Minor = BELGIUM},
		{Value = 50, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 50, Major = FRANCE, Minor = NETHERLANDS},
		{Value = 50, Major = ENGLAND, Minor = NORWAY},
		{Value = 50, Major = FRANCE, Minor = NORWAY},
		{Value = 50, Major = ENGLAND, Minor = GREECE},
		{Value = 50, Major = FRANCE, Minor = GREECE},
	},
	[19400410] = { 
		{Value = 120, Major = ENGLAND, Minor = NORWAY},
	},
	[19400512] = { 
		{Value = 120, Major = ENGLAND, Minor = BELGIUM},
		{Value = 100, Major = FRANCE, Minor = NETHERLANDS},
		{Value = 100, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 120, Major = FRANCE, Minor = BELGIUM},
	},
	[19401028] = { 
		{Value = -50, Major = ITALY, Minor = GREECE},
		{Value = -50, Major = ITALY, Minor = YUGOSLAVIA},
	},
	[19410406] = { 
		{Value = 120, Major = ENGLAND, Minor = YUGOSLAVIA},
		{Value = 120, Major = FRANCE, Minor = YUGOSLAVIA},
		{Value = 120, Major = ENGLAND, Minor = GREECE},
		{Value = 100, Major = FRANCE, Minor = GREECE},
	},
	[19410622] = { 
		{Value = 120, Major = GERMANY, Minor = SLOVAKIA},
		{Value = 120, Major = GERMANY, Minor = HUNGARY},
		{Value = 120, Major = GERMANY, Minor = FINLAND},
		{Value = 120, Major = GERMANY, Minor = BULGARIA},		
		{Value = 120, Major = GERMANY, Minor = ROMANIA},		
		{Value = 50, Major = ITALY, Minor = FINLAND},
	},
	[19411207] = { 
		{Value = 120, Major = AMERICA, Minor = POLAND},
		{Value = 120, Major = AMERICA, Minor = NETHERLANDS},
		{Value = 120, Major = AMERICA, Minor = BELGIUM},
		{Value = 120, Major = AMERICA, Minor = DENMARK},
		{Value = 120, Major = AMERICA, Minor = NORWAY},
		{Value = 120, Major = AMERICA, Minor = YUGOSLAVIA},
		{Value = 120, Major = AMERICA, Minor = GREECE},
		{Value = 120, Major = AMERICA, Minor = CANADA},
	},	
}
g_Major_Minor_DoW = {
	[19390901] = { 
		{Major = GERMANY, Minor = POLAND},
	},
	[19390917] = { 
		{Major = USSR, Minor = POLAND},	
	},
	[19391130] = { 
		{Major = USSR, Minor = FINLAND},
	},
	[19400409] = { 
		{Major = GERMANY, Minor = DENMARK},	
		{Major = GERMANY, Minor = NORWAY},	
	},
	[19400510] = { 
		{Major = GERMANY, Minor = BELGIUM},
		{Major = GERMANY, Minor = NETHERLANDS},
	},
	[19410410] = { 
		{Major = FRANCE, Minor = SLOVAKIA},
		{Major = FRANCE, Minor = HUNGARY},
		{Major = FRANCE, Minor = BULGARIA},
		{Major = ENGLAND, Minor = SLOVAKIA},
		{Major = ENGLAND, Minor = HUNGARY},
		{Major = ENGLAND, Minor = BULGARIA},
	},
	[19410622] = { 
		{Major = USSR, Minor = SLOVAKIA},
		{Major = USSR, Minor = HUNGARY},
		{Major = USSR, Minor = BULGARIA},
	},
	[19401028] = {
		{Major = ITALY, Minor = BELGIUM},
		{Major = ITALY, Minor = NETHERLANDS},
	},
	[19410406] = { 
		{Major = ITALY, Minor = YUGOSLAVIA},
		{Major = ITALY, Minor = GREECE},	
		{Major = GERMANY, Minor = YUGOSLAVIA},
		{Major = GERMANY, Minor = GREECE},
	},
}
g_Major_Minor_Peace = {
	[19400313] = { 
		{Major = USSR, Minor = FINLAND},	
	},
}
g_Minor_Minor_DoW = {
	[19410406] = {
		{Minor1 = BULGARIA, Minor2 = YUGOSLAVIA},
		{Minor1 = BULGARIA, Minor2 = GREECE},
		{Minor1 = HUNGARY, Minor2 = YUGOSLAVIA},
	},
}
g_Minor_Major_DoW = {
	[19410622] = { 
		{Minor = ROMANIA, Major = USSR},
		{Minor = FINLAND, Major = USSR},
	},
}




----------------------------------------------------------------------------------------------------------------------------
-- Cities
----------------------------------------------------------------------------------------------------------------------------

-- Populate cities with buildings
-- Key cities are cities that need to be occupied to trigger victory
g_Cities = {
	-- UNITED KINGDOM
		{X = 72, Y = 52, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- LONDON
		{X = 69, Y = 57, Key = true, Buildings = { HARBOR, FACTORY}, AIBuildings = {SMALL_AIR_FACTORY}, }, -- LIVERPOOL
		{X = 71, Y = 62, Key = true, Buildings = { HARBOR, FACTORY}, AIBuildings = {SHIPYARD}, }, -- EDINBURGH
		{X = 72, Y = 60, Key = true, Buildings = { HARBOR, FACTORY}, AIBuildings = {LARGE_AIR_FACTORY}, }, -- NEWCASTLE
		{X = 66, Y = 62, Buildings = {HARBOR}, AIBuildings = {RADIO, HOSPITAL, BANK, FACTORY}, }, -- BELFAST
		{X = 70, Y = 54, Buildings = {}, AIBuildings = {RADIO, HOSPITAL, BANK, FACTORY}, }, -- BIRMINGHAM
		{X = 55, Y = 24, Buildings = { HARBOR, BASE }, AIBuildings = {ARSENAL, FACTORY}, }, -- GIBRALTAR
		{X = 86, Y = 14, Buildings = { HARBOR, BASE }, AIBuildings = {ARSENAL, FACTORY}, }, -- MALTA
		{X = 67, Y = 52, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- PLYMOUTH
		{X = 122, Y = 7, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- HAIFA
		{X = 121, Y = 5, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- JERUSALEM
		{X = 122, Y = 1, AIBuildings = {FACTORY},}, -- AQABA
		{X = 115, Y = 1, AIBuildings = {FACTORY},}, -- KAIRO
		{X = 113, Y = 3, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ALEXANDRIA
		{X = 111, Y = 2, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- EL ALAMEIN
		{X = 105, Y = 3, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- SIDI BARRANI
		{X = 118, Y = 2,  AIBuildings = {ARSENAL, FACTORY}, }, -- SUEZ
		{X = 74, Y = 54, Buildings = { HARBOR }, AIBuildings = {ARSENAL, FACTORY}, }, -- NORWICH
		{X = 23, Y = 58, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ST.JOHNS
		{X = 119, Y = 12, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- NICOSIA
		{X = 16, Y = 66, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- GOOSE BAY
		{X = 10, Y = 65,  AIBuildings = {FACTORY},}, -- SHEFFERVILLE

	-- GERMANY
	{X = 89, Y = 50, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- BERLIN
	{X = 84, Y = 46, Key = true, Buildings = { BANK, FACTORY}, AIBuildings = {LARGE_AIR_FACTORY}, }, -- FRANKFURT
	{X = 84, Y = 53, Key = true, Buildings = { BANK, HARBOR, FACTORY}, AIBuildings = {BARRACKS, SHIPYARD, BASE, OIL_REFINERY}, }, -- HAMBURG
	{X = 85, Y = 40, Key = true, Buildings = { BANK }, AIBuildings = {FACTORY, BARRACKS, LAND_FACTORY, ARSENAL, BASE, OIL_REFINERY}, }, -- MUNICH
	{X = 85, Y = 55, Buildings = { HARBOR }, AIBuildings = {FACTORY, OIL_REFINERY}, }, -- KIEL
	{X = 84, Y = 43, AIBuildings = {FACTORY}, }, -- NUREMBERG
	{X = 97, Y = 53, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- KONIGSBERG
	{X = 91, Y = 52, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- STETTIN
	{X = 81, Y = 50, Buildings = { BANK }, AIBuildings = {FACTORY},}, -- ESSEN
	{X = 81, Y = 49, Buildings = { FACTORY, BANK}, AIBuildings = {SMALL_AIR_FACTORY}, }, -- COLOGNE
	{X = 93, Y = 46, AIBuildings = {FACTORY}, }, -- BRESLAU
	{X = 89, Y = 47, AIBuildings = {FACTORY}, }, -- DRESDEN
	{X = 86, Y = 48, AIBuildings = {FACTORY}, }, -- LEIPZIG	
	{X = 87, Y = 41, AIBuildings = {FACTORY}, }, -- PASSAU
	{X = 90, Y = 45, Buildings = { BANK }, AIBuildings = {FACTORY, BARRACKS, SHIPYARD, BASE, OIL_REFINERY}, }, -- PRAGUE
	{X = 92, Y = 40, Buildings = { BANK }, AIBuildings = {FACTORY, BARRACKS, LAND_FACTORY, ARSENAL, BASE, OIL_REFINERY}, }, -- VIENNA
	
	
	-- FRANCE
	{X = 73, Y = 45, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, ACADEMY, HOSPITAL, OPEN_CITY }, AIBuildings = {LAND_FACTORY}, }, -- PARIS	
	{X = 74, Y = 34, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD}, }, -- MARSEILLE
	{X = 75, Y = 38, Buildings = { FACTORY, ACADEMY, ARSENAL}, AIBuildings = {SMALL_AIR_FACTORY, BASE}, }, -- LYON
	{X = 70, Y = 36, Buildings = { FACTORY }, AIBuildings = {LAND_FACTORY, BASE}, }, -- TOULOUSE
	{X = 69, Y = 47, Key = true,  AIBuildings = {ARSENAL, FACTORY}, }, -- CAEN
	{X = 64, Y = 18, Buildings = { BARRACKS, LEGION_HQ }, AIBuildings = {FACTORY},}, -- SIDI BEL ABBES
	{X = 78, Y = 27, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- AJACCIO
	{X = 66, Y = 45, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- SAINT NAZAIRE
	{X = 64, Y = 48, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- BREST
	{X = 78, Y = 34, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- NICE
	{X = 67, Y = 39, Key = true,  AIBuildings = {ARSENAL, FACTORY}, }, -- BORDEAUX
	{X = 66, Y = 42, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- LA ROCHELLE
	{X = 79, Y = 46, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY},}, -- METZ
	{X = 125, Y = 9, Buildings = { FACTORY }, AIBuildings = {ARSENAL}, }, -- DAMASCUS
	{X = 72, Y = 39, AIBuildings = {FACTORY},}, -- VICHY
	{X = 70, Y = 42, AIBuildings = {FACTORY},}, -- TOURS
	{X = 74, Y = 50, Key = true, Buildings = { HARBOR }, AIBuildings = {ARSENAL, FACTORY}, }, -- DUNKERQUE
	{X = 76, Y = 46, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY},}, -- REIMS
	{X = 75, Y = 41, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY},}, -- DIJON
	{X = 78, Y = 42, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY},}, -- MULHOUSE
	{X = 123, Y = 10, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- BEIRUT
	{X = 126, Y = 14, AIBuildings = {FACTORY},}, -- ALEPPO
	{X = 78, Y = 10, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- GABES
	{X = 79, Y = 13, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- SFAX
	{X = 78, Y = 17, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- TUNIS
	{X = 52, Y = 18, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- RABAT
	{X = 49, Y = 17, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- CASABLANCA
	{X = 60, Y = 20, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ORAN
	{X = 66, Y = 21, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ALGIER
	{X = 49, Y = 14, AIBuildings = {FACTORY},}, -- MARRAKECH

	-- ITALY
	{X = 84, Y = 28, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- ROME
	{X = 86, Y = 25, Key = true, Buildings = { HARBOR }, AIBuildings = { FACTORY, SHIPYARD }, }, -- NAPLES
	{X = 81, Y = 36, Key = true, Buildings = { FACTORY }, AIBuildings = { SMALL_AIR_FACTORY }, }, -- MILAN
	{X = 83, Y = 34, Key = true, Buildings = { FACTORY }, AIBuildings = { LARGE_AIR_FACTORY }, }, -- BOLOGNE
	{X = 85, Y = 19, Buildings = { HARBOR },}, -- PALERMO
	{X = 78, Y = 23, Buildings = { HARBOR }, }, -- CAGLIARI
	{X = 89, Y = 19, Buildings = { HARBOR }, }, -- REGGIO CALABRIA
	{X = 87, Y = 17, Buildings = { HARBOR }, }, -- CATANIA
	{X = 80, Y = 34, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- GENOVA
	{X = 88, Y = 35, Buildings = { HARBOR }, }, -- TRIESTE
	{X = 85, Y = 35, Buildings = { HARBOR }, }, -- VENICE
	{X = 83, Y = 31, Buildings = { BANK }, AIBuildings = {FACTORY},}, -- FLORENCE
	{X = 101, Y = 5,  Buildings = { HARBOR }, }, -- TOBRUK
	{X = 91, Y = 24, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- BARI
	{X = 86, Y = 29, Buildings = { HARBOR }, }, -- PESCARA
	{X = 107, Y = 14, Buildings = { HARBOR, BASE },}, -- RHODES
	{X = 84, Y = 7,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- TRIPOLIS
	{X = 89, Y = 3,  Buildings = { HARBOR }, }, -- SIRTE
	{X = 96, Y = 5,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- BENGHAZI

	-- U.S.S.R.
	{X = 117, Y = 58, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- MOSCOW
	{X = 127, Y = 47, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LARGE_AIR_FACTORY, RADIO}, }, -- STALINGRAD
	{X = 111, Y = 44, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- KIEV
	{X = 109, Y = 64, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD, BASE, RADIO}, }, -- LENINGRAD
	{X = 110, Y = 85, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- MURMANSK
	{X = 112, Y = 37, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ODESSA
	{X = 118, Y = 43, AIBuildings = {BARRACKS, FACTORY, SMALL_AIR_FACTORY, BASE, RADIO}, }, -- KHARKOV
	{X = 122, Y = 48, AIBuildings = {FACTORY},}, -- VORONEZH
	{X = 127, Y = 38, AIBuildings = {FACTORY},}, -- STAVROPOL
	{X = 115, Y = 78, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ARKHANGEL'SK
	{X = 117, Y = 47, AIBuildings = {FACTORY},}, -- KURSK
	{X = 119, Y = 62, AIBuildings = {FACTORY},}, -- YAROSLAVL'
	{X = 106, Y = 52, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- MINSK
	{X = 119, Y = 84, AIBuildings = {FACTORY},}, -- KAMENKA
	{X = 113, Y = 51, AIBuildings = {FACTORY},}, -- BRYANSK
	{X = 106, Y = 60, AIBuildings = {FACTORY},}, -- PSKOV
	{X = 111, Y = 55, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- SMOLENSK
	{X = 112, Y = 71, AIBuildings = {FACTORY},}, -- PETROZAVODSK
	{X = 123, Y = 38, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- ROSTOV
	{X = 116, Y = 33, Buildings = { HARBOR}, AIBuildings = {FACTORY, SHIPYARD, RADIO},}, -- SEVASTOPOL


	-- AMERICA
	{X = 0, Y = 32, Key = true, Buildings = { HARBOR, ACADEMY, BANK, ARSENAL }, AIBuildings = {RADIO, HOSPITAL, FACTORY, BARRACKS, BASE}, }, -- Washington
	{X = 4, Y = 12, Buildings = {}, AIBuildings = {RADIO, ARSENAL, HOSPITAL, BANK, FACTORY}, }, -- Jacksonville
	{X = 2, Y = 27, Buildings = {}, AIBuildings = {FACTORY, RADIO, HOSPITAL, BANK}, }, -- Virginia Beach
	{X = 2, Y = 33, Key = true, Buildings = { BANK, HARBOR }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY}, }, -- Baltimore
	{X = 2, Y = 37, Key = true, Buildings = { BANK, HARBOR }, AIBuildings = {RADIO, RADIO, HOSPITAL, FACTORY}, }, -- Philadelphia
	{X = 4, Y = 44, Buildings = { HARBOR, BANK }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY}, }, -- Boston
	{X = 3, Y = 40, Key = true, Buildings = { HARBOR, BANK, RADIO }, AIBuildings = {ARSENAL, HOSPITAL, FACTORY}, }, -- New York
	{X = 1, Y = 44, Buildings = {}, AIBuildings = {FACTORY, RADIO, BANK, HOSPITAL}, }, -- Albany
	{X = 7, Y = 3,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Miami
	{X = 4, Y = 8,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Tampa
	{X = 2, Y = 15,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Savannah
	{X = 1, Y = 21,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Charleston
	{X = 3, Y = 42,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Hartford
	{X = 6, Y = 42,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Provedence
	{X = 6, Y = 48,  Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- Augusta
	{X = 4, Y = 46, AIBuildings = {FACTORY},}, -- Concord
	{X = 0, Y = 28, AIBuildings = {FACTORY},}, -- Richmond
	{X = 0, Y = 24, AIBuildings = {FACTORY},}, -- Raleigh

}


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


