-- Earth1936Defines
-- Author: Gedemon (Edited By CommanderBly)
-- DateCreated: 8/17/2012
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

print("Loading Earth 1936 Defines...")
print("-------------------------------------")

----------------------------------------------------------------------------------------------------------------------------
-- Scenario Rules
----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
-- Scenario Specific Rules
----------------------------------------------------------------------------------------------------------------------------

WAR_MINIMUM_STARTING_TURN		= 5
REVEAL_ALL_CITIES				= true	-- cities tiles are always visible for every civs
EMBARK_FROM_HARBOR				= true	-- allow embarking only from a city with a port (and adjacent tiles)
BEACHHEAD_DAMAGE				= true	-- Amphibious assault on an empty tile owned by enemy civ will cause damage to the landing unit (not implemented)
USE_EARTH_MOVE					= false  -- -1 move for every landunit, -2 range for every air unit
CLOSE_MINOR_NEUTRAL_CIV_BORDERS = true	-- if true neutral territories is impassable
RESOURCE_CONSUMPTION			= true	-- Use resource consumption (fuel, ...)


----------------------------------------------------------------------------------------------------------------------------
-- AI Rules
----------------------------------------------------------------------------------------------------------------------------

ALLOW_AI_CONTROL			= true -- Allow the use of functions to (try to) control the AI units and build list
NO_AI_EMBARKATION			= true -- remove AI ability to embark (to do : take total control of AI unit to embark)
NO_SUICIDE_ATTACK			= true -- If set to true, try to prevent suicide attacks
UNIT_SUPPORT_LIMIT_FOR_AI	= true -- Allow limitation of max number of AI units based on number of supported units
	
AI_LAND_MINIMAL_RESERVE		= 15	
AI_AIR_MINIMAL_RESERVE		= 10	
AI_SEA_MINIMAL_RESERVE		= 8	

----------------------------------------------------------------------------------------------------------------------------
-- Calendar
----------------------------------------------------------------------------------------------------------------------------
REAL_WORLD_ENDING_DATE	= 19500105
MAX_FALL_OF_FRANCE_DATE = 19420101 -- France will not surrender if Paris fall after this date...

if(PreGame.GetGameOption("PlayEpicGame") ~= nil) and (PreGame.GetGameOption("PlayEpicGame") > 0) then
	g_Calendar = {}
	local monthList = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local dayList = { "1", "5", "10", "15", "20", "25" }
	local turn = 0
	for year = 1938, 1947 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 3 and year == 1938) -- Start date !
				if bStart or (year > 1938) then
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
	for year = 1938, 1946 do -- see large
		for month = 1, #monthList do
			for day = 1, #dayList do
				local bStart = (month >= 8 and year == 1938) -- Start date !
				if bStart or (year > 1938) then
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

ARGENTINA = GameInfo.MinorCivilizations.MINOR_CIV_ARGENTINA.ID
AUSTRALIA = GameInfo.MinorCivilizations.MINOR_CIV_AUSTRALIA.ID
ARABIA = GameInfo.MinorCivilizations.MINOR_CIV_ARABIA.ID
AUSTRIA = GameInfo.MinorCivilizations.MINOR_CIV_AUSTRIA.ID
BALTIC = GameInfo.MinorCivilizations.MINOR_CIV_BALTIC_STATES.ID
BELGIUM = GameInfo.MinorCivilizations.MINOR_CIV_BELGIUM.ID
BRAZIL = GameInfo.MinorCivilizations.MINOR_CIV_BRAZIL.ID
BULGARIA = GameInfo.MinorCivilizations.MINOR_CIV_BULGARIA.ID
CANADA = GameInfo.MinorCivilizations.MINOR_CIV_CANADA.ID
CENTRAL = GameInfo.MinorCivilizations.MINOR_CIV_CENTRALAMERICA.ID
CHILE = GameInfo.MinorCivilizations.MINOR_CIV_CHILE.ID
COLOMBIA = GameInfo.MinorCivilizations.MINOR_CIV_COLOMBIA.ID
COMCHINA = GameInfo.MinorCivilizations.MINOR_CIV_COMCHINA.ID
CZECHOSLOVAKIA = GameInfo.MinorCivilizations.MINOR_CIV_CZECHOSLOVAKIA.ID
DENMARK = GameInfo.MinorCivilizations.MINOR_CIV_DENMARK.ID
ECUADOR = GameInfo.MinorCivilizations.MINOR_CIV_ECUADOR.ID
FINLAND = GameInfo.MinorCivilizations.MINOR_CIV_FINLAND.ID
GREECE = GameInfo.MinorCivilizations.MINOR_CIV_GREECE.ID
HUNGARY = GameInfo.MinorCivilizations.MINOR_CIV_HUNGARY.ID
IRELAND = GameInfo.MinorCivilizations.MINOR_CIV_IRELAND.ID
MEXICO = GameInfo.MinorCivilizations.MINOR_CIV_MEXICO.ID
MONGOLIA = GameInfo.MinorCivilizations.MINOR_CIV_MONGOLIA.ID
NSPAIN = GameInfo.MinorCivilizations.MINOR_CIV_NATIONALISTSPAIN.ID
NETHERLANDS = GameInfo.MinorCivilizations.MINOR_CIV_NETHERLANDS.ID
NEWZEALAND = GameInfo.MinorCivilizations.MINOR_CIV_NEWZEALAND.ID
NORWAY = GameInfo.MinorCivilizations.MINOR_CIV_NORWAY.ID
PERU = GameInfo.MinorCivilizations.MINOR_CIV_PERU.ID
POLAND = GameInfo.MinorCivilizations.MINOR_CIV_POLAND.ID
PORTUGAL = GameInfo.MinorCivilizations.MINOR_CIV_PORTUGAL.ID
RSPAIN = GameInfo.MinorCivilizations.MINOR_CIV_REPUBLICANSPAIN.ID
ROMANIA = GameInfo.MinorCivilizations.MINOR_CIV_ROMANIA.ID
SOUTHAFRICA = GameInfo.MinorCivilizations.MINOR_CIV_SOUTHAFRICA.ID
SWEDEN = GameInfo.MinorCivilizations.MINOR_CIV_SWEDEN.ID
SWITZERLAND = GameInfo.MinorCivilizations.MINOR_CIV_SWITZERLAND.ID
THAILAND = GameInfo.MinorCivilizations.MINOR_CIV_THAILAND.ID
TURKEY = GameInfo.MinorCivilizations.MINOR_CIV_TURKEY.ID
URAGUAY = GameInfo.MinorCivilizations.MINOR_CIV_URAGUAY.ID
VENEZUELA = GameInfo.MinorCivilizations.MINOR_CIV_VENEZUELA.ID
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
	[FRANCE] = 20,
	[ENGLAND] = 20,
	[USSR] = 30,
	[GERMANY] = 30,
	[ITALY] = 20,
	[AMERICA] = 30,
	[JAPAN] = 30,
	[CHINA] = 20,
	
}

-- Available units for minor civs
g_Minor_Units = {}

-- unit type called when AI need reserve troops
g_Reserve_Unit = {
	[FRANCE] = { {Prob = 50, ID = FR_INFANTRY}, {Prob = 10, ID = FR_AMR35}, {Prob = 10, ID = FR_FCM36}, {Prob = 5, ID = FR_AMC35}, {Prob = 5, ID = FR_CHAR_D1}, {Prob = 5, ID = FR_CHAR_D2}, },
	[ENGLAND] = { {Prob = 50, ID = UK_INFANTRY}, {Prob = 20, ID = UK_VICKERS_MK6B}, {Prob = 10, ID = UK_TETRARCH}, {Prob = 5, ID = US_M3GRANT},  },
	[USSR] = { {Prob = 50, ID = RU_INFANTRY}, {Prob = 20, ID = RU_T26}, {Prob = 15, ID = RU_T28},  },
	[GERMANY] = { {Prob = 50, ID = GE_INFANTRY}, {Prob = 20, ID = GE_PANZER_I}, {Prob = 15, ID = GE_PANZER_35},  },
	[ITALY] = { {Prob = 50, ID = IT_INFANTRY}, {Prob = 20, ID = IT_L6_40}, {Prob = 15, ID = IT_M11_39},  },
	[AMERICA] = { {Prob = 50, ID = US_INFANTRY}, {Prob = 25, ID = US_M3STUART}, {Prob = 10, ID = US_M3GRANT},  },
	[JAPAN] = { {Prob = 75, ID = JP_INFANTRY}, {Prob = 25, ID = JP_TYPE97_SHINHOTO}},
	[CHINA] = { {Prob = 75, ID = CH_INFANTRY}, {Prob = 15, ID = US_M3STUART}, {Prob = 10, ID = CH_T26B},  },
}


-- Thresholds used to check if AI need to call reserve troops
g_Reserve_Data = { 
	-- UnitThreshold : minimum number of land units left
	-- LandThreshold : minimum number of plot left
	-- LandUnitRatio : ratio between lands and units, use higher ratio when the nation as lot of space between cities
	[GERMANY] = {	UnitThreshold = 10, LandThreshold = 55, LandUnitRatio = 5, -- 55 total
					},
	[CHINA] = {	UnitThreshold = 13, LandThreshold = 352, LandUnitRatio = 20, -- 440 Total
					},
}

