-- RedEurope1940Defines
-- Author: Gedemon
-- DateCreated: 7/9/2011
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

print("Loading Euro 1940 Defines...")
print("-------------------------------------")

----------------------------------------------------------------------------------------------------------------------------
-- Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

WAR_MINIMUM_STARTING_TURN		= 0
REVEAL_ALL_CITIES				= true	-- cities tiles are always visible for every civs
EMBARK_FROM_HARBOR				= true	-- allow embarking only from a city with a port (and adjacent tiles)
BEACHHEAD_DAMAGE				= true	-- Amphibious assault on an empty tile owned by enemy civ will cause damage to the landing unit (not implemented)
CLOSE_MINOR_NEUTRAL_CIV_BORDERS = true	-- if true neutral territories is impassable
RESOURCE_CONSUMPTION			= true	-- Use resource consumption (fuel, ...)

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
MAX_FALL_OF_FRANCE_DATE = 19420101 -- France will not surrender if Paris fall after this date...

if(PreGame.GetGameOption("PlayEpicGame") ~= nil) and (PreGame.GetGameOption("PlayEpicGame") > 0) then
	g_Calendar = {}
	local monthList = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local dayList = { "1", "5", "10", "15", "20", "25" }
	local turn = 0
	for year = 1939, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 7 and year == 1939) -- Start date !
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
				local bStart = (month >= 7 and year == 1939) -- Start date !
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

ALBANIA		= GameInfo.MinorCivilizations.MINOR_CIV_ALBANIA.ID
ALGERIA		= GameInfo.MinorCivilizations.MINOR_CIV_ALGERIA.ID
ARABIA		= GameInfo.MinorCivilizations.MINOR_CIV_ARABIA.ID
BALTIC		= GameInfo.MinorCivilizations.MINOR_CIV_BALTIC_STATES.ID
BELGIUM		= GameInfo.MinorCivilizations.MINOR_CIV_BELGIUM.ID
BULGARIA	= GameInfo.MinorCivilizations.MINOR_CIV_BULGARIA.ID
DENMARK		= GameInfo.MinorCivilizations.MINOR_CIV_DENMARK.ID
EGYPT		= GameInfo.MinorCivilizations.MINOR_CIV_EGYPT.ID
FINLAND		= GameInfo.MinorCivilizations.MINOR_CIV_FINLAND.ID
HUNGARY		= GameInfo.MinorCivilizations.MINOR_CIV_HUNGARY.ID
IRAN		= GameInfo.MinorCivilizations.MINOR_CIV_IRAN.ID
IRAQ		= GameInfo.MinorCivilizations.MINOR_CIV_IRAQ.ID
IRELAND		= GameInfo.MinorCivilizations.MINOR_CIV_IRELAND.ID
LEBANON		= GameInfo.MinorCivilizations.MINOR_CIV_LEBANON.ID
LIBYA		= GameInfo.MinorCivilizations.MINOR_CIV_LIBYA.ID
MOROCCO		= GameInfo.MinorCivilizations.MINOR_CIV_MOROCCO.ID
NETHERLANDS = GameInfo.MinorCivilizations.MINOR_CIV_NETHERLANDS.ID
NORWAY		= GameInfo.MinorCivilizations.MINOR_CIV_NORWAY.ID
PALESTINE	= GameInfo.MinorCivilizations.MINOR_CIV_PALESTINE.ID
POLAND		= GameInfo.MinorCivilizations.MINOR_CIV_POLAND.ID
PORTUGAL	= GameInfo.MinorCivilizations.MINOR_CIV_PORTUGAL.ID
ROMANIA		= GameInfo.MinorCivilizations.MINOR_CIV_ROMANIA.ID
SLOVAKIA	= GameInfo.MinorCivilizations.MINOR_CIV_SLOVAKIA.ID
SPAIN		= GameInfo.MinorCivilizations.MINOR_CIV_SPAIN.ID
SWEDEN		= GameInfo.MinorCivilizations.MINOR_CIV_SWEDEN.ID
SWITZERLAND = GameInfo.MinorCivilizations.MINOR_CIV_SWITZERLAND.ID
SYRIA		= GameInfo.MinorCivilizations.MINOR_CIV_SYRIA.ID
TUNISIA		= GameInfo.MinorCivilizations.MINOR_CIV_TUNISIA.ID
TURKEY		= GameInfo.MinorCivilizations.MINOR_CIV_TURKEY.ID
VICHY		= GameInfo.MinorCivilizations.MINOR_CIV_VICHY.ID
YUGOSLAVIA	= GameInfo.MinorCivilizations.MINOR_CIV_YUGOSLAVIA.ID

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
	[GREECE] = 10,
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
}

-- Thresholds used to check if AI need to call reserve troops
g_Reserve_Data = { 
	-- UnitThreshold : minimum number of land units left
	-- LandThreshold : minimum number of plot left
	-- LandUnitRatio : ratio between lands and units, use higher ratio when the nation as lot of space between cities
	[FRANCE] = {	UnitThreshold = 8, LandThreshold = 108, LandUnitRatio = 10,
					Condition = function() local savedData = Modding.OpenSaveData(); return savedData.GetValue("FranceHasFallen") ~= 1; end},
					-- initial plots = 216. France won't get reinforcement once Paris is captured
	[ENGLAND] = {	UnitThreshold = 14, LandThreshold = 100, LandUnitRatio = 5,
					}, -- no condition function means always true
					-- initial plots = 111
	[USSR] = {		UnitThreshold = 20, LandThreshold = 2350, LandUnitRatio = 50,
					},
					-- initial plots = 2469
	[GERMANY] = {	UnitThreshold = 20, LandThreshold = 300, LandUnitRatio = 10,
					Condition = function() local turn = Game.GetGameTurn(); return turn > 5; end},
					-- initial plots = 204 : German AI get reinforcement almost immediatly (after 5 turns because LandThreshold > initial plots)
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
	[FRANCE] 	= {Air = 5,		Sea = 10,	 	Land = 1.4,	},
	[ENGLAND]	= {Air = 4,		Sea = 4,		Land = 2,	},
	[USSR]		= {Air = 5,		Sea = 10,		Land = 1.4,	},
	[GERMANY]	= {Air = 4,		Sea = 6.6,		Land = 1.6,	},
	[ITALY]		= {Air = 5,		Sea = 5,		Land = 1.6,	},
	[GREECE]	= {Air = 5,		Sea = 5,		Land = 1.6,	},
	[MINOR]		= {Air = 5,		Sea = 5,		Land = 1.6,	},
}