-- Combat type ratio restriction used by AI
g_Combat_Type_Ratio = { 
	-- Air		<= military units / air units
	-- Sea		<= military units / sea units
	-- Land		<= military units / land units
	-- ( 1 = no limit )
	[FRANCE] 	= {Air = 10,		Sea = 10,	 	Land = 1.4,	},--Air = 5
	[ENGLAND]	= {Air = 8,			Sea = 4,		Land = 2,	},--Air = 4
	[USSR]		= {Air = 10,		Sea = 10,		Land = 1.2,	},--Air = 5
	[GERMANY]	= {Air = 6,			Sea = 6.6,		Land = 1.6,	},--Air = 4
	[ITALY]		= {Air = 10,		Sea = 5,		Land = 1.6,	},--Air = 5
	[AMERICA]	= {Air = 8,			Sea = 4,		Land = 2,	},--Air = 4
	[JAPAN]		= {Air = 8,		Sea = 5,		Land = 1.6,	},--Air = 5
	[CHINA]		= {Air = 10,			Sea = 5,		Land = 1.4,	},--Air = 4
	[MINOR]		= {Air = 10,		Sea = 5,		Land = 1.6,	},--Air = 5
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
	
	[JAPAN]		= {	[CLASS_INFANTRY] = 20, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 10,  [CLASS_AA_GUN] = 3,	
				[CLASS_LIGHT_TANK] = 20, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 20, [CLASS_HEAVY_TANK] = 15, [CLASS_LIGHT_TANK_DESTROYER] = 5, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 2,	},	
	
	[CHINA]		= {	[CLASS_INFANTRY] = 40, [CLASS_INFANTRY_2] = 0, [CLASS_PARATROOPER] = 4, [CLASS_SPECIAL_FORCES] = 1, [CLASS_MECHANIZED_INFANTRY] = 0, [CLASS_ARTILLERY] = 25,  [CLASS_AA_GUN] = 0,	
				[CLASS_LIGHT_TANK] = 30, [CLASS_CRUISER_TANK] = 0, [CLASS_TANK] = 0, [CLASS_HEAVY_TANK] = 0, [CLASS_LIGHT_TANK_DESTROYER] = 0, [CLASS_TANK_DESTROYER] = 0,  [CLASS_ASSAULT_GUN] = 0,	},	

}

-- Air type ratio restriction used by AI
g_Max_Air_SubClass_Percent = {		-- max num	<= air units / type units possible
	[FRANCE]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 20, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 0,  [CLASS_HEAVY_BOMBER] = 0,	},
	[ENGLAND]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 10,	},
	[USSR]		= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 20, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 10,	},
	[GERMANY]	= {	[CLASS_FIGHTER] = 25, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 15, [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 10,	},
	[ITALY]		= {	[CLASS_FIGHTER] = 40, [CLASS_FIGHTER_BOMBER] = 15, [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 15, [CLASS_FAST_BOMBER] = 15, [CLASS_BOMBER] = 15, [CLASS_HEAVY_BOMBER] = 0,	},
	[AMERICA]	= {	[CLASS_FIGHTER] = 30, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 10, [CLASS_ATTACK_AIRCRAFT] = 0,  [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 20, [CLASS_HEAVY_BOMBER] = 20,	},
	[JAPAN]		= { [CLASS_FIGHTER] = 50, [CLASS_FIGHTER_BOMBER] = 10, [CLASS_HEAVY_FIGHTER] = 10, [CLASS_ATTACK_AIRCRAFT] = 10, [CLASS_FAST_BOMBER] = 10, [CLASS_BOMBER] = 10, [CLASS_HEAVY_BOMBER] = 0,	},
	[CHINA]		= {	[CLASS_FIGHTER] = 60, [CLASS_FIGHTER_BOMBER] = 0,  [CLASS_HEAVY_FIGHTER] = 0,  [CLASS_ATTACK_AIRCRAFT] = 0,  [CLASS_FAST_BOMBER] = 0,  [CLASS_BOMBER] = 40, [CLASS_HEAVY_BOMBER] = 0,	},
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
	[JAPAN]		= {	[CLASS_DESTROYER] = 25, [CLASS_CRUISER] = 25, [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 10, [CLASS_BATTLESHIP_2] = 10, [CLASS_SUBMARINE] = 20, [CLASS_SUBMARINE_2] = 5,	[CLASS_CARRIER] = 5,},
	[CHINA]		= {	[CLASS_DESTROYER] = 0,  [CLASS_CRUISER] = 0,  [CLASS_HEAVY_CRUISER] = 0,  [CLASS_DREADNOUGHT] = 0,  [CLASS_BATTLESHIP] = 0,  [CLASS_BATTLESHIP_2] = 0,  [CLASS_SUBMARINE] = 0,	[CLASS_CARRIER] = 0,},
}

-- Order of Battle
-- group size = 7 units max placed in (and around) plot (x,y), except air placed only in central plot (should be city plot)
-- we can initialize any units for anyone here, no restriction by nation like in build list
g_Initial_OOB = {
-- France
	{Name = "French north army", X = 14, Y = 65, Domain = "Land", CivID = FRANCE, Group = {FR_INFANTRY, FR_AMR35, FR_B1, AT_GUN}, UnitsXP = {9,9,9,9},  },
	{Name = "French south army", X = 14, Y = 61, Domain = "Land", AI = true, CivID = FRANCE, Group = {FR_INFANTRY, FR_CHAR_D1, AT_GUN}, UnitsXP = {9,9,9},  },
	{Name = "French metr. aviation", X = 13, Y = 65, Domain = "Air", CivID = FRANCE, Group = {FR_MS406 }, UnitsXP = {9},  },
	{Name = "French metr. aviation AI Bonus", X = 15, Y = 67, Domain = "Air", AI = true, CivID = FRANCE, Group = {FR_MB152 }, UnitsXP = {9},  },
	{Name = "French Mediteranean fleet", X = 15, Y = 57, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_SUBMARINE, FR_GALISSONIERE, FR_GALISSONIERE, FR_BATTLESHIP, FR_BATTLESHIP_2}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "French North Africa", X = 11, Y = 47, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_AMC35, FR_CHAR_D2}, UnitsXP = {9,9,9},  },
	{Name = "French Syria", X = 41, Y = 50, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_FCM36}, UnitsXP = {9,9},  },
	{Name = "French Oceanic fleet", X = 4, Y = 66, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE, FR_GALISSONIERE, FR_SUBMARINE, FR_SUBMARINE, FR_GALISSONIERE, FR_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "French Indochina", X = 79, Y = 39, Domain = "Land", CivID = FRANCE, Group = {FR_LEGION, FR_INFANTRY}, UnitsXP = {9,9},  },
	{Name = "French Pacific fleet", X = 81, Y = 38, Domain = "Sea", CivID = FRANCE, Group = {FR_FANTASQUE, FR_FANTASQUE}, UnitsXP = {9,9},  },
-- UK
	{Name = "England Metropole army", X = 10, Y = 71, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_CRUISER_I, UK_VICKERS_MK6B}, UnitsXP = {9,9,9},  },
	{Name = "England Exped. corp Egypt", X = 36, Y = 44, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_CRUISER_I, UK_VICKERS_MK6B}, UnitsXP = {9,9,9},  },
	{Name = "England Metropole RAF", X = 11, Y = 71, Domain = "Air", CivID = ENGLAND, Group = {UK_WELLINGTON, UK_WELLINGTON}, UnitsXP = {9,9},  },
	{Name = "England Nicosia RAF", X = 36, Y = 51, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE}, UnitsXP = {9},  },
	{Name = "England Egypt RAF", X = 38, Y = 46, Domain = "Air", CivID = ENGLAND, Group = {UK_SPITFIRE}, UnitsXP = {9},  },
	{Name = "England Home fleet", X = 2, Y = 70, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_BATTLESHIP, UK_ELIZABETH}, UnitsXP = {9,9,9},  },
	{Name = "England Home fleet North", X = 12, Y = 79, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_LEANDER}, UnitsXP = {9,9},  },
	{Name = "England West Mediterranean fleet", X = 9, Y = 50, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9},  },
	{Name = "England East Mediterranean fleet", X = 37, Y = 48, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_SUBMARINE, UK_ELIZABETH}, UnitsXP = {9,9,9},  },
	{Name = "England Home fleet AI Bonus", X = 7, Y = 76, Domain = "Sea", AI = true, CivID = ENGLAND, Group = {UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER}, UnitsXP = {9,9,9,9},  },
	{Name = "England Exped. corp India", X = 60, Y = 51, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY, UK_INFANTRY}, UnitsXP = {9,9},  },
	{Name = "England Exped. corp Malaysia", X = 78, Y = 32, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY}, UnitsXP = {9},  },
	{Name = "England Exped. corp China", X = 83, Y = 45, Domain = "Land", CivID = ENGLAND, Group = {UK_INFANTRY}, UnitsXP = {9},  },
	{Name = "England Pacific fleet", X = 80, Y = 34, Domain = "Sea", CivID = ENGLAND, Group = {UK_TRIBA, UK_LEANDER}, UnitsXP = {9,9},  },
-- USSR
	{Name = "USSR central army", X = 37, Y = 69, Domain = "Land", CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_INFANTRY, RU_BT2, RU_T26, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  }, 
	{Name = "USSR moscow army", X = 40, Y = 72, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_INFANTRY, RU_BT2, RU_BT2, AT_GUN, RU_T28, RU_ARTILLERY}, UnitsXP = {9,9,9,9,9,9,9},  },
	{Name = "USSR north army", X = 38, Y = 90, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },
	{Name = "USSR south army", X = 35, Y = 64, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },	
	{Name = "USSR east army", X = 93, Y = 73, Domain = "Land", AI = true, CivID = USSR, Group = {RU_INFANTRY, RU_NAVAL_INFANTRY, RU_BT2, AT_GUN, RU_T28}, UnitsXP = {9,9,9,9,9},  },		
	{Name = "USSR central aviation", X = 36, Y = 69, Domain = "Air", CivID = USSR, Group = {RU_I16, RU_I16}, UnitsXP = {9,9},  },
	{Name = "USSR central aviation AI Bonus", X = 36, Y = 69, Domain = "Air", AI = true,CivID = USSR, Group = {RU_I16, RU_I16, RU_TB3, RU_TB3}, UnitsXP = {9,9,9,9},  },
	{Name = "USSR Pacific fleet", X = 105, Y = 76, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_GANGUT, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR North fleet", X = 40, Y = 91, Domain = "Sea", CivID = USSR, Group = {RU_GANGUT, RU_SUBMARINE, RU_GNEVNY}, UnitsXP = {9,9,9},  },
	{Name = "USSR Central fleet", X = 28, Y = 77, Domain = "Sea", AI = true, CivID = USSR, Group = {RU_GANGUT,RU_GNEVNY}, UnitsXP = {9,9},  },
	{Name = "USSR fortification", X = 33, Y = 77, Domain = "Land", AI = true, CivID = USSR, Group = {FORTIFIED_GUN}, UnitsName = {"Krepost Oreshek"}, },

-- Germany
	{Name = "German central I army", X = 21, Y = 69, Domain = "Land", CivID = GERMANY, Group = {GE_INFANTRY, GE_PANZER_I, GE_PANZER_35, GE_PANZER_II, AT_GUN}, UnitsXP = {60,60,60,60,60},  },
	{Name = "German central II army", X = 23, Y = 67, Domain = "Land", CivID = GERMANY, Group = {GE_INFANTRY, GE_PANZER_I, GE_PANZER_35, GE_PANZER_II, AT_GUN}, UnitsXP = {60,60,60,60,60},  },
	{Name = "German north army", X = 19, Y = 71, Domain = "Land", CivID = GERMANY, Group = {GE_MARDER_I, GE_PANZER_38, GE_PANZER_35, GE_PANZER_II, AT_GUN}, UnitsXP = {60,60,60,60,60},  },
	{Name = "German Berlin army", X = 23, Y = 70, Domain = "City", AI = true, CivID = GERMANY, Group = {GE_INFANTRY, GE_PANZER_35, GE_PANZER_II, GE_PANZER_I, AT_GUN}, UnitsXP = {60,60,60,60,60},  },
	{Name = "German Luftwaffe", X = 23, Y = 70, Domain = "Air", CivID = GERMANY, Group = {GE_BF109, GE_BF109, GE_HE111, GE_HE111, GE_JU87, GE_JU87, GE_JU87}, UnitsXP = {60,60,60,60,60,60,60},  }, 
	{Name = "German Luftwaffe AI Bonus", X = 20, Y = 67, Domain = "Air", AI = true, CivID = GERMANY, Group = {GE_BF109, GE_HE111, GE_JU87}, UnitsXP = {60,60,60}, },
	{Name = "German Fleet", X = 26, Y = 74, Domain = "Sea", CivID = GERMANY, Group = {GE_BATTLESHIP, GE_DESTROYER}, UnitsXP = {60,60},  },
	{Name = "German Submarine Fleet", X = 18, Y = 74, Domain = "Sea", CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE, GE_DESTROYER}, UnitsXP = {60,60,60,60},  },
	{Name = "German Submarine AI Bonus", X = 1, Y = 62, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_SUBMARINE, GE_SUBMARINE, GE_SUBMARINE}, UnitsXP = {60,60,60}, },
	{Name = "German Fleet AI bonus", X = 17, Y = 77, Domain = "Sea", AI = true, CivID = GERMANY, Group = { GE_LEIPZIG, GE_DESTROYER, GE_DESTROYER }, UnitsXP = {60,60,60},  },

-- Italy
	{Name = "Italian army", X = 19, Y = 60, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, IT_INFANTRY, AT_GUN, ARTILLERY}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian colonial army I", X = 28, Y = 46, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, AT_GUN, ARTILLERY}, UnitsXP = {9,9,9,9},  },
	{Name = "Italian colonial army II", X = 38, Y = 31, Domain = "Land", CivID = ITALY, Group = {IT_INFANTRY, IT_INFANTRY, AT_GUN, ARTILLERY}, UnitsXP = {9,9,9,9},  },
	{Name = "Italian air", X = 19, Y = 57, Domain = "Air", CivID = ITALY, Group = {IT_CR42, IT_CR42, IT_CR42}, UnitsXP = {9,9,9},  },
	{Name = "Italian air AI Bonus", X = 19, Y = 57, Domain = "Air", AI = true, CivID = ITALY, Group = {IT_CR42, IT_SM79, IT_SM79}, UnitsXP = {9,9,9},  },
	{Name = "Italian fleet", X = 19, Y = 53, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_ZARA, IT_DI_CAVOUR, IT_SUBMARINE, IT_BATTLESHIP}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet 2", X = 23, Y = 50, Domain = "Sea", CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_DI_CAVOUR, IT_ZARA, IT_BATTLESHIP, IT_SUBMARINE}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Italian fleet AI Bonus", X = 43, Y = 27, Domain = "Sea", AI = true, CivID = ITALY, Group = {IT_SOLDATI, IT_SOLDATI, IT_SUBMARINE}, UnitsXP = {9,9,9},  },

-- America
	{Name = "US north army", X = 153, Y = 61, Domain = "Land", CivID = AMERICA, Group = {US_INFANTRY, US_INFANTRY, US_INFANTRY}, UnitsXP = {9,9,9},  },
	{Name = "US south army", X = 144, Y = 58, Domain = "Land", CivID = AMERICA, Group = {US_INFANTRY, US_INFANTRY, US_INFANTRY}, UnitsXP = {9,9,9},  },
	{Name = "US Manila army", X = 89, Y = 38, Domain = "Land", CivID = AMERICA, Group = {US_MARINES}, UnitsXP = {9},  },
	{Name = "US Honolulu army", X = 119, Y = 54, Domain = "Land", CivID = AMERICA, Group = {US_MARINES}, UnitsXP = {9},  },
	{Name = "US air force", X = 157, Y = 65, Domain = "Air", CivID = AMERICA, Group = {US_P36, US_P36}, UnitsXP = {9,9},  },
	{Name = "US north fleet", X = 158, Y = 63, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_BALTIMORE, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9,9},  },
	{Name = "US south fleet", X = 154, Y = 53, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_BALTIMORE, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9,9},  },
	{Name = "US Pacific fleet I", X = 117, Y = 53, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_PENNSYLVANIA, US_PENNSYLVANIA}, UnitsXP = {9,9,9},  },
	{Name = "US Pacific fleet II", X = 90, Y = 39, Domain = "Sea", CivID = AMERICA, Group = {US_BENSON, US_BENSON, US_SUBMARINE, US_SUBMARINE}, UnitsXP = {9,9,9,9},  },
	{Name = "Fortress Corregidor", X = 85, Y = 37, Domain = "Land", CivID = AMERICA, Group = {FORTIFIED_GUN}, UnitsName = {"Fortress Corregidor"},  },