-- Land type ratio restriction used by AI
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

	[GREECE]	= {	[CLASS_INFANTRY] = 30, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 5, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 20,  [CLASS_AA_GUN] = 2,	
				[CLASS_LIGHT_TANK] = 18, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 0, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 0,	},	
	
}
-- Air type ratio restriction used by AI
g_Max_Air_SubClass_Percent = {		-- max num	<= air units / type units
	[FRANCE]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 20, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 0,  [CLASS_HEAVY_BOMBER] = 0,	},
	[ENGLAND]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 10,	},
	[USSR]		= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 10,	},
	[GERMANY]	= {	[CLASS_FIGHTER] = 35, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 5,  [CLASS_HEAVY_BOMBER] = 5,	},
	[ITALY]		= {	[CLASS_FIGHTER] = 40, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 0,	},
	[GREECE]	= {	[CLASS_FIGHTER] = 50, [CLASS_FIGHTER_BOMBER] = 0,  [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 30, [CLASS_FAST_BOMBER] = 0,  [CLASS_BOMBER] = 20, [CLASS_HEAVY_BOMBER] = 0,	},
}


-- Sea type ratio restriction used by AI
g_Max_Sea_SubClass_Percent = {		-- max num	<= sea units / type units
	[FRANCE]	= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 25, [CLASS_CARRIER] = 5,},
	[ENGLAND]	= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 5, [CLASS_BATTLESHIP] = 10,	 [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 15, [CLASS_SUBMARINE_2] = 10,	[CLASS_CARRIER] = 5,},
	[USSR]		= {	[CLASS_DESTROYER] = 30, [CLASS_CRUISER] = 20, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 20, [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 0,},
	[GERMANY]	= {	[CLASS_DESTROYER] = 15, [CLASS_DESTROYER_2] = 10, [CLASS_CRUISER] = 10, [CLASS_HEAVY_CRUISER] = 10, [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 20, [CLASS_SUBMARINE_2] = 15,	[CLASS_CARRIER] = 5,},
	[ITALY]		= {	[CLASS_DESTROYER] = 15, [CLASS_CRUISER] = 10,  [CLASS_HEAVY_CRUISER] = 20, [CLASS_DREADNOUGHT] = 10, [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 30,	[CLASS_CARRIER] = 5,},
	[GREECE]	= {	[CLASS_DESTROYER] = 50, [CLASS_CRUISER] = 0,  [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 0,  [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 50,	[CLASS_CARRIER] = 0,},
}

-- Order of Battle
-- group size = 7 units max placed in (and around) plot (x,y), except air placed only in central plot (should be city plot)
-- we can initialize any units for anyone here, no restriction by nation like in build list
g_Initial_OOB = { 
	{Name = "French north army", X = 33, Y = 44, Domain = "Land", CivID = FRANCE, Group = {FR_INFANTRY, FR_INFANTRY, FR_AMR35, FR_B1, FR_S35, AT_GUN}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "French south army", X = 30, Y = 35, Domain = "Land", AI = true, CivID = FRANCE, Group = {FR_INFANTRY, FR_INFANTRY, FR_CHAR_D1, AT_GUN}, UnitsXP = {9,9,9,9},  },
	{Name = "French metr. aviation", X = 28, Y = 45, Domain = "Air", CivID = FRANCE, Group = {FR_MS406, FR_MB152 }, UnitsXP = {9,9},  },
	{Name = "French metr. aviation AI Bonus", X = 28, Y = 45, Domain = "Air", AI = true, CivID = FRANCE, Group = {FR_HAWK75, FR_HAWK75 }, UnitsXP = {9,9},  },
	{Name = "French Mediteranean fleet", X = 28, Y = 30, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_SUBMARINE, FR_GALISSONIERE, FR_GALISSONIERE, FR_BATTLESHIP, FR_BATTLESHIP_2}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "French North Africa", X = 16, Y = 18, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_AMC35, FR_CHAR_D2}, UnitsXP = {9,9,9},  },
	{Name = "French North Africa aviation", X = 16, Y = 18, Domain = "Air", CivID = FRANCE, Group = {FR_MS406}, UnitsXP = {9},  },
	{Name = "French Syria", X = 84, Y = 12, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_FCM36}, UnitsXP = {9,9},  },
	{Name = "French Syria aviation", X = 84, Y = 12, Domain = "Air", CivID = FRANCE, Group = {FR_MS406}, UnitsXP = {9},  },
	{Name = "French Oceanic fleet", X = 16, Y = 44, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_GALISSONIERE, FR_SUBMARINE, FR_SUBMARINE, FR_GALISSONIERE, FR_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9,9},  },

	{Name = "England Metropole army", X = 27, Y = 54, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_TETRARCH, AT_GUN, UK_MATILDA_I, UK_MATILDA_II}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England Exped. corp Egypt", X = 63, Y = 2, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_CRUISER_II, UK_VICKERS_MK6B}, UnitsXP = {9,9,9},  },
	{Name = "England Metropole RAF", X = 27, Y = 52, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE, UK_HURRICANE, UK_WELLINGTON, UK_WELLINGTON}, UnitsXP = {9,9,9,9},  },
	{Name = "England Metropole RAF AI", X = 27, Y = 52, Domain = "Air", AI = true, CivID = ENGLAND, Group = {UK_SPITFIRE, UK_HURRICANE}, UnitsXP = {9,9},  },
	{Name = "England Malta RAF", X = 41, Y = 14, Domain = "Air", CivID = ENGLAND, Group = {UK_HURRICANE}, UnitsXP = {9},  },
	{Name = "England Nicosia RAF", X = 74, Y = 12, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE}, UnitsXP = {9},  },
	{Name = "England Egypt RAF", X = 60, Y = 3, Domain = "Air", CivID = ENGLAND, Group = {UK_HURRICANE}, UnitsXP = {9},  },
	{Name = "England Home fleet", X = 10, Y = 46, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_BATTLESHIP, UK_BATTLESHIP_2, UK_ELIZABETH}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "England Home fleet North", X = 34, Y = 59, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER, UK_BATTLESHIP_2}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England West Mediterranean fleet", X = 13, Y = 22, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9,9,9},  },
	{Name = "England East Mediterranean fleet", X = 66, Y = 7, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_LEANDER, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9,9},  },
	{Name = "England Home fleet AI Bonus", X = 34, Y = 66, Domain = "Sea", AI = true, CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER}, UnitsXP = {9,9,9,9},  },

	{Name = "USSR central army", X = 75, Y = 48, Domain = "Land", CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_INFANTRY, RU_BT2, RU_T26, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  }, 
	{Name = "USSR moscow army", X = 67, Y = 57, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_KV1, RU_BT2, AT_GUN, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "USSR north army", X = 64, Y = 85, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },
	{Name = "USSR south army", X = 65, Y = 44, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },	
	{Name = "USSR central aviation", X = 72, Y = 58, Domain = "Air", CivID = USSR, Group = {RU_I16, RU_I16}, UnitsXP = {9,9},  },
	{Name = "USSR central aviation AI Bonus", X = 72, Y = 58, Domain = "Air", AI = true,CivID = USSR, Group = {RU_I16, RU_I16, RU_TB3, RU_TB3}, UnitsXP = {9,9,9,9},  },
	{Name = "USSR South fleet", X = 69, Y = 32, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_GANGUT, RU_KIROV, RU_GNEVNY}, UnitsXP = {9,9,9,9},  },
	{Name = "USSR North fleet", X = 67, Y = 87, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_SUBMARINE, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR Central fleet", X = 52, Y = 62, Domain = "Sea", AI = true, CivID = USSR, Group = {RU_GANGUT, RU_KIROV, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR fortification", X = 63, Y = 65, Domain = "Land", AI = true, CivID = USSR, Group = {FORTIFIED_GUN}, UnitsName = {"Krepost Oreshek"}, },

	{Name = "German central army", X = 42, Y = 46, Domain = "Land", CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_I, GE_PANZER_III, GE_PANZER_II, AT_GUN}, UnitsXP = {60,60,60,60,60,60},  },
	{Name = "German north army", X = 42, Y = 50, Domain = "Land", CivID = GERMANY, Group = {GE_MARDER_I, GE_INFANTRY, GE_PANZER_I, GE_PANZER_III, GE_PANZER_II, AT_GUN}, UnitsXP = {60,60,60,60,60,60},  },
	{Name = "German east army", X = 48, Y = 46, Domain = "Land", AI = true, CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_I, GE_PANZER_III, GE_PANZER_I, AT_GUN}, UnitsXP = {60,60,60,60,60,60},  },
	{Name = "German Berlin army", X = 44, Y = 50, Domain = "City", AI = true, CivID = GERMANY, Group = {GE_INFANTRY, GE_INFANTRY, GE_PANZER_II, GE_PANZER_III, GE_PANZER_IV, AT_GUN}, UnitsXP = {60,60,60,60,60,60},  },
	{Name = "German Luftwaffe", X = 44, Y = 50, Domain = "Air", CivID = GERMANY, Group = {GE_BF109, GE_BF109, GE_HE111, GE_HE111, GE_JU87, GE_JU87, GE_JU87}, UnitsXP = {60,60,60,60,60,60,60},  }, 
	{Name = "German Luftwaffe AI Bonus", X = 44, Y = 50, Domain = "Air", AI = true, CivID = GERMANY, Group = {GE_BF109, GE_BF109, GE_HE111, GE_JU87}, UnitsXP = {60,60,60,60}, },
	{Name = "German Fleet", X = 47, Y = 54, Domain = "Sea", CivID = GERMANY, Group = {GE_BATTLESHIP_2, GE_DESTROYER, GE_BATTLESHIP, GE_DESTROYER}, UnitsXP = {60,60,60,60},  },
	{Name = "German Submarine Fleet", X = 10, Y = 72, Domain = "Sea", CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE, GE_DESTROYER, GE_DEUTSCHLAND}, UnitsXP = {60,60,60,60,60},  },
	{Name = "German Submarine AI Bonus", X = 2, Y = 34, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE}, UnitsXP = {60,60,60}, },
	{Name = "German Fleet AI bonus", X = 38, Y = 61, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_LEIPZIG, GE_DESTROYER, GE_DESTROYER, GE_DESTROYER}, UnitsXP = {60,60,60,60},  },

	{Name = "Italian army", X = 37, Y = 33, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, IT_M11_39, IT_INFANTRY, IT_INFANTRY, AT_GUN, ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "Italian colonial army", X = 53, Y = 5, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, AT_GUN, IT_L6_40, ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "Italian air", X = 39, Y = 28, Domain = "Air", CivID = ITALY, Group = {IT_CR42, IT_CR42, IT_CR42}, UnitsXP = {9,9,9},  },
	{Name = "Italian air AI Bonus", X = 39, Y = 28, Domain = "Air", AI = true, CivID = ITALY, Group = {IT_CR42, IT_SM79, IT_SM79}, UnitsXP = {9,9,9},  },
	{Name = "Italian fleet", X = 39, Y = 24, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_ZARA, IT_DI_CAVOUR, IT_SUBMARINE, IT_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet 2", X = 46, Y = 14, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_DI_CAVOUR, IT_ZARA, IT_BATTLESHIP, IT_SUBMARINE}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet AI Bonus", X = 48, Y = 19, Domain = "Sea", AI = true, CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_SUBMARINE}, UnitsXP = {9,9,9},  },


	{Name = "Greek army", X = 54, Y = 19, Domain = "Land", CivID = GREECE, Group = {GR_INFANTRY, GR_INFANTRY, GR_INFANTRY, GR_VICKERS_MKE}, UnitsXP = {9,9,9,9},  },
	{Name = "Greek air force", X = 56, Y = 17, Domain = "Air", CivID = GREECE, Group = {GR_P24, GR_P24}, UnitsXP = {9,9},  },
	{Name = "Greek fleet", X = 58, Y = 20, Domain = "Sea", CivID = GREECE, Group = {GR_PISA, GR_GEORGIOS, GR_GEORGIOS, GR_SUBMARINE}, UnitsXP = {9,9,9,9},  },

}


-- Options
if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 1", X = 35, Y = 42, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"SF de Mulhouse"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 2", X = 35, Y = 43, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"SF de Colmar"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 3", X = 36, Y = 45, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Hochwald"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 4", X = 35, Y = 45, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Simserhof"},  })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 5", X = 35, Y = 46, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage de Fermont"}, })
end

if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Westwall 1", X = 37, Y = 42, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Isteiner Klotz"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 2", X = 38, Y = 44, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Offenburger Riegel"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 3", X = 37, Y = 46, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Ettlinger Riegel"}, })																																 
	table.insert (g_Initial_OOB,	{Name = "Westwall 4", X = 35, Y = 47, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Spichernstellung"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 5", X = 35, Y = 49, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Orscholzriegel"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 6", X = 35, Y = 51, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Huertgenwald"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 7", X = 36, Y = 53, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Geldernstellung"}, })
end


g_MinorMobilization_OOB = { 
	{Name = "Poland army",			X = 53, Y = 46,		Domain = "Land",	CivID = POLAND,		IsMinor = true, Group = {PL_INFANTRY, PL_VICKERS_MKE_A, PL_INFANTRY, PL_10TP, PL_7TP} },
	{Name = "Poland fortification", 	X = 52, Y = 49,		Domain = "Land",	CivID = POLAND,		IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Twierdza Modlin"}, },
	{Name = "Poland air force",		X = 53, Y = 48,		Domain = "Air",		CivID = POLAND,		IsMinor = true, Group = {PL_PZL37, PL_P11, } },
	{Name = "Poland fleet",			X = 51, Y = 56,		Domain = "Sea",		CivID = POLAND,		IsMinor = true, Group = {PL_SUBMARINE} },
	{Name = "Belgian army",			X = 32, Y = 49,		Domain = "City",	CivID = BELGIUM,	IsMinor = true, Group = {INFANTRY, DU_VICKERS_M1936} },
	{Name = "Netherlands army",		X = 34, Y = 52,		Domain = "City",	CivID = NETHERLANDS,	IsMinor = true, Group = {DU_INFANTRY, DU_VICKERS_M1936, DU_MTSL} },
	{Name = "Netherlands AF",		X = 34, Y = 52,		Domain = "Air",		CivID = NETHERLANDS,	IsMinor = true, Group = {DU_FOKKER_DXXI, DU_FOKKER_GI, DU_FOKKER_TV} },
	{Name = "Finland army",			X = 59, Y = 68,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, FI_BT42, ARTILLERY} },
	{Name = "Finland fortification",	X = 61, Y = 66,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },
	{Name = "Finland fortification",	X = 62, Y = 68,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },
	{Name = "Slovakia army",		X = 53, Y = 42,		Domain = "Land",	CivID = SLOVAKIA,	IsMinor = true, Group = {GE_INFANTRY, GE_PANZER_35, ARTILLERY} },
	{Name = "Slovakia army 2",		X = 50, Y = 42,		Domain = "Land",	CivID = SLOVAKIA,	IsMinor = true, Group = {GE_INFANTRY, GE_PANZER_35, AT_GUN} },
	{Name = "Romania army",			X = 59, Y = 36,		Domain = "Land",	CivID = ROMANIA,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, INFANTRY, RO_TACAM, ARTILLERY} },
	{Name = "Yugoslavia army",		X = 53, Y = 30,		Domain = "Land",	CivID = YUGOSLAVIA,	IsMinor = true, Group = {INFANTRY, INFANTRY, AT_GUN, INFANTRY, YU_SKODA, YU_SKODA, ARTILLERY} },
	{Name = "Bulgaria army",		X = 61, Y = 29,		Domain = "Land",	CivID = BULGARIA,	IsMinor = true, Group = {HU_INFANTRY, AT_GUN, HU_INFANTRY, ARTILLERY} },
	{Name = "Hungary army",			X = 52, Y = 39,		Domain = "Land",	CivID = HUNGARY,	IsMinor = true, Group = {HU_INFANTRY, HU_INFANTRY, HU_INFANTRY, HU_38M_TOLDI, HU_38M_TOLDI, HU_40M_TURAN, ARTILLERY} },
	{Name = "Hungary air force",	X = 51, Y = 38,		Domain = "Air",		CivID = HUNGARY,	IsMinor = true, Group = {HU_RE2000, HU_RE2000, HU_CA135} },
	{Name = "Sweden army",			X = 45, Y = 60,		Domain = "Land",	CivID = SWEDEN,		IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, ARTILLERY} },
	{Name = "Spanish army",			X = 13, Y = 30,		Domain = "Land",	CivID = SPAIN,		IsMinor = true, Group = {SP_INFANTRY, AT_GUN, SP_INFANTRY, AT_GUN, SP_INFANTRY, ARTILLERY} },
	
	{Name = "Generic army",			X = 36, Y = 40,		Domain = "City",	CivID = SWITZERLAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 7, Y = 30,		Domain = "City",	CivID = PORTUGAL,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 97, Y = 3,		Domain = "City",	CivID = ARABIA,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 66, Y = 24,		Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 73, Y = 22,		Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 40, Y = 59,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 43, Y = 57,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AA_GUN} },
	{Name = "Generic army",			X = 101, Y = 20,	Domain = "City",	CivID = IRAN,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, ARTILLERY} },
	{Name = "Generic army",			X = 20, Y = 59,		Domain = "City",	CivID = IRELAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, ARTILLERY} },
	{Name = "Generic army",			X = 44, Y = 66,		Domain = "City",	CivID = NORWAY,		IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 51, Y = 24,		Domain = "City",	CivID = ALBANIA,	IsMinor = true, Group = {INFANTRY, AT_GUN} },
}