-- Japan
	{Name = "Japanese Manchurian Army I", X = 80, Y = 61, Domain = "Land", CivID = JAPAN, Group = {JP_TYPE95, JP_TYPE97_SHINHOTO, JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "China Army I", X = 84, Y = 56, Domain = "Land", CivID = JAPAN, Group = {JP_TYPE95, JP_TYPE97_SHINHOTO, JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "China Army II", X = 84, Y = 52, Domain = "Land", CivID = JAPAN, Group = {JP_TYPE95, JP_TYPE97_SHINHOTO, JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "China Army III", X = 82, Y = 46, Domain = "Land", CivID = JAPAN, Group = {JP_TYPE95, JP_TYPE97_SHINHOTO, JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Japanese Manchurian Air", X = 89, Y = 61, Domain = "Air", CivID = JAPAN, Group = {JP_A5M, JP_A5M, JP_KI27, JP_KI27}, UnitsXP = {9,9,9,9},  },
	{Name = "Japanese Korea Air", X = 86, Y = 67, Domain = "Air", CivID = JAPAN, Group = {JP_KI21, JP_AICHI, JP_KI21}, UnitsXP = {9,9,9},  },
	{Name = "Japanese Western fleet", X = 94, Y = 62, Domain = "Sea", CivID = JAPAN, Group = {JP_SUBMARINE, JP_KAGERO, JP_TAKAO, JP_BATTLESHIP, JP_KAGERO, JP_TAKAO,}, UnitsXP = {9,9,9,9,9,9},  },
	{Name = "Japanese Eastern Fleet", X = 97, Y = 54, Domain = "Sea", CivID = JAPAN, Group = {JP_SUBMARINE, JP_TAKAO, JP_BATTLESHIP, JP_KAGERO, JP_KAGERO, JP_TAKAO}, UnitsXP = {9,9,9,9,9,9},  },

-- China
	{Name = "Chinese north army", X = 78, Y = 59, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },
	{Name = "Chinese south army", X = 81, Y = 54, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },
	{Name = "Chinese east army", X = 84, Y = 49, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },
	{Name = "Chinese west army", X = 79, Y = 50, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },
	{Name = "Chinese more army", X = 76, Y = 49, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },
	{Name = "Chinese even more army", X = 75, Y = 53, Domain = "Land", CivID = CHINA, Group = {CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_INFANTRY, CH_T26B}, UnitsXP = {7,7,7,7,7,7,7},  },

	{Name = "Chinese fleet I", X = 88, Y = 58, Domain = "Sea", CivID = CHINA, Group = {DESTROYER, DESTROYER}, UnitsXP = {7,7},  },
	{Name = "Chinese fleet II", X = 80, Y = 43, Domain = "Sea", CivID = CHINA, Group = {DESTROYER, DESTROYER}, UnitsXP = {7,7},  },
	{Name = "Chinese fleet III", X = 84, Y = 40, Domain = "Sea", CivID = CHINA, Group = {DESTROYER, DESTROYER}, UnitsXP = {7,7},  },

-- Republican Spain Navy and Air Force
	{Name = "Republican Spain air", X = 8, Y = 55, Domain = "Air", CivID = RSPAIN, IsMinor = true, Group = {RU_I16} },
	{Name = "RepublicSpain army I",		X = 9, Y = 53, Domain = "Land", CivID = RSPAIN, IsMinor = true, Group = {SP_INFANTRY, SP_INFANTRY, SP_INFANTRY, SP_INFANTRY} },
	{Name = "RepublicSpain army II",	X = 8, Y = 60, Domain = "City", CivID = RSPAIN, IsMinor = true, Group = {SP_INFANTRY, ARTILLERY} },

-- Nationalist Spain Navy and Air Force
	{Name = "Nation.Spain army I",		X = 9, Y = 57, Domain = "Land", CivID = NSPAIN, IsMinor = true, Group = {SP_INFANTRY, SP_INFANTRY, SP_INFANTRY, ARTILLERY, ARTILLERY} },
	{Name = "Nation.Spain army II",		X = 6, Y = 53, Domain = "City", CivID = NSPAIN, IsMinor = true, Group = {SP_INFANTRY, ARTILLERY} },
	{Name = "Nation.Spain army III",	X = 6, Y = 59, Domain = "City", CivID = NSPAIN, IsMinor = true, Group = {SP_INFANTRY, SP_INFANTRY, ARTILLERY} },
	{Name = "Nation.Spain air",			X = 9, Y = 57, Domain = "Air", CivID = NSPAIN, IsMinor = true, Group = {GE_JU87, GE_BF109} },
	{Name = "Nation.Spain fleet",		X = 4, Y = 60, Domain = "Sea", CivID = NSPAIN, IsMinor = true, Group = {DESTROYER, DESTROYER} },

	{Name = "Rebels North West",		X = 82, Y = 51,		Domain = "Land",	CivID = COMCHINA,	IsMinor = true, Group = {CC_INFANTRY, CC_INFANTRY, CC_INFANTRY, CC_INFANTRY, CC_INFANTRY} },
	{Name = "Rebels South East",		X = 75, Y = 60,		Domain = "Land",	CivID = COMCHINA,	IsMinor = true, Group = {CC_INFANTRY, CC_INFANTRY, CC_INFANTRY, CC_INFANTRY, CC_INFANTRY} },
}

-- Options
if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 1", X = 18, Y = 64, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"SF de Mulhouse"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 2", X = 18, Y = 66, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Hochwald"}, })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 3", X = 17, Y = 66, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage du Simserhof"},  })
	table.insert (g_Initial_OOB,	{Name = "Maginot Line 5", X = 16, Y = 67, Domain = "Land", CivID = FRANCE, Group = {FORTIFIED_GUN}, UnitsName = {"Ouvrage de Fermont"}, })
end

if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
	table.insert (g_Initial_OOB,	{Name = "Westwall 1", X = 20, Y = 64, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Isteiner Klotz"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 2", X = 19, Y = 66, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Ettlinger Riegel"}, })																																 
	table.insert (g_Initial_OOB,	{Name = "Westwall 3", X = 18, Y = 68, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Spichernstellung"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 4", X = 18, Y = 70, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Orscholzriegel"}, })
	table.insert (g_Initial_OOB,	{Name = "Westwall 5", X = 18, Y = 72, Domain = "Land", CivID = GERMANY, Group = {FORTIFIED_GUN}, UnitsName = {"Geldernstellung"}, })
end


g_MinorMobilization_OOB = { 

	{Name = "Finland army",				X = 31, Y = 82,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, FI_BT42, ARTILLERY} },
	{Name = "Finland fortification",	X = 33, Y = 78,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },
	{Name = "Finland fortification",	X = 35, Y = 78,		Domain = "Land",	CivID = FINLAND,	IsMinor = true, Group = {FORTIFIED_GUN}, UnitsName = {"Mannerheim-linja"}, },	
	{Name = "Poland army",				X = 29, Y = 68,		Domain = "Land",	CivID = POLAND,		IsMinor = true, Group = {PL_INFANTRY, PL_VICKERS_MKE_A, PL_INFANTRY, PL_10TP, PL_7TP} },
	{Name = "Poland air force",			X = 27, Y = 69,		Domain = "Air",		CivID = POLAND,		IsMinor = true, Group = {PL_PZL37, PL_P11, } },
	{Name = "Poland fleet",				X = 28, Y = 76,		Domain = "Sea",		CivID = POLAND,		IsMinor = true, Group = {PL_SUBMARINE} },
	{Name = "Belgian army",				X = 15, Y = 69,		Domain = "City",	CivID = BELGIUM,	IsMinor = true, Group = {INFANTRY, DU_VICKERS_M1936} },
	{Name = "Netherlands army",			X = 16, Y = 71,		Domain = "City",	CivID = NETHERLANDS,	IsMinor = true, Group = {DU_INFANTRY, DU_VICKERS_M1936, DU_MTSL} },
	{Name = "Netherlands AF",			X = 16, Y = 71,		Domain = "Air",		CivID = NETHERLANDS,	IsMinor = true, Group = {DU_FOKKER_DXXI, DU_FOKKER_GI, DU_FOKKER_TV} },
	{Name = "Romania army",				X = 31, Y = 63,		Domain = "Land",	CivID = ROMANIA,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, INFANTRY, RO_TACAM, ARTILLERY} },
	{Name = "Yugoslavia army",			X = 25, Y = 59,		Domain = "Land",	CivID = YUGOSLAVIA,	IsMinor = true, Group = {INFANTRY, INFANTRY, YU_SKODA, YU_SKODA, AT_GUN} },
	{Name = "Bulgaria army",			X = 28, Y = 59,		Domain = "City",	CivID = BULGARIA,	IsMinor = true, Group = {HU_INFANTRY, HU_INFANTRY, ARTILLERY} },
	{Name = "Hungary army",				X = 26, Y = 62,		Domain = "City",	CivID = HUNGARY,	IsMinor = true, Group = {HU_INFANTRY, HU_INFANTRY, HU_38M_TOLDI, HU_40M_TURAN} },
	{Name = "Hungary air force",		X = 26, Y = 62,		Domain = "Air",		CivID = HUNGARY,	IsMinor = true, Group = {HU_RE2000, HU_CA135} },
	{Name = "Sweden army",				X = 24, Y = 81,		Domain = "Land",	CivID = SWEDEN,		IsMinor = true, Group = {SW_INFANTRY, AT_GUN, SW_INFANTRY, AT_GUN, SW_INFANTRY, SW_INFANTRY, ARTILLERY} },
	{Name = "Greece army",				X = 29, Y = 54,		Domain = "City",	CivID = GREECE,		IsMinor = true, Group = {GR_INFANTRY, GR_INFANTRY, GR_VICKERS_MKE} },
	{Name = "Greece air force",			X = 29, Y = 54,		Domain = "Air",		CivID = GREECE,		IsMinor = true, Group = {GR_P24, GR_P24 } },
	{Name = "Greece fleet",				X = 30, Y = 55,		Domain = "Sea",		CivID = GREECE,		IsMinor = true, Group = {GR_GEORGIOS, GR_GEORGIOS, GR_SUBMARINE} },


	{Name = "Generic army",			X = 18, Y = 63,		Domain = "City",	CivID = SWITZERLAND,IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 3,  Y = 55,		Domain = "City",	CivID = PORTUGAL,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 46, Y = 43,		Domain = "City",	CivID = ARABIA,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 37, Y = 56,		Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 32, Y = 57,		Domain = "City",	CivID = TURKEY,		IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 19, Y = 75,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 24, Y = 74,		Domain = "City",	CivID = DENMARK,	IsMinor = true, Group = {INFANTRY, AA_GUN} },
	{Name = "Generic army",			X = 5,  Y = 73,		Domain = "City",	CivID = IRELAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 22, Y = 80,		Domain = "City",	CivID = NORWAY,		IsMinor = true, Group = {INFANTRY, AT_GUN} },
	{Name = "Generic army",			X = 31, Y = 8,		Domain = "City",	CivID = SOUTHAFRICA,IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, AA_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 104, Y = 12,	Domain = "City",	CivID = AUSTRALIA,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic fleet",		X = 105, Y = 10,	Domain = "Sea",		CivID = AUSTRALIA,	IsMinor = true, Group = {DESTROYER, DESTROYER, DESTROYER} },
	{Name = "Generic army",			X = 112, Y = 9,		Domain = "City",	CivID = NEWZEALAND,	IsMinor = true, Group = {INFANTRY, AT_GUN, INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 75, Y = 40,		Domain = "City",	CivID = THAILAND,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 75, Y = 69,		Domain = "City",	CivID = MONGOLIA,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 132, Y = 70,	Domain = "City",	CivID = CANADA,		IsMinor = true, Group = {CA_INFANTRY, CA_INFANTRY, CA_INFANTRY} },
	{Name = "Generic army",			X = 158, Y = 69,	Domain = "City",	CivID = CANADA,		IsMinor = true, Group = {CA_INFANTRY, AT_GUN, CA_INFANTRY, AA_GUN, CA_INFANTRY, ARTILLERY} },
	{Name = "Generic army",			X = 142, Y = 48,	Domain = "City",	CivID = MEXICO,		IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 147, Y = 42,	Domain = "City",	CivID = CENTRAL,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 153, Y = 37,	Domain = "City",	CivID = COLOMBIA,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 157, Y = 41,	Domain = "City",	CivID = VENEZUELA,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 149, Y = 33,	Domain = "City",	CivID = ECUADOR,	IsMinor = true, Group = {INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 167, Y = 22,	Domain = "City",	CivID = BRAZIL,		IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 161, Y = 17,	Domain = "City",	CivID = URAGUAY,	IsMinor = true, Group = {INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 160, Y = 15,	Domain = "City",	CivID = ARGENTINA,	IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 154, Y = 14,	Domain = "City",	CivID = CHILE,		IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
	{Name = "Generic army",			X = 151, Y = 26,	Domain = "City",	CivID = PERU,		IsMinor = true, Group = {INFANTRY, INFANTRY, INFANTRY} },
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
	[RSPAIN] = {
				[CLASS_INFANTRY] = SP_INFANTRY,
	},
	[NSPAIN] = {
				[CLASS_INFANTRY] = SP_INFANTRY,
	},
	[CANADA] = {
				[CLASS_INFANTRY] = CA_INFANTRY,
	},
	[COMCHINA] = {
				[CLASS_INFANTRY] = CC_INFANTRY,
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
	[FRANCE]  = {},
	[GERMANY] = {PROJECT_PANZER_III},
	[ENGLAND] = {PROJECT_MATILDAI },
	[AMERICA] = {},
	[JAPAN]   = {OPERATION_CHINA},
}

----------------------------------------------------------------------------------------------------------------------------
-- Diplomacy
----------------------------------------------------------------------------------------------------------------------------

-- Victory types
g_Victory = {
	[GERMANY] = "VICTORY_AXIS_EARTH",
	[JAPAN] = "VICTORY_AXIS_EARTH",
	[ITALY] = "VICTORY_AXIS_EARTH",
	[USSR] = "VICTORY_ALLIED_EARTH",
	[FRANCE] = "VICTORY_ALLIED_EARTH",
	[ENGLAND] = "VICTORY_ALLIED_EARTH",
	[CHINA] = "VICTORY_ALLIED_EARTH",
	[AMERICA] = "VICTORY_ALLIED_EARTH",
}

g_MinorProtector = {
	[THAILAND] = {JAPAN, }, 
	[MONGOLIA] = {USSR, },
	[AUSTRALIA] = {ENGLAND, },  
	[BELGIUM] = {FRANCE, ENGLAND}, 
	[NETHERLANDS] = {FRANCE, ENGLAND}, 
	[CANADA] = {ENGLAND, }, 
	[IRELAND] = {ENGLAND, }, 
	[NEWZEALAND] = {ENGLAND, },
	[PORTUGAL] = {ENGLAND, },
	[SOUTHAFRICA] = {ENGLAND, },
	[BRAZIL] = {AMERICA, },
	[COLOMBIA] = {AMERICA, },
	[VENEZUELA] = {AMERICA, },
	[PERU] = {AMERICA, },
	[CHILE] = {AMERICA, },
	[ARGENTINA] = {AMERICA, },
	[URAGUAY] = {AMERICA, },
	[ROMANIA] = {GERMANY, ITALY},
	[CENTRAL] = {AMERICA, },
	[MEXICO] = {AMERICA, },
	[BULGARIA] = {GERMANY, },  
	[HUNGARY] = {GERMANY, }, 
	[SWEDEN] = {FRANCE, ENGLAND, GERMANY, }, 
}

-- Major Civilizations
-- to do in all table : add entry bCheck = function() return true or false, apply change only if true or nill
g_Major_Diplomacy = {
	[19380910] = { 
		{Type = DOW, Civ1 = JAPAN, Civ2 = CHINA},
	},
	[19380901] = { 
		{Type = DOF, Civ1 = GERMANY, Civ2 = ITALY},
	},
	[19380901] = { 
		{Type = DEN, Civ1 = FRANCE, Civ2 = GERMANY},
		{Type = DEN, Civ1 = ENGLAND, Civ2 = GERMANY},
	},
	[19390903] = { 
		{Type = DOW, Civ1 = FRANCE, Civ2 = GERMANY},
		{Type = DOW, Civ1 = ENGLAND, Civ2 = GERMANY},
		{Type = PEA, Civ1 = FRANCE, Civ2 = ENGLAND},
		{Type = DOF, Civ1 = GERMANY, Civ2 = USSR},
		{Type = DOF, Civ1 = GERMANY, Civ2 = ITALY},
	},
	[19400201] = { 
		{Type = DOF, Civ1 = GERMANY, Civ2 = USSR},
	},
	[19400610] = { 
		{Type = DOW, Civ1 = ITALY, Civ2 = FRANCE},
		{Type = DOW, Civ1 = ITALY, Civ2 = ENGLAND},
		{Type = PEA, Civ1 = GERMANY, Civ2 = ITALY},
	},
	[19400927] = { 
		{Type = DOF, Civ1 = GERMANY, Civ2 = JAPAN},
	},
	[19410622] = { 
		{Type = DOW, Civ1 = GERMANY, Civ2 = USSR},
		{Type = DOW, Civ1 = ITALY, Civ2 = USSR},
		{Type = DOF, Civ1 = FRANCE, Civ2 = USSR},
		{Type = DOF, Civ1 = ENGLAND, Civ2 = USSR},
	},
	[19411207] = { 
		{Type = DOW, Civ1 = GERMANY, Civ2 = AMERICA},
		{Type = DOW, Civ1 = GERMANY, Civ2 = CHINA},
		{Type = DOW, Civ1 = ITALY, Civ2 = AMERICA},
		{Type = DOW, Civ1 = ITALY, Civ2 = CHINA},
		{Type = DOW, Civ1 = JAPAN, Civ2 = AMERICA},
		{Type = DOW, Civ1 = JAPAN, Civ2 = FRANCE},
		{Type = DOW, Civ1 = JAPAN, Civ2 = ENGLAND},
		{Type = PEA, Civ1 = FRANCE, Civ2 = AMERICA},
		{Type = PEA, Civ1 = ENGLAND, Civ2 = AMERICA},
		{Type = DOF, Civ1 = USSR, Civ2 = AMERICA},
		{Type = PEA, Civ1 = CHINA, Civ2 = AMERICA},
		{Type = PEA, Civ1 = CHINA, Civ2 = FRANCE},
		{Type = PEA, Civ1 = CHINA, Civ2 = ENGLAND},
	},
	[19450809] = { 
		{Type = DOW, Civ1 = USSR, Civ2 = JAPAN},
		{Type = PEA, Civ1 = FRANCE, Civ2 = USSR},
		{Type = PEA, Civ1 = ENGLAND, Civ2 = USSR},
		{Type = PEA, Civ1 = CHINA, Civ2 = USSR},
		{Type = PEA, Civ1 = AMERICA, Civ2 = USSR},
	},				
}

-- Minor Civilizations
g_Minor_Relation = {
	[19380910] = { 
		{Value = -120, Major = CHINA, Minor = COMCHINA},
		{Value = 50, Major = USSR, Minor = RSPAIN},
		{Value = -50, Major = USSR, Minor = FINLAND},
		{Value = -50, Major = FRANCE, Minor = THAILAND},
		{Value = 50, Major = GERMANY, Minor = NSPAIN},
		{Value = 50, Major = ITALY, Minor = NSPAIN},
		{Value = 120, Major = ENGLAND, Minor = CANADA},
		{Value = 50, Major = FRANCE, Minor = CANADA},
		{Value = 120, Major = ENGLAND, Minor = AUSTRALIA},
		{Value = 50, Major = FRANCE, Minor = AUSTRALIA},
		{Value = 120, Major = ENGLAND, Minor = NEWZEALAND},
		{Value = 50, Major = FRANCE, Minor = NEWZEALAND},
		{Value = 120, Major = ENGLAND, Minor = SOUTHAFRICA},
		{Value = 50, Major = FRANCE, Minor = SOUTHAFRICA},
		{Value = 50, Major = GERMANY, Minor = HUNGARY},
		{Value = 50, Major = GERMANY, Minor = BULGARIA},
		{Value = 50, Major = GERMANY, Minor = ROMANIA},
		{Value = 50, Major = GERMANY, Minor = AUSTRIA},
		{Value = 50, Major = GERMANY, Minor = SWEDEN},
		{Value = 50, Major = ENGLAND, Minor = SWEDEN},
		{Value = 50, Major = FRANCE, Minor = SWEDEN},
		{Value = 50, Major = ITALY, Minor = HUNGARY},
		{Value = 50, Major = ITALY, Minor = BULGARIA},
		{Value = 50, Major = ITALY, Minor = ROMANIA},
		{Value = 50, Major = ITALY, Minor = AUSTRIA},
	},
	[19380910] = { 
		{Value = -50, Major = GERMANY, Minor = AUSTRIA},
		{Value = -50, Major = ITALY, Minor = AUSTRIA},
	},
	[19380910] = { 
		{Value = 120, Major = ENGLAND, Minor = POLAND},
		{Value = 120, Major = FRANCE, Minor = POLAND},
		{Value = 50, Major = ENGLAND, Minor = BELGIUM},
		{Value = 50, Major = FRANCE, Minor = BELGIUM},
		{Value = 50, Major = ENGLAND, Minor = NETHERLANDS},
		{Value = 50, Major = FRANCE, Minor = NETHERLANDS},
		{Value = 50, Major = ENGLAND, Minor = NORWAY},
		{Value = 50, Major = FRANCE, Minor = NORWAY},
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
		{Value = -50, Major = ITALY, Minor = GREECE},
		{Value = -50, Major = ITALY, Minor = YUGOSLAVIA},
	},
	[19410406] = { 
		{Value = 120, Major = ENGLAND, Minor = YUGOSLAVIA},
		{Value = 100, Major = FRANCE, Minor = YUGOSLAVIA},
		{Value = 120, Major = ENGLAND, Minor = GREECE},
		{Value = 100, Major = FRANCE, Minor = GREECE},
	},
	[19410622] = { 
		{Value = 120, Major = GERMANY, Minor = ROMANIA},
		{Value = 120, Major = GERMANY, Minor = FINLAND},
		{Value = 100, Major = ITALY, Minor = ROMANIA},
		{Value = 100, Major = ITALY, Minor = HUNGARY},
		{Value = 100, Major = ITALY, Minor = BULGARIA},
		{Value = 100, Major = ITALY, Minor = FINLAND},
		{Value = 120, Major = GERMANY, Minor = BULGARIA},
	},
	[19411207] = { 
		{Value = 120, Major = AMERICA, Minor = POLAND},
		{Value = 120, Major = AMERICA, Minor = NETHERLANDS},
		{Value = 120, Major = AMERICA, Minor = BELGIUM},
		{Value = 120, Major = AMERICA, Minor = DENMARK},
		{Value = 120, Major = AMERICA, Minor = NORWAY},
		{Value = 120, Major = AMERICA, Minor = YUGOSLAVIA},
		{Value = 120, Major = AMERICA, Minor = CANADA},
		{Value = 120, Major = AMERICA, Minor = AUSTRALIA},
		{Value = 120, Major = AMERICA, Minor = NEWZEALAND},
		{Value = 120, Major = AMERICA, Minor = SOUTHAFRICA},
		{Value = 120, Major = AMERICA, Minor = CENTRAL},
		{Value = 120, Major = ENGLAND, Minor = CENTRAL},
		{Value = 120, Major = FRANCE, Minor = CENTRAL},
		{Value = 120, Major = CHINA, Minor = CENTRAL},
	},
	[19420125] = { 
		{Value = 120, Major = JAPAN, Minor = THAILAND},
	},
	[19420822] = { 
		{Value = 120, Major = AMERICA, Minor = BRAZIL},
		{Value = 120, Major = ENGLAND, Minor = BRAZIL},
		{Value = 120, Major = FRANCE, Minor = BRAZIL},
		{Value = 120, Major = CHINA, Minor = BRAZIL},
		{Value = 120, Major = AMERICA, Minor = MEXICO},
		{Value = 120, Major = ENGLAND, Minor = MEXICO},
		{Value = 120, Major = FRANCE, Minor = MEXICO},
		{Value = 120, Major = CHINA, Minor = MEXICO},

	},
	[19430726] = { 
		{Value = 120, Major = AMERICA, Minor = COLOMBIA},
		{Value = 120, Major = ENGLAND, Minor = COLOMBIA},
		{Value = 120, Major = FRANCE, Minor = COLOMBIA},
		{Value = 120, Major = CHINA, Minor = COLOMBIA},

	},
	[19440202] = { 
		{Value = 120, Major = AMERICA, Minor = PERU},
		{Value = 120, Major = ENGLAND, Minor = PERU},
		{Value = 120, Major = FRANCE, Minor = PERU},
		{Value = 120, Major = CHINA, Minor = PERU},

	},
	[19440915] = { 
		{Value = 120, Major = AMERICA, Minor = FINLAND},
		{Value = 120, Major = ENGLAND, Minor = FINLAND},
		{Value = 120, Major = FRANCE, Minor = FINLAND},
		{Value = 120, Major = CHINA, Minor = FINLAND},
		{Value = -120, Major = GERMANY, Minor = FINLAND},
		{Value = -120, Major = ITALY, Minor = FINLAND},
	},
	[19450202] = { 
		{Value = 120, Major = AMERICA, Minor = ECUADOR},
		{Value = 120, Major = ENGLAND, Minor = ECUADOR},
		{Value = 120, Major = FRANCE, Minor = ECUADOR},
		{Value = 120, Major = CHINA, Minor = ECUADOR},
	},
	[19450215] = { 
		{Value = 120, Major = AMERICA, Minor = URAGUAY},
		{Value = 120, Major = ENGLAND, Minor = URAGUAY},
		{Value = 120, Major = FRANCE, Minor = URAGUAY},
		{Value = 120, Major = CHINA, Minor = URAGUAY},
		{Value = 120, Major = AMERICA, Minor = VENEZUELA},
		{Value = 120, Major = ENGLAND, Minor = VENEZUELA},
		{Value = 120, Major = FRANCE, Minor = VENEZUELA},
		{Value = 120, Major = CHINA, Minor = VENEZUELA},
	},
	[19450223] = { 
		{Value = 120, Major = AMERICA, Minor = TURKEY},
		{Value = 120, Major = ENGLAND, Minor = TURKEY},
		{Value = 120, Major = FRANCE, Minor = TURKEY},
		{Value = 120, Major = CHINA, Minor = TURKEY},
	},
	[19450301] = { 
		{Value = 120, Major = AMERICA, Minor = ARABIA},
		{Value = 120, Major = ENGLAND, Minor = ARABIA},
		{Value = 120, Major = FRANCE, Minor = ARABIA},
		{Value = 120, Major = CHINA, Minor = ARABIA},
	},
	[19450327] = { 
		{Value = 120, Major = AMERICA, Minor = ARGENTINA},
		{Value = 120, Major = ENGLAND, Minor = ARGENTINA},
		{Value = 120, Major = FRANCE, Minor = ARGENTINA},
		{Value = 120, Major = CHINA, Minor = ARGENTINA},
	},
	[19450411] = { 
		{Value = 120, Major = AMERICA, Minor = CHILE},
		{Value = 120, Major = ENGLAND, Minor = CHILE},
		{Value = 120, Major = FRANCE, Minor = CHILE},
		{Value = 120, Major = CHINA, Minor = CHILE},
	},									
}
g_Major_Minor_DoW = {
	[19380910] = {
	 	{Major = CHINA, Minor = COMCHINA},
	},
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
	[19401028] = {	
		{Major = ITALY, Minor = BELGIUM},
		{Major = ITALY, Minor = NETHERLANDS},
	},	
	[19410406] = { 
		{Major = ITALY, Minor = YUGOSLAVIA},
		{Major = GERMANY, Minor = YUGOSLAVIA},
		{Major = ITALY, Minor = GREECE},
		{Major = GERMANY, Minor = GREECE},
	},	
	[19410410]  = { 
		{Major = FRANCE, Minor = HUNGARY},
		{Major = FRANCE, Minor = BULGARIA},
		{Major = ENGLAND, Minor = HUNGARY},
		{Major = ENGLAND, Minor = BULGARIA},
	},
	[19410622] = { 
		{Major = USSR, Minor = HUNGARY},
		{Major = USSR, Minor = BULGARIA},	
	},
	[19421110] = { 
		{Major = ENGLAND, Minor = VICHY},
		{Major = AMERICA, Minor = VICHY},
	},
}
g_Major_Minor_Peace = {
	[19380910] = {
	 	{Major = CHINA, Minor = COMCHINA},
	},
	[19400313] = { 
		{Major = USSR, Minor = FINLAND},	
	},
	[19440915] = { 
		{Major = USSR, Minor = FINLAND},
		{Major = AMERICA, Minor = FINLAND},	
		{Major = ENGLAND, Minor = FINLAND},
		{Major = FRANCE, Minor = FINLAND},
		{Major = CHINA, Minor = FINLAND},
	},
}
g_Minor_Minor_DoW = {
	[19380910] = {
		{Minor1 = RSPAIN, Minor2 = NSPAIN},
	},
	[19410410] = {
		{Minor1 = HUNGARY, Minor2 = YUGOSLAVIA},
	},
	[19410406] = {
		{Minor1 = BULGARIA, Minor2 = GREECE},
		{Minor1 = BULGARIA, Minor2 = YUGOSLAVIA},
	},
}
g_Minor_Major_DoW = {
	[19380910] = {
	 	{Minor = COMCHINA, Major = JAPAN},
	},
	[19390903] = { 
		{Minor = AUSTRALIA, Major = GERMANY},
		{Minor = CANADA, Major = GERMANY},
		{Minor = NEWZEALAND, Major = GERMANY},
		{Minor = SOUTHAFRICA, Major = GERMANY},
	},
	[19400610] = { 
		{Minor = AUSTRALIA, Major = ITALY},
		{Minor = CANADA, Major = ITALY},
		{Minor = NEWZEALAND, Major = ITALY},
		{Minor = SOUTHAFRICA, Major = ITALY},
		{Minor = DENMARK, Major = ITALY},
		{Minor = NORWAY, Major = ITALY},
		{Minor = POLAND, Major = ITALY},
	},
	[19410622] = { 
		{Minor = ROMANIA, Major = USSR},
		{Minor = FINLAND, Major = USSR},
	},
	[19411207] = { 
		{Minor = AUSTRALIA, Major = JAPAN},
		{Minor = CANADA, Major = JAPAN},
		{Minor = NEWZEALAND, Major = JAPAN},
		{Minor = SOUTHAFRICA, Major = JAPAN},
		{Minor = DENMARK, Major = JAPAN},
		{Minor = NORWAY, Major = JAPAN},
		{Minor = POLAND, Major = JAPAN},
		{Minor = BELGIUM, Major = JAPAN},
		{Minor = NETHERLANDS, Major = JAPAN},
		{Minor = CENTRAL, Major = JAPAN},
		{Minor = CENTRAL, Major = GERMANY},
		{Minor = CENTRAL, Major = ITALY},
	},
	[19420822] = { 
		{Minor = BRAZIL, Major = JAPAN},
		{Minor = BRAZIL, Major = GERMANY},
		{Minor = BRAZIL, Major = ITALY},
		{Minor = MEXICO, Major = JAPAN},
		{Minor = MEXICO, Major = GERMANY},
		{Minor = MEXICO, Major = ITALY},
	},
	[19430726] = { 
		{Minor = COLOMBIA, Major = JAPAN},
		{Minor = COLOMBIA, Major = GERMANY},
		{Minor = COLOMBIA, Major = ITALY},
	},
	[19440202] = { 
		{Minor = PERU, Major = JAPAN},
		{Minor = PERU, Major = GERMANY},
		{Minor = PERU, Major = ITALY},
	},
	[19450202] = { 
		{Minor = ECUADOR, Major = JAPAN},
		{Minor = ECUADOR, Major = GERMANY},
		{Minor = ECUADOR, Major = ITALY},
	},
	[19450215] = { 
		{Minor = URAGUAY, Major = JAPAN},
		{Minor = URAGUAY, Major = GERMANY},
		{Minor = URAGUAY, Major = ITALY},
		{Minor = VENEZUELA, Major = JAPAN},
		{Minor = VENEZUELA, Major = GERMANY},
		{Minor = VENEZUELA, Major = ITALY},
	},
	[19450223] = { 
		{Minor = TURKEY, Major = JAPAN},
		{Minor = TURKEY, Major = GERMANY},
		{Minor = TURKEY, Major = ITALY},
	},
	[19450301] = { 
		{Minor = ARABIA, Major = JAPAN},
		{Minor = ARABIA, Major = GERMANY},
		{Minor = ARABIA, Major = ITALY},
	},
	[19450327] = { 
		{Minor = ARGENTINA, Major = JAPAN},
		{Minor = ARGENTINA, Major = GERMANY},
		{Minor = ARGENTINA, Major = ITALY},
	},
	[19450411] = { 
		{Minor = CHILE, Major = JAPAN},
	},
}




----------------------------------------------------------------------------------------------------------------------------
-- Cities
----------------------------------------------------------------------------------------------------------------------------

-- Populate cities with buildings
-- Key cities are cities that need to be occupied to trigger victory
g_Cities = {
	-- UNITED KINGDOM
		{X = 11, Y = 71, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- LONDON
		{X = 10, Y = 77, Key = true, Buildings = { HARBOR, FACTORY}, AIBuildings = {SHIPYARD}, }, -- EDINBURGH
		{X = 9,  Y = 74, Key = true, Buildings = { HARBOR, FACTORY}, AIBuildings = {SMALL_AIR_FACTORY}, }, -- LIVERPOOL
		{X = 10, Y = 72, Key = true, Buildings = { FACTORY}, AIBuildings = {LARGE_AIR_FACTORY}, }, -- BIRMINGHAM
		{X = 8,  Y = 70, Buildings = { HARBOR, ALLIEDCITY }, }, -- PLYMOUTH
		{X = 7, Y = 51, Buildings = { HARBOR, BASE, ALLIEDCITY }, AIBuildings = {ARSENAL, FACTORY}, }, -- GIBRALTAR
		{X = 38, Y = 46, Buildings = { HARBOR, ALLIEDCITY }, AIBuildings = {ARSENAL, FACTORY}, }, -- SUEZ
		{X = 36,  Y = 44, AIBuildings = {FACTORY, ALLIEDCITY},}, -- CAIRO
		{X = 58,  Y = 42, Buildings = { HARBOR, ALLIEDCITY }, }, -- BOMBAY	
		{X = 78,  Y = 32, Buildings = { HARBOR, ALLIEDCITY }, }, -- SINGAPORE	
		{X = 83,  Y = 45, Buildings = { HARBOR, ALLIEDCITY }, }, -- HONG KONG	
		{X = 39,  Y = 48, Buildings = { HARBOR, ALLIEDCITY }, }, -- JERUSALEM	
		{X = 36,  Y = 51, Buildings = { HARBOR, ALLIEDCITY }, }, -- NICOSIA		
		{X = 38, Y = 41, Buildings = { HARBOR, COLONY }, }, -- PORT SUDAN
		{X = 38, Y = 22, Buildings = { HARBOR, COLONY }, }, -- MOMBASA
		{X = 31, Y = 14, Buildings = { COLONY }, }, -- SALISBURY
		{X = 5, Y = 30, Buildings = { HARBOR, COLONY }, }, -- FREETOWN
		{X = 11, Y = 29, Buildings = { HARBOR, COLONY }, }, -- ACCRA
		{X = 16, Y = 30, Buildings = { HARBOR, COLONY }, }, -- LAGOS
		{X = 46, Y = 13, Buildings = { HARBOR, COLONY }, }, -- PORT LOUIS
		{X = 46, Y = 47, Buildings = { HARBOR, COLONY }, }, -- KUWAIT
		{X = 45, Y = 50, Buildings = { COLONY }, }, -- BAGHDAD
		{X = 55, Y = 53, Buildings = { COLONY }, }, -- KABUL
		{X = 60, Y = 51, Buildings = { COLONY }, }, -- DELHI
		{X = 61, Y = 43, Buildings = { COLONY }, }, -- HYDARABAT
		{X = 60, Y = 39, Buildings = { COLONY }, }, -- BANGALORE
		{X = 62, Y = 36, Buildings = { HARBOR, COLONY }, }, -- MADRAS
		{X = 67, Y = 48, Buildings = { HARBOR, COLONY }, }, -- CALCUTTA
		{X = 71, Y = 41, Buildings = { HARBOR, COLONY }, }, -- RANGOON
		{X = 109, Y = 26, Buildings = { HARBOR, COLONY }, }, -- GUADALCANAL
		{X = 115, Y = 20, Buildings = { HARBOR, COLONY }, }, -- FIDJI
		{X = 113, Y = 33, Buildings = { HARBOR, COLONY }, }, -- TARAWA
		{X = 161, Y = 39, Buildings = { HARBOR, COLONY }, }, -- GEORGETOWN
		{X = 152, Y = 45, Buildings = { HARBOR, COLONY }, }, -- KINGSTON
		{X = 155, Y = 49, Buildings = { HARBOR, COLONY }, }, -- NASSAU
		{X = 165, Y = 72, Buildings = { HARBOR, COLONY }, }, -- ST.JOHNS
		{X = 161, Y = 77, Buildings = { HARBOR, COLONY }, }, -- GOOSE BAY

	-- GERMANY
	    {X = 23, Y = 70, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {}, }, -- BERLIN
		{X = 20, Y = 73, Key = true, Buildings = { BANK, BARRACKS, SHIPYARD, BASE, ARSENAL, HARBOR, ACADEMY, FACTORY}, AIBuildings = {}, }, -- HAMBURG
		{X = 21, Y = 64, Key = true, Buildings = { BANK, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {}, }, -- MÜNCHEN
		{X = 20, Y = 67, Key = true, Buildings = { BANK, FACTORY, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {}, }, -- FRANKFURT
		{X = 19, Y = 70, Buildings = { FACTORY, BANK, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {}, }, -- KÖLN
		{X = 24, Y = 64, Buildings = { FACTORY, BANK, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {}, }, -- Wien
		{X = 23, Y = 67, Buildings = { FACTORY, BANK, BARRACKS, BASE, ARSENAL, ACADEMY}, AIBuildings = {}, }, -- Prag

	-- FRANCE
		{X = 13, Y = 65, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, ACADEMY, HOSPITAL, OPEN_CITY, ALLIEDCITY }, AIBuildings = {LAND_FACTORY}, }, -- PARIS	
		{X = 15, Y = 59, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY, SHIPYARD}, }, -- MARSEILLE
		{X = 15, Y = 62, Buildings = { FACTORY, ACADEMY, ARSENAL, ALLIEDCITY}, AIBuildings = {SMALL_AIR_FACTORY, BASE}, }, -- LYON
		{X = 11, Y = 62, Key = true,  AIBuildings = {ARSENAL}, }, -- BORDEAUX
		{X = 10, Y = 67, Key = true,  Buildings = { HARBOR, ALLIEDCITY },  }, -- CAEN
		{X = 15, Y = 67, Key = true,  Buildings = { ALLIEDCITY },  }, -- METZ
		{X = 7, Y = 67, Key = true,  Buildings = { HARBOR, ALLIEDCITY }, }, -- BREST
		{X = 4, Y = 46, Buildings = { HARBOR, ALLIEDCITY }, }, -- CASABLANCA
		{X = 10, Y = 47, Buildings = { HARBOR, ALLIEDCITY }, }, -- ORAN
		{X = 12, Y = 49, Buildings = { HARBOR, BARRACKS, LEGION_HQ, ALLIEDCITY },}, -- ALGIER
		{X = 17, Y = 49, Buildings = { HARBOR, ALLIEDCITY }, }, -- TUNIS
		{X = 41, Y = 50, Buildings = { FACTORY, ALLIEDCITY }, AIBuildings = {ARSENAL}, }, -- DAMASCUS
		{X = 79, Y = 39, Buildings = { HARBOR, ALLIEDCITY },}, -- SAIGON
		{X = 78, Y = 44, Buildings = { HARBOR, COLONY }, }, -- HANOI
		{X = 1, Y = 35, Buildings = { HARBOR, COLONY }, }, -- DAKAR
		{X = 7, Y = 29, Buildings = { HARBOR, COLONY }, }, -- MONROVIA
		{X = 13, Y = 30, Buildings = { HARBOR, COLONY }, }, -- LOME
		{X = 21, Y = 24, Buildings = { HARBOR, COLONY }, }, -- LIBREVILLE
		{X = 41, Y = 15, Buildings = { HARBOR, COLONY }, }, -- ANATANANARIVO
		{X = 41, Y = 35, Buildings = { HARBOR, COLONY }, }, -- DJIBOUTI
		{X = 108, Y = 19, Buildings = { HARBOR, COLONY }, }, -- NOUMEA
		{X = 164, Y = 37, Buildings = { HARBOR, COLONY }, }, -- CAYENNE

	-- ITALY
		{X = 19, Y = 57, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- ROMA
		{X = 21, Y = 54, Key = true, Buildings = { HARBOR }, AIBuildings = { FACTORY, SHIPYARD }, }, -- NAPOLI
		{X = 19, Y = 60, Key = true, Buildings = { FACTORY }, AIBuildings = { SMALL_AIR_FACTORY }, }, -- MILANO
		{X = 21, Y = 61, Key = true, Buildings = { HARBOR },  AIBuildings = { FACTORY }, }, -- VENEZIA
		{X = 17, Y = 54, Buildings = { HARBOR }, }, -- CAGLIARI
		{X = 20, Y = 49, Buildings = { HARBOR }, }, -- CATANIA
		{X = 20, Y = 45, Buildings = { HARBOR },  AIBuildings = { FACTORY }, }, -- TRIPOLI
		{X = 26, Y = 47, Buildings = { HARBOR },  AIBuildings = { FACTORY }, }, -- BENGHAZI
		{X = 38, Y = 31, Buildings = { FACTORY },  AIBuildings = { BARRACKS }, }, -- ADDIS ABBEBA
		{X = 42, Y = 28, Buildings = { HARBOR }, }, -- MOGADISHU
		{X = 29, Y = 47, Buildings = { HARBOR}, }, -- TOBRUK

	-- U.S.S.R.
		{X = 40, Y = 72, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- MOSCOW
		{X = 41, Y = 67, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LARGE_AIR_FACTORY, RADIO}, }, -- STALINGRAD
		{X = 33, Y = 76, Key = true, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD, BASE, RADIO}, }, -- LENINGRAD
		{X = 33, Y = 72, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- MINSK
		{X = 34, Y = 66, Key = true, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- KIEV
		{X = 35, Y = 61, Buildings = { HARBOR}, AIBuildings = {FACTORY, SHIPYARD, RADIO},}, -- SEVASTOPOL
		{X = 39, Y = 89, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- MURMANSK
		{X = 38, Y = 83, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- ARKHANGEL'SK
		{X = 36, Y = 73, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- SMOLENSK
		{X = 42, Y = 73, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- GORKI
		{X = 36, Y = 69, AIBuildings = {FACTORY},}, -- KURSK
		{X = 46, Y = 69, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- KUYBYSHEV
		{X = 37, Y = 66, AIBuildings = {BARRACKS, FACTORY, SMALL_AIR_FACTORY, BASE, RADIO}, }, -- KHARKOV
		{X = 39, Y = 62, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- ROSTOV
		{X = 45, Y = 60, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- BAKU
		{X = 47, Y = 54, AIBuildings = {FACTORY},}, -- TEHERAN
		{X = 66, Y = 72, Buildings = { BARRACKS }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- NOVOSIBIRSK
		{X = 71, Y = 73, AIBuildings = {FACTORY},}, -- IRKUTSK
		{X = 77, Y = 79, AIBuildings = {FACTORY},}, -- NYURBA
		{X = 88, Y = 78, AIBuildings = {FACTORY},}, -- JAKUTSK
		{X = 92, Y = 66, Buildings = { HARBOR}, AIBuildings = {FACTORY, SHIPYARD, RADIO},}, -- WLADIWOSTOK
		{X = 98, Y = 80, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- MAGODAN
		{X = 102, Y = 76, Buildings = { HARBOR }, AIBuildings = {FACTORY},}, -- PETROPAVLOVSK


	-- AMERICA
		{X = 156, Y = 62, Key = true, Buildings = { HARBOR, ACADEMY, BANK, ARSENAL}, AIBuildings = {RADIO, HOSPITAL, FACTORY, BARRACKS, BASE}, }, -- Washington
		{X = 144, Y = 56, Key = true, Buildings = { BANK, ALLIEDCITY }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY}, }, -- DALLAS
		{X = 132, Y = 62, Key = true, Buildings = { BANK, HARBOR, ALLIEDCITY }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY}, }, -- SAN FRANCISCO
		{X = 132, Y = 59, Key = true, Buildings = { BANK, HARBOR}, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY, ALLIEDCITY}, }, -- LOS ANGELES
		{X = 157, Y = 65, Key = true, Buildings = { HARBOR, BANK, RADIO}, AIBuildings = {ARSENAL, HOSPITAL, FACTORY, ALLIEDCITY}, }, -- NEW YORK
		{X = 150, Y = 65, Key = true, Buildings = { BANK, ALLIEDCITY }, AIBuildings = {RADIO, RADIO, HOSPITAL, FACTORY, BARRACKS}, }, -- CHICAGO
		{X = 132, Y = 67, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- SEATTLE
		{X = 134, Y = 56, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- SAN DIEGO
		{X = 138, Y = 58, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- PHOENIX
		{X = 140, Y = 63, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- DENVER
		{X = 147, Y = 66, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- MINNEAPOLIS
		{X = 146, Y = 62, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- KANSAS CITY
		{X = 144, Y = 59, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- OKLAHOMA CITY
		{X = 144, Y = 53, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- HOUSTON
		{X = 153, Y = 52, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- MIAMI
		{X = 151, Y = 57, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- ATLANTA
		{X = 149, Y = 61, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- ST.LOUIS
		{X = 152, Y = 63, Buildings = { ALLIEDCITY }, AIBuildings = {FACTORY},}, -- CINCINNATI
		{X = 153, Y = 66, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- DETROIT
		{X = 159, Y = 66, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- BOSTON
		{X = 124, Y = 77, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- JUNEAU
		{X = 119, Y = 80, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- ANCHORAGE
		{X = 109, Y = 73, Buildings = { HARBOR, COLONY}, }, -- ATTU
		{X = 112, Y = 59, Buildings = { HARBOR, COLONY}, }, -- MIDWAY
		{X = 108, Y = 52, Buildings = { HARBOR, COLONY}, }, -- WAKE
		{X = 119, Y = 54, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- HONOLULU
		{X = 99, Y = 43, Buildings = { HARBOR, COLONY}, }, -- GUAM
		{X = 89, Y = 38, Buildings = { HARBOR, ALLIEDCITY}, AIBuildings = {FACTORY},}, -- MANILA
		{X = 124, Y = 21, Buildings = { HARBOR, COLONY}, }, -- SAMOA
		{X = 151, Y = 40, Buildings = { HARBOR, COLONY}, }, -- PANAMA
		{X = 159, Y = 45, Buildings = { HARBOR, COLONY}, }, -- SAN JUAN
		{X = 86, Y = 38, Buildings = { HARBOR, COLONY, OPENCITY}, }, -- CORREGIDOR

	-- JAPAN
		{X = 97, Y = 58, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- TOKYO
		{X = 94, Y = 57, Key = true, Buildings = { HARBOR, BANK, FACTORY }, AIBuildings = {RADIO, HOSPITAL, SHIPYARD}, }, -- OSAKA
		{X = 96, Y = 67, Key = true, Buildings = { HARBOR, BANK, FACTORY }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, SMALL_AIR_FACTORY}, }, -- SAPORRO
		{X = 89, Y = 61, Key = true, Buildings = { HARBOR, BANK, FACTORY }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, LAND_FACTORY}, }, -- SEOUL
		{X = 97, Y = 63, Key = true, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- AKITA
		{X = 90, Y = 55, Key = true, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- NAGASAKI
		{X = 89, Y = 64, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- PYÖNYANG
		{X = 86, Y = 67, AIBuildings = {FACTORY},}, -- SHENYANG
		{X = 88, Y = 70, AIBuildings = {FACTORY},}, -- HARBIN
		{X = 88, Y = 49, Buildings = { HARBOR}, AIBuildings = {FACTORY},}, -- TAIPEH
		{X = 91, Y = 50, Buildings = { HARBOR, COLONY}, }, -- NAHA
		{X = 99, Y = 52, Buildings = { HARBOR, COLONY}, }, -- IWO JIMA
		{X = 100, Y = 45, Buildings = { HARBOR, COLONY}, }, -- SAIPAN
		{X = 97, Y = 36, Buildings = { HARBOR, COLONY}, }, -- PELELIU

	-- CHINA
		{X = 85, Y = 57, Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {LAND_FACTORY}, }, -- NANJING
		{X = 88, Y = 56, Key = true, Buildings = { HARBOR, BANK, FACTORY }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, BARRACKS, LAND_FACTORY}, }, -- SHANGHAI
		{X = 82, Y = 64, Key = true, Buildings = { BANK }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, BARRACKS, LAND_FACTORY}, }, -- BEIJING
		{X = 78, Y = 53, Key = true, Buildings = { BANK, BARRACKS }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY, SMALL_AIR_FACTORY}, }, -- CHONGQING
		{X = 82, Y = 47, Key = true, Buildings = { BANK, BARRACKS }, AIBuildings = {RADIO, ARSENAL, HOSPITAL, FACTORY, LAND_FACTORY}, }, -- GUANGZHOU
		{X = 84, Y = 60, Buildings = { HARBOR},	}, -- ZIBO
		{X = 86, Y = 50, Buildings = { HARBOR},	}, -- FUZHOU
		{X = 80, Y = 46, Buildings = { HARBOR},	}, -- NANNING
		{X = 83, Y = 42, Buildings = { HARBOR},	}, -- HAIKOU
		{X = 79, Y = 59, }, -- XIAN
		{X = 82, Y = 54, }, -- WUHAN
		{X = 76, Y = 49, }, -- KUMMING
		{X = 75, Y = 53, }, -- CHENGDU
		{X = 63, Y = 62, }, -- URUMQI

	-- COMMUNIST CHINA
		{X = 75, Y = 60, Buildings = { FACTORY, BARRACKS, ARSENAL },}, -- XINING
		{X = 72, Y = 60, Buildings = { FACTORY, BARRACKS, ARSENAL },}, -- NANCHANG
}


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------