---------------------------------------------------------------------------------------------------------------------------
-- Units Classes  (see RedDefines.lua for IDs and data table)
----------------------------------------------------------------------------------------------------------------------------

-- Minors classes replacing
-- (don't move to main defines file, must be placed after minor civs ID defines...)
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
}


----------------------------------------------------------------------------------------------------------------------------
-- Projects  (see RedDefines.lua for IDs and data table)
----------------------------------------------------------------------------------------------------------------------------

-- projects available at start of scenario
g_ProjectsAvailableAtStart = {
	[FRANCE] = {PROJECT_MB152},
	[USSR] = {PROJECT_KV1},
	[ITALY] = {PROJECT_M11_39, PROJECT_L6_40, PROJECT_G50 },
	[GERMANY] = {PROJECT_PANZER_III,  PROJECT_PANZER_IV },
	[ENGLAND] = {PROJECT_CRUISER_II, PROJECT_MATILDAII, PROJECT_MATILDAI, PROJECT_TETRARCH, },
}

g_Major_Projects = {
	[FRANCE] = {		
		PROJECT_H39, PROJECT_R40, PROJECT_ARL_44,
		PROJECT_W15_TCC, PROJECT_AMR35_ZT3, PROJECT_37L,
		PROJECT_SAU40,
		PROJECT_HOTCHKISS,
		PROJECT_MB152, PROJECT_D520,
		PROJECT_LN401, PROJECT_BR690, },  --PROJECT_JOFFRE,
	[USSR] = {
		PROJECT_BT7, PROJECT_T70, PROJECT_T34, PROJECT_T34_76, PROJECT_T34_85,
		PROJECT_KV1, PROJECT_KV2, PROJECT_IS_1, PROJECT_IS_2, PROJECT_IS_3, PROJECT_IS_7,
		PROJECT_SU122, PROJECT_SU152, PROJECT_ISU122, PROJECT_ISU152,
		PROJECT_ZIS30, PROJECT_SU76, PROJECT_SU85, PROJECT_SU100, 
		PROJECT_SU26, PROJECT_ZSU37, PROJECT_BM13, PROJECT_BM13_16,
		PROJECT_LAGG3, PROJECT_LA5, PROJECT_LA5_V2, PROJECT_LA7, PROJECT_YAK7, PROJECT_YAK9,
		PROJECT_IL2, PROJECT_IL2M3, PROJECT_IL10, PROJECT_IL4, PROJECT_TU2, PROJECT_PE8,
		PROJECT_SOYUZ,
		OPERATION_MOTHERLANDCALL, OPERATION_URANUS, OPERATION_MOSKWA}, 
	[GERMANY] = {
		PROJECT_PANZER_II_L, PROJECT_PANZER_III, PROJECT_PANZER_III_J, PROJECT_PANZER_IV, PROJECT_PANZER_IV_G, PROJECT_PANZER_IV_H,
		PROJECT_PANZER_V, PROJECT_PANZER_VI, PROJECT_PANZER_VIB, PROJECT_PANZER_VIII,
		PROJECT_PZJ_I, PROJECT_MARDER_I, PROJECT_MARDER_II, PROJECT_MARDER_II_D, PROJECT_MARDER_III, PROJECT_MARDER_III_H, PROJECT_MARDER_III_M,
		PROJECT_HETZER, PROJECT_NASHORN, PROJECT_PZJ_IV, PROJECT_PZJ_IV_L70, PROJECT_JAGDPANTHER, PROJECT_FERDINAND, PROJECT_JAGDTIGER,
		PROJECT_STUG_III, PROJECT_STUG_III_F, PROJECT_STUG_III_G, PROJECT_STUG_IV, PROJECT_BRUMMBAR, PROJECT_STURMTIGER,
		PROJECT_FLK_PZI, PROJECT_FLK_PZ38, PROJECT_MOBELWAGEN, PROJECT_WIRBELWIND, PROJECT_OSTWIND, PROJECT_KUGELBLITZ, PROJECT_COELIAN,
		PROJECT_BISON, PROJECT_GRILLE, PROJECT_WESPE, PROJECT_HUMMEL,
		PROJECT_BF109F, PROJECT_BF109G, PROJECT_FW190, PROJECT_ME262, PROJECT_BF110F4, PROJECT_HE219, 
		PROJECT_HE177, PROJECT_AR234, PROJECT_HO229, --PROJECT_ZEPPELIN, PROJECT_JU88C, 
		OPERATION_WESERUBUNG, OPERATION_SEELOWE, OPERATION_FALLGELB, OPERATION_SONNENBLUME, OPERATION_TWENTYFIVE, OPERATION_MARITA, },
	[ENGLAND] = {
		PROJECT_TETRARCH, PROJECT_CRUISER_II, PROJECT_CRUISER_III, PROJECT_CRUISER_IV, PROJECT_A15, PROJECT_A15_MKIII, PROJECT_A13,
		PROJECT_MATILDAI, PROJECT_MATILDAII, PROJECT_VALENTINE,
		PROJECT_CAVALIER, PROJECT_CENTAUR, PROJECT_CROMWELL, PROJECT_CHALLENGER, PROJECT_COMET,
		PROJECT_M4_FIREFLY, PROJECT_CHURCHILL, PROJECT_CENTURION, PROJECT_TORTOISE,
		PROJECT_ARCHER, PROJECT_CRUSADER, PROJECT_BISHOP,
		PROJECT_MOSQUITO, PROJECT_HURRICANE_II, PROJECT_SPITFIRE_V, PROJECT_SPITFIRE_IX, PROJECT_TYPHOON, PROJECT_TEMPEST, PROJECT_METEOR,
		PROJECT_BEAUFIGHTER, PROJECT_WHIRLWIND, PROJECT_LANCASTER, PROJECT_HALIFAX,  
		OPERATION_TORCH, OPERATION_HUSKY, OPERATION_AVALANCHE, OPERATION_OVERLORD},  --PROJECT_ARK_ROYAL,
	[ITALY] = {
		PROJECT_M13_40, PROJECT_M14_41, PROJECT_M15_42,  PROJECT_P26_40, PROJECT_M11_39, PROJECT_L6_40,
		PROJECT_SM41, PROJECT_L40, PROJECT_M42M, PROJECT_M42T, PROJECT_43, PROJECT_AUTOCANNONE,
		PROJECT_G50, PROJECT_G55, PROJECT_MC202, PROJECT_MC205, PROJECT_CAPRONI,
		PROJECT_SM84, },   --PROJECT_AQUILA
	[GREECE] = {
		},
}
----------------------------------------------------------------------------------------------------------------------------
-- Diplomacy
----------------------------------------------------------------------------------------------------------------------------

-- Protected minor civs
-- When one of those minor civs is receiving a declaration of war from another civ, the listed majors will declare war on it.
-- When one of the listed major is signing a peace treaty with another civ, the protected minor is signing it too.
g_MinorProtector = {
	[ALGERIA] = {FRANCE, }, 
	[TUNISIA] = {FRANCE, },  
	[MOROCCO] = {FRANCE, }, 
	[LEBANON] = {FRANCE, },
	[SYRIA] = {FRANCE, },  
	[BELGIUM] = {FRANCE, ENGLAND}, 
	[NETHERLANDS] = {FRANCE, ENGLAND}, 
	[EGYPT] = {ENGLAND, }, 
	[IRELAND] = {ENGLAND, }, 
	[PALESTINE] = {ENGLAND, },
	[PORTUGAL] = {ENGLAND, },
	[ALBANIA] = {ITALY, },
	[LIBYA] = {ITALY, }, 
	[ROMANIA] = {ITALY, GERMANY, },
	[BULGARIA] = {ITALY, GERMANY, },
	[SPAIN] = {ITALY, GERMANY, },
	[SLOVAKIA] = {GERMANY, }, 
	[HUNGARY] = {GERMANY, }, 
	[YUGOSLAVIA] = {GREECE, },
	[SWEDEN] = {FRANCE, ENGLAND, GERMANY, }, 
	[TURKEY] = {FRANCE, ENGLAND, GERMANY, ITALY, USSR, GREECE }, 
	[BALTIC] = {USSR}, 
}

-- Victory types
g_Victory = {
	[FRANCE] = "VICTORY_ALLIED_EUROPE",
	[ENGLAND] = "VICTORY_ALLIED_EUROPE",
	[GREECE] = "VICTORY_ALLIED_EUROPE",
	[USSR] = "VICTORY_USSR_EUROPE",
	[GERMANY] = "VICTORY_GERMANY_EUROPE",
	[ITALY] = "VICTORY_GERMANY_EUROPE",
}

-- Virtual allies
g_Allied = {
	[FRANCE] = true,
	[ENGLAND] = true,
	[USSR] = true,
	[GREECE] = true,
	
}
g_Axis = {
	[GERMANY] = true,
	[ITALY] = true,
}

-- check functions for diplomacy tables. Must be defined before the table, but can call functions defined later in the script.
function DiploFranceHasFallen()
	return FranceHasFallen()
end

-- Major Civilizations
-- to do in all table : add entry bCheck = function() return true or false, apply change only if true or nill

	g_Major_Diplomacy = {		
	
	[19390701] = { 
		{Type = DOF, Civ1 = FRANCE, Civ2 = ENGLAND},
		{Type = DOF, Civ1 = ENGLAND, Civ2 = GREECE},
		
	},	
	[19390820] = { 
		{Type = DEN, Civ1 = FRANCE, Civ2 = GERMANY},
		{Type = DEN, Civ1 = ENGLAND, Civ2 = GERMANY},
	},
	[19390901] = { 
		{Type = DEN, Civ1 = ITALY, Civ2 = FRANCE},
		{Type = DEN, Civ1 = ITALY, Civ2 = ENGLAND},
		{Type = DOF, Civ1 = GERMANY, Civ2 = USSR},
	},
	[19390903] = { 
		{Type = DOW, Civ1 = FRANCE, Civ2 = GERMANY},	
		{Type = DOW, Civ1 = ENGLAND, Civ2 = GERMANY},
		{Type = PEA, Civ1 = FRANCE, Civ2 = ENGLAND},
	},
	[19400610] = { 
		{Type = DOW, Civ1 = ITALY, Civ2 = FRANCE},
	},
	[19400620] = { 
		{Type = PEA, Civ1 = GERMANY, Civ2 = ITALY},
	},
	[19401028] = { 
		{Type = PEA, Civ1 = ENGLAND, Civ2 = GREECE},
	},
	[19410622] = { 
		{Type = DOW, Civ1 = GERMANY, Civ2 = USSR},
		{Type = DOW, Civ1 = ITALY, Civ2 = USSR},
	},
	[19410701] = { 
		{Type = DOF, Civ1 = FRANCE, Civ2 = USSR},
		{Type = DOF, Civ1 = ENGLAND, Civ2 = USSR},
		{Type = DOF, Civ1 = GREECE, Civ2 = USSR},
	},
}

-- Minor Civilizations
g_Minor_Relation = {
	[19390701] = { 
		{Value = 120, Major = FRANCE, Minor = ALGERIA},
		{Value = 120, Major = FRANCE, Minor = TUNISIA},
		{Value = 120, Major = FRANCE, Minor = MOROCCO},
		{Value = 120, Major = FRANCE, Minor = LEBANON},
		{Value = 120, Major = FRANCE, Minor = SYRIA},
		{Value = 50, Major = FRANCE, Minor = POLAND},
		{Value = 50, Major = FRANCE, Minor = BELGIUM},
		{Value = 50, Major = FRANCE, Minor = NETHERLANDS},
		{Value = 50, Major = FRANCE, Minor = NORWAY},
		{Value = 50, Major = FRANCE, Minor = EGYPT},
		{Value = 50, Major = FRANCE, Minor = PALESTINE},
		{Value = 50, Major = FRANCE, Minor = IRAQ},
		{Value = 50, Major = FRANCE, Minor = YUGOSLAVIA},
		{Value = 50, Major = FRANCE, Minor = SWEDEN},
		{Value = 120, Major = ENGLAND, Minor = EGYPT},
		{Value = 120, Major = ENGLAND, Minor = PALESTINE},
		{Value = 120, Major = ENGLAND, Minor = IRAQ},
		{Value = 50, Major = ENGLAND, Minor = ALGERIA},
		{Value = 50, Major = ENGLAND, Minor = TUNISIA},
		{Value = 50, Major = ENGLAND, Minor = MOROCCO},
		{Value = 50, Major = ENGLAND, Minor = LEBANON},
		{Value = 50, Major = ENGLAND, Minor = SYRIA},
		{Value = 50, Major = ENGLAND, Minor = POLAND},
		{Value = 50, Major = ENGLAND, Minor = BELGIUM},
		{Value = 50, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 50, Major = ENGLAND, Minor = SWEDEN},
		{Value = 50, Major = ENGLAND, Minor = NORWAY},
		{Value = 50, Major = ENGLAND, Minor = YUGOSLAVIA},
		{Value = 50, Major = GERMANY, Minor = SLOVAKIA},
		{Value = 50, Major = GERMANY, Minor = HUNGARY},
		{Value = 50, Major = GERMANY, Minor = ROMANIA},
		{Value = 50, Major = GERMANY, Minor = LIBYA},
		{Value = 50, Major = GERMANY, Minor = ALBANIA},
		{Value = 50, Major = GERMANY, Minor = SWEDEN},
		{Value = 120, Major = ITALY, Minor = LIBYA},
		{Value = 120, Major = ITALY, Minor = ALBANIA},
		{Value = 50, Major = ITALY, Minor = SLOVAKIA},
		{Value = 50, Major = ITALY, Minor = HUNGARY},
		{Value = 50, Major = ITALY, Minor = ROMANIA},
		{Value = 50, Major = ITALY, Minor = SWEDEN},
		{Value = 50, Major = USSR, Minor = IRAQ},
		{Value = 50, Major = USSR, Minor = IRAN},
		{Value = 50, Major = USSR, Minor = PALESTINE},
		{Value = 50, Major = USSR, Minor = EGYPT},
		{Value = -50, Major = USSR, Minor = FINLAND},
	},
	[19400410] = { 
		{Value = 100, Major = FRANCE, Minor = NORWAY},
		{Value = 120, Major = ENGLAND, Minor = NORWAY},
	},
		[19400512] = { 
		{Value = 100, Major = ENGLAND, Minor = BELGIUM},
		{Value = 120, Major = FRANCE, Minor = NETHERLANDS},
		{Value = 100, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 120, Major = FRANCE, Minor = BELGIUM},
	},
	[19401028] = { 
		{Value = -50, Major = ITALY, Minor = YUGOSLAVIA},
	},
	[19410401] = { 
		{Value = -70, Major = ENGLAND, Minor = IRAQ},
		{Value = 50, Major = GERMANY, Minor = IRAQ},
	},	
	[19410406] = {
		{Value = 120, Major = GERMANY, Minor = BULGARIA},
		{Value = 120, Major = GERMANY, Minor = SLOVAKIA},
		{Value = 120, Major = GERMANY, Minor = HUNGARY},
		{Value = 120, Major = GERMANY, Minor = ROMANIA},
		{Value = 120, Major = GREECE, Minor = YUGOSLAVIA},
	},
	[19410622] = { 
		{Value = 120, Major = GERMANY, Minor = FINLAND},
		{Value = 50, Major = ITALY, Minor = FINLAND},
	},
	[19420318] = { 
		{Value = -120, Major = GREECE, Minor = HUNGARY},		
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
	[19410406] = { 
		{Major = GERMANY, Minor = YUGOSLAVIA},
		{Major = ITALY, Minor = YUGOSLAVIA},
	},
	[19410410] = { 
		{Major = FRANCE, Minor = SLOVAKIA},
		{Major = FRANCE, Minor = HUNGARY},
		{Major = FRANCE, Minor = BULGARIA},
		{Major = ENGLAND, Minor = SLOVAKIA},
		{Major = ENGLAND, Minor = HUNGARY},
		{Major = ENGLAND, Minor = BULGARIA},
	},
	[19410825] = {
		{Major = USSR, Minor = IRAN},
		{Major = ENGLAND, Minor = IRAN},
	},
}
g_Major_Minor_Peace = {
	[19400313] = { 
		{Major = USSR, Minor = FINLAND},	
	},
	[19430901] = {
		{Major = USSR, Minor = IRAN},
		{Major = ENGLAND, Minor = IRAN},
	},
}
g_Minor_Minor_DoW = {
}
g_Minor_Major_DoW = {


	[19410622] = { 
		{Minor = FINLAND, Major = USSR},
	},
	[19430909] = {
		{Minor = IRAN, Major = GERMANY},
	},
}

----------------------------------------------------------------------------------------------------------------------------
-- Cities
----------------------------------------------------------------------------------------------------------------------------

-- Populate cities with buildings
-- Key cities are cities that need to be occupied to trigger victory
g_Cities = {
	-- UNITED KINGDOM
	{X = 27, Y = 52, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- LONDON
	{X = 24, Y = 57, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, SMALL_AIR_FACTORY}, }, -- LIVERPOOL
	{X = 26, Y = 61, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD}, }, -- EDINBURGH
	{X = 24, Y = 62, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- GLASGOW
	{X = 28, Y = 58, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, LARGE_AIR_FACTORY}, }, -- NEWCASTLE
	{X = 10, Y = 25, Buildings = { HARBOR, BASE }, AIBuildings = {FACTORY}, }, -- GIBRALTAR
	{X = 41, Y = 14, Buildings = { HARBOR, BASE }, AIBuildings = {FACTORY, ARSENAL}, }, -- MALTA
	{X = 22, Y = 52, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- PLYMOUTH
	{X = 92, Y = 11, AIBuildings = {FACTORY}, }, -- HABBANIYA
	{X = 60, Y = 3, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- SIDI BARRANI
	{X = 73, Y = 2,  AIBuildings = {FACTORY}, }, -- SUEZ
	{X = 29, Y = 54, Buildings = { HARBOR }, AIBuildings = {FACTORY, ARSENAL}, }, -- NORWICH
	{X = 25, Y = 54, AIBuildings = {FACTORY}, }, -- BIRMINGHAM
	{X = 74, Y = 12, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- NICOSIA
	{X = 28, Y = 68, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- KIRKWALL (Scapa Flow)

	-- GERMANY
	{X = 44, Y = 50, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- BERLIN
	{X = 39, Y = 46, Key = true, Buildings = { BANK, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {FACTORY, SMALL_AIR_FACTORY}, }, -- FRANKFURT
	{X = 39, Y = 53, Key = true, Buildings = { BANK, HARBOR, FACTORY , BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {FACTORY, BARRACKS, SHIPYARD, BASE, OIL_REFINERY}, }, -- HAMBURG
	{X = 41, Y = 41, Key = true, Buildings = { BANK, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {BARRACKS, LAND_FACTORY, ARSENAL, BASE, OIL_REFINERY}, }, -- MUNICH
	{X = 45, Y = 43, Buildings = { FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- PRAGUE
	{X = 40, Y = 55, Buildings = { HARBOR, FACTORY, OIL_REFINERY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- KIEL
	{X = 39, Y = 43, Buildings = {FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY},}, -- NUREMBERG
	{X = 52, Y = 53, Buildings = { HARBOR, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- KONIGSBERG
	{X = 46, Y = 52, Buildings = { HARBOR, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- STETTIN
	{X = 36, Y = 50, Buildings = { FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- ESSEN
	{X = 36, Y = 49, Buildings = { FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- COLOGNE
	{X = 48, Y = 46, Buildings = {FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- BRESLAU
	{X = 45, Y = 46, Buildings = {FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- DRESDEN
	{X = 42, Y = 48, Buildings = {FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- LEIPZIG
	{X = 47, Y = 40, Buildings = { FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, }, -- VIENNA

	-- FRANCE
	{X = 28, Y = 45, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, ACADEMY, HOSPITAL, OPEN_CITY }, AIBuildings = {LAND_FACTORY}, }, -- PARIS	
	{X = 29, Y = 34, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD}, }, -- MARSEILLE
	{X = 30, Y = 38, Buildings = { FACTORY, ACADEMY, ARSENAL}, AIBuildings = {SMALL_AIR_FACTORY, BASE}, }, -- LYON
	{X = 25, Y = 36, Buildings = { FACTORY }, AIBuildings = {LAND_FACTORY, BASE}, }, -- TOULOUSE
	{X = 25, Y = 46, Key = true,  AIBuildings = {FACTORY, ARSENAL}, }, -- CAEN
	{X = 23, Y = 48, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- CHERBOURG
	{X = 16, Y = 18, Buildings = { BARRACKS, LEGION_HQ }, AIBuildings = {FACTORY}, }, -- SIDI BEL ABBES
	{X = 33, Y = 27, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- AJACCIO
	{X = 21, Y = 45, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- SAINT NAZAIRE
	{X = 19, Y = 48, AIBuildings = {FACTORY}, }, -- BREST
	{X = 33, Y = 34, AIBuildings = {FACTORY}, }, -- NICE
	{X = 22, Y = 39, Key = true,  AIBuildings = {FACTORY, ARSENAL}, }, -- BORDEAUX
	{X = 21, Y = 42, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- LA ROCHELLE
	{X = 34, Y = 46, AIBuildings = {FACTORY, OPEN_CITY}, }, -- METZ
	{X = 84, Y = 12, AIBuildings = {FACTORY}, }, -- PALMYRA
	{X = 27, Y = 39, AIBuildings = {FACTORY}, }, -- VICHY
	{X = 25, Y = 42, AIBuildings = {FACTORY}, }, -- TOURS
	{X = 29, Y = 50, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, ARSENAL}, }, -- DUNKERQUE
	{X = 31, Y = 46, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY}, }, -- REIMS
	{X = 30, Y = 41, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY}, }, -- DIJON
	{X = 34, Y = 42, Buildings = { OPEN_CITY }, AIBuildings = {FACTORY}, }, -- MULHOUSE

	-- ITALY
	{X = 39, Y = 28, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- ROME
	{X = 41, Y = 25, Key = true, Buildings = { HARBOR }, AIBuildings = { FACTORY, SHIPYARD }, }, -- NAPLES
	{X = 36, Y = 36, Key = true, Buildings = { FACTORY }, AIBuildings = { SMALL_AIR_FACTORY }, }, -- MILAN
	{X = 38, Y = 34, Key = true, Buildings = { FACTORY }, AIBuildings = { LARGE_AIR_FACTORY }, }, -- BOLOGNE
	{X = 40, Y = 19, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- PALERMO
	{X = 33, Y = 23, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- CAGLIARI
	{X = 44, Y = 19, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- REGGIO CALABRIA
	{X = 42, Y = 17, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- CATANIA
	{X = 35, Y = 34, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- GENOVA
	{X = 43, Y = 35, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- TRIESTE
	{X = 40, Y = 35, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- VENICE
	{X = 38, Y = 31, AIBuildings = {FACTORY}, }, -- FLORENCE
	{X = 56, Y = 5,  Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- TOBRUK
	{X = 46, Y = 24, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- BARI
	{X = 41, Y = 29, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- PESCARA
	{X = 62, Y = 14, Buildings = { HARBOR, BASE }, AIBuildings = {FACTORY}, }, -- RHODES

	-- U.S.S.R.
	{X = 72, Y = 58, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- MOSCOW
	{X = 84, Y = 48, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LARGE_AIR_FACTORY, RADIO}, }, -- STALINGRAD
	{X = 66, Y = 44, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY}, }, -- KIEV
	{X = 64, Y = 64, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD, BASE, RADIO}, }, -- LENINGRAD
	{X = 65, Y = 85, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- MURMANSK
	{X = 67, Y = 37, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- ODESSA
	{X = 73, Y = 43, AIBuildings = {FACTORY}, }, -- KHARKOV
	{X = 85, Y = 41, AIBuildings = {FACTORY}, }, -- ELISTA
	{X = 77, Y = 48, AIBuildings = {FACTORY}, }, -- VORONEZH
	{X = 102, Y = 75, AIBuildings = {FACTORY}, }, -- BEREZOVO
	{X = 70, Y = 78, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- ARKHANGEL'SK
	{X = 72, Y = 47, AIBuildings = {FACTORY}, }, -- KURSK
	{X = 74, Y = 62, AIBuildings = {FACTORY}, }, -- YAROSLAVL'
	{X = 92, Y = 61, AIBuildings = {FACTORY}, }, -- PERM'
	{X = 61, Y = 52, AIBuildings = {FACTORY}, }, -- MINSK
	{X = 89, Y = 53, AIBuildings = {FACTORY}, }, -- KUYBYSHEV
	{X = 97, Y = 51, AIBuildings = {FACTORY}, }, -- CHKALOV
	{X = 68, Y = 51, AIBuildings = {FACTORY}, }, -- BRYANSK
	{X = 101, Y = 55, AIBuildings = {FACTORY}, }, -- CHELYABINSK
	{X = 61, Y = 60, AIBuildings = {FACTORY}, }, -- PSKOV
	{X = 80, Y = 60, AIBuildings = {BARRACKS, FACTORY, SMALL_AIR_FACTORY, BASE, RADIO},}, -- GORKY
	{X = 66, Y = 55, AIBuildings = {FACTORY}, }, -- SMOLENSK
	{X = 91, Y = 35, AIBuildings = {FACTORY}, }, -- GROZNY
	{X = 78, Y = 38, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- ROSTOV
	{X = 98, Y = 31, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- BAKU
	{X = 71, Y = 33, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD, RADIO},}, -- SEVASTOPOL

	-- GREECE
	{X = 58, Y = 11, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- HERAKLION
	{X = 54, Y = 16, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- PATRAS
	{X = 59, Y = 24, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- KAVALA
	{X = 56, Y = 22, Buildings = { HARBOR }, AIBuildings = {FACTORY}, }, -- THESSALONIKI
	{X = 56, Y = 17, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- ATHENS
	{X = 53, Y = 20, AIBuildings = {FACTORY}, }, -- IOANNINA
	-- ALGERIA
	{X = 15, Y = 20, Buildings = { HARBOR }, }, -- ORAN
	{X = 21, Y = 21, Buildings = { HARBOR }, }, -- ALGER
	-- ROMANIA
	{X = 55, Y = 35, }, -- TIMISOARA
	{X = 60, Y = 33, }, -- BUCAREST
	-- MOROCCO
	{X = 4, Y = 17, Buildings = { HARBOR }, }, -- CASABLANCA
	{X = 4, Y = 14, }, -- MARRAKECH
	{X = 7, Y = 18, Buildings = { HARBOR }, }, -- RABAT
	-- EGYPT
	{X = 68, Y = 3, Buildings = { HARBOR }, }, -- ALEXANDRIA
	{X = 70, Y = 1, }, -- CAIRO
	{X = 66, Y = 2, Buildings = { HARBOR }, }, -- ALAMEIN
	-- LEBANON
	{X = 78, Y = 10, Buildings = { HARBOR }, }, -- BEIRUT
	-- FINLAND
	{X = 58, Y = 77, Buildings = { HARBOR }, }, -- OULU
	{X = 59, Y = 83, }, -- INARI
	{X = 57, Y = 65, Buildings = { HARBOR }, }, -- HELSINKI
	-- DENMARK
	{X = 16, Y = 82, Buildings = { HARBOR }, }, -- REYKJAVIK
	{X = 43, Y = 57, Buildings = { HARBOR }, }, -- COPENHAGEN
	{X = 40, Y = 59, Buildings = { HARBOR }, }, -- AALBORG
	-- BALTIC STATES
	{X = 57, Y = 58, Buildings = { HARBOR }, }, -- RIGA
	{X = 57, Y = 63, Buildings = { HARBOR }, }, -- TALLINN
	{X = 57, Y = 53, }, -- VILNIUS
	-- SAUDI ARABIA
	{X = 103, Y = 1, }, -- ANK
	-- IRAN
	{X = 101, Y = 20, }, -- TEHRAN
	-- SWITZERLAND
	{X = 33, Y = 39, }, -- BERN
	-- IRAQ
	{X = 95, Y = 10, }, -- BAGHDAD
	-- TUNISIA
	{X = 33, Y = 17, Buildings = { HARBOR }, }, -- TUNIS
	-- SPAIN
	{X = 15, Y = 32, }, -- MADRID
	{X = 9, Y = 27, }, -- SEVILLE
	{X = 22, Y = 31, Buildings = { HARBOR }, }, -- BARCELONE
	-- SLOVAKIA
	{X = 49, Y = 40, }, -- BRATISLAVA
	-- SWEDEN
	{X = 55, Y = 78, Buildings = { HARBOR }, }, -- LULEA
	{X = 53, Y = 81, }, -- KIRUNA
	{X = 44, Y = 61, Buildings = { HARBOR }, }, -- GOTEBORG
	{X = 50, Y = 64, Buildings = { HARBOR }, }, -- STOCKHOLM
	-- ALBANIA
	{X = 51, Y = 24, }, -- TIRANA
	-- NORWAY
	{X = 44, Y = 66, Buildings = { HARBOR }, },	-- OSLO
	{X = 51, Y = 85, Buildings = { HARBOR }, },	-- NARVIK

	-- NETHERLANDS
	{X = 34, Y = 52,Buildings = { HARBOR },  }, -- AMSTERDAM
	-- HUNGARY
	{X = 51, Y = 38, }, -- BUDAPEST
	-- IRELAND
	{X = 20, Y = 59, Buildings = { HARBOR }, }, -- DUBLIN
	-- BELGIUM
	{X = 32, Y = 49, }, -- BRUSSEL
	-- PORTUGAL
	{X = 8, Y = 34, Buildings = { HARBOR }, }, -- PORTO
	{X = 7, Y = 30, Buildings = { HARBOR }, }, -- LISBON
	-- TURKEY
	{X = 79, Y = 16, }, -- GAZIANTEP
	{X = 66, Y = 24, Buildings = { HARBOR }, }, -- ISTANBUL
	{X = 73, Y = 22, }, -- ANKARA
	-- YUGOSLAVIA
	{X = 49, Y = 31, }, -- SARAJEVO
	{X = 46, Y = 35, }, -- ZAGREB
	{X = 52, Y = 32, }, -- BELGRADE
	-- BULGARIA
	{X = 56, Y = 27, }, -- SOFIA
	-- SYRIA
	{X = 80, Y = 9, }, -- DAMASCUS
	-- POLAND
	{X = 53, Y = 44, }, -- KRAKOW
	{X = 48, Y = 49, }, -- POZNAN
	{X = 58, Y = 49, }, -- PINSK
	{X = 49, Y = 53, Buildings = { HARBOR }, }, -- DANZIG
	{X = 53, Y = 48, }, -- WARSAW
	{X = 56, Y = 48, }, -- BREST-LITOVSK
	{X = 57, Y = 44, }, -- LWOW
	-- LIBYA
	{X = 51, Y = 5, Buildings = { HARBOR }, }, -- BENGHAZI
	{X = 39, Y = 7, Buildings = { HARBOR }, }, -- TRIPOLI
	-- PALESTINE
	{X = 77, Y = 7, Buildings = { HARBOR }, }, -- HAIFA
}


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
