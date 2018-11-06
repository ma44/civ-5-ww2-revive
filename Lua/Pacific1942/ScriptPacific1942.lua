-- ScriptPacific1942
-- Author: bacononaboat
-- DateCreated: 3/25/2017
--------------------------------------------------------------

print("Loading Red Pacific 1942 Scripts...")
print("-------------------------------------")

---------------------------------------------------------------------------------------------------------------------------
-- Cities
----------------------------------------------------------------------------------------------------------------------------

-- Populate cities with buildings
-- Key cities are cities that need to be occupied to trigger victory

g_Cities = {
	-- UNITED KINGDOM
	{X = 8, Y = 49,  Key = true, Buildings = { BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL, COLONY }, AIBuildings = {LAND_FACTORY}, }, -- DELHI
	{X = 13, Y = 42, Key = true, Buildings = { HARBOR, COLONY }, AIBuildings = {FACTORY, LAND_FACTORY}, }, -- CALCUTTA
	{X = 6, Y = 41,  Buildings = { HARBOR, COLONY }, AIBuildings = {FACTORY}, }, -- BOMBAY
	{X = 21, Y = 44, Buildings = { HARBOR, COLONY }, AIBuildings = {FACTORY}, }, -- RANGOON
	{X = 24, Y = 32, Key = true, Buildings = { HARBOR, COLONY, ARSENAL, BARRACKS }, AIBuildings = {FACTORY}, }, -- SINGAPORE
	{X = 33, Y = 47, Key = true, Buildings = { HARBOR, COLONY, ARSENAL, BARRACKS }, AIBuildings = {FACTORY}, }, -- HONG KONG
	{X = 15, Y = 52, Buildings = { BARRICADES, BANK, FACTORY, COLONY} }, -- LHASA

	-- U.S.S.R.
	{X = 43, Y = 64, Buildings = { HARBOR, BANK }, }, -- VLADIVOSTOK
	{X = 55, Y = 75, Buildings = { HARBOR, BARRACKS }, AIBuildings = {FACTORY, LARGE_AIR_FACTORY, RADIO}, }, -- KAMCHATSKY
	{X = 5, Y = 61, Buildings = { BARRACKS }, AIBuildings = {FACTORY}, }, -- ALM-ATA
	{X = 24, Y = 73, Buildings = { HARBOR }, AIBuildings = {FACTORY, SHIPYARD, BASE, RADIO}, }, -- MAGADAN

	-- AMERICA
	{X = 102, Y = 54, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {SHIPYARD}, }, -- LOS ANGELES
	{X = 104, Y = 51, Buildings = { HARBOR, BANK, BARRACKS,  }, AIBuildings = {FACTORY}, }, -- SAN DIEGO
	{X = 101, Y = 57, Buildings = { HARBOR, BANK }, AIBuildings = {FACTORY}, }, -- SAN FRANCISCO
	{X = 101, Y = 61, Buildings = { HARBOR, BANK }, AIBuildings = {FACTORY}, }, -- SEATTLE
	{X = 108, Y = 51, Buildings = { BANK }, }, -- PHOENIX
	{X = 111, Y = 57, Buildings = { BANK }, AIBuildings = {FACTORY}, }, -- DENVER
	{X = 70, Y = 66, Buildings = { HARBOR, COLONY }, }, -- ATTU
	{X = 86, Y = 78, Buildings = { HARBOR, COLONY }, }, -- ANCHORAGE
	{X = 82, Y = 41, Buildings = { HARBOR, BANK, BARRACKS }, }, -- HONOLULU
	{X = 97, Y = 69, Buildings = { HARBOR }, }, -- JUNEAU
	{X = 79, Y = 44, Key = true, Buildings = { HARBOR, BARRACKS, BASE, OIL_REFINERY }, }, -- PEARL HARBOR
	{X = 66, Y = 49, Buildings = { HARBOR, BARRACKS },  }, -- MIDWAY
	{X = 108, Y = 59, Buildings = { BANK }, AIBuildings = {FACTORY}, }, -- SALT LAKE CITY
	{X = 67, Y = 34, Buildings = { HARBOR }, }, -- JOHNSTON
	{X = 39, Y = 37, Buildings = { HARBOR, OPEN_CITY }, AIBuildings = {FACTORY}, }, -- DAVAO
	{X = 36, Y = 42, Buildings = { HARBOR, OPEN_CITY }, AIBuildings = {FACTORY}, }, -- TACLOBAN
	{X = 57, Y = 14, Key = true,  Buildings = { HARBOR, BARRICADES, ARSENAL } }, -- NOUMEA
	
	-- JAPAN
	{X = 45, Y = 57, Key = true, Buildings = { HARBOR, BANK, FACTORY, RADIO, BARRACKS, OIL_REFINERY, BASE, ACADEMY, HOSPITAL, ARSENAL }, AIBuildings = {SHIPYARD}, }, -- TOKYO
	{X = 43, Y = 56, Key = true, Buildings = { BANK, BARRACKS, HARBOR, FACTORY, ARSENAL }, AIBuildings = {BASE}, }, -- OSAKA
	{X = 38, Y = 59, Buildings = { HARBOR, BANK }, AIBuildings = {FACTORY}, }, -- SEOUL
	{X = 41, Y = 56, Buildings = { HARBOR, BANK }, AIBuildings = {FACTORY}, }, -- NAGASAKI
	{X = 46, Y = 63, Buildings = { HARBOR, BANK, BARRACKS }, AIBuildings = {FACTORY}, }, -- SAPPORO
	{X = 36, Y = 66, Buildings = { BANK}, }, -- MUKDEN
	{X = 32, Y = 62, Key = true, Buildings = { BANK}, AIBuildings = {FACTORY}, }, -- PEKING
	{X = 34, Y = 58, Buildings = { HARBOR }, }, -- TSINGTAO
	{X = 33, Y = 54, Buildings = { HARBOR, BANK }, }, -- NUNKING
	{X = 56, Y = 34, Buildings = { HARBOR, BANK, OPEN_CITY }, }, -- TARAWA
	{X = 35, Y = 52, Key = true, Buildings = { HARBOR, BANK, BARRACKS }, }, -- SHANGHAI
	{X = 39, Y = 52, Buildings = { HARBOR, BANK, BARRACKS, ARSENAL }, }, -- OKINAWA
	{X = 27, Y = 44, Buildings = { HARBOR, BARRACKS, OIL_REFINERY}, }, -- HANOI
	{X = 29, Y = 40, Buildings = { HARBOR, BARRACKS },  }, -- SAIGON
	{X = 49, Y = 50, Buildings = { BANK, BARRACKS, HARBOR, }, }, -- IWO JIMA
	{X = 56, Y = 21, Key = true, Buildings = { HARBOR, OPEN_CITY }, }, -- GUADALCANAL
	{X = 44, Y = 27, Key = true, Buildings = { HARBOR, BARRICADES, COLONY }, }, -- JAYPARA
	{X = 37, Y = 32, Buildings = { HARBOR, BARRICADES, OPEN_CITY }, }, -- MANDANAO
	{X = 63, Y = 42, Buildings = { BANK,  OPEN_CITY }, }, -- WAKE
	{X = 50, Y = 43, Buildings = { HARBOR, }, }, -- SAIPAN
	{X = 49, Y = 41, Buildings = { HARBOR, BARRICADES, }, }, -- GUAM
	{X = 45, Y = 37, Buildings = { HARBOR, BARRICADES,  }, }, -- PALAU
	{X = 55, Y = 24, Buildings = { HARBOR, BARRICADES,  }, }, -- BOUGANVILLE
	{X = 58, Y = 19, Buildings = { HARBOR, BARRICADES,  }, }, -- SAN CRISTOBAL

	-- CHINA
	{X = 24, Y = 49, Buildings = { BARRICADES }, }, -- KUMMING
	{X = 28, Y = 52, Buildings = { BANK, BARRACKS, BARRICADES }, }, -- CHUNGKING
	{X = 26, Y = 56, Buildings = { HARBOR, BANK }, }, -- XIAN
	{X = 29, Y = 58, Buildings = { HARBOR, BANK, BARRACKS }, }, -- TAIWAN
	{X = 11, Y = 62, Buildings = { BANK}, }, -- URUMQUI
	{X = 19, Y = 57, Buildings = { BANK}, }, -- XINING
		
	-- DUTCH EAST INDIES
	{X = 27, Y = 24, Buildings = { HARBOR, }, }, -- JAKARTA
	{X = 21, Y = 32,  Buildings = { HARBOR, }, }, -- MEDAN
	{X = 36, Y = 23, Buildings = { HARBOR, }, }, -- TIMOR
	{X = 32, Y = 29, Buildings = { HARBOR, }, }, -- BANJARMASIN

	-- AUSTRALIA
	{X = 50, Y = 6,  Key = true,  Buildings = { HARBOR, BANK, BARRACKS, COLONY }, }, -- SYDNEY
	{X = 40, Y = 13, }, -- ALICE SPRINGS
	{X = 32, Y = 8,  Buildings = { HARBOR, COLONY }, }, -- PERTH
	{X = 42, Y = 21, Key = true, Buildings = { HARBOR, BANK, COLONY }, }, -- DARWIN
	{X = 47, Y = 23, Key = true,  Buildings = { COLONY, OPEN_CITY, HARBOR,  },}, -- PORT MORESBY
	
	-- NEW ZEALAND
	{X = 60, Y = 3, Buildings = { BARRICADES, BANK, FACTORY, HARBOR,  }, }, -- WELLINGTON

	-- THAILAND
	{X = 23, Y = 42, Buildings = { BARRICADES, BANK, FACTORY, HARBOR,  }, }, -- BANGKOK

	-- CANADA
	{X = 107, Y = 67, Buildings = { BARRICADES }, }, -- EDMONTON
	{X = 105, Y = 63, Buildings = { BARRICADES }, }, -- CALGARY
	{X = 100, Y = 63, Buildings = { BARRICADES, BANK, FACTORY, HARBOR,  }, }, -- VANCOUVER
	{X = 95, Y = 73, Buildings = { BARRICADES }, }, -- WHITEHORSE
	
	-- MEXICO
	{X = 110, Y = 48, Buildings = { BARRICADES }, }, -- CHIHUAHUA
	{X = 114, Y = 42, Buildings = { BARRICADES, BANK, FACTORY }, }, -- MEXICO CITY
	{X = 106, Y = 45, Buildings = { BARRICADES, HARBOR,  }, }, -- LA PAZ

	-- MONGOLIA
	{X = 18, Y = 67, Buildings = { BARRICADES, BANK, FACTORY }, }, -- ULANBATAAR

}


----------------------------------------------------------------------------------------------------------------------------
-- Convoy routes
----------------------------------------------------------------------------------------------------------------------------

-- first define the condition for convoys ... 


-- define the transport functions that will be stocked in the g_Convoy table... 

function IsRouteOpenBanjarmasinToJapan()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Banjarmasin to Japan", bDebug)
	local banjarmasinPlot = GetPlot(32,29)	-- Banjarmasin
	if  banjarmasinPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) then
		Dprint("      - Banjarmasin has been conquered...", bDebug)
		return true
	else
		Dprint("      - Banjarmasin has not been conquered...", bDebug)
		return false
	end
end

function GetBanjarmasinToJapanTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_OIL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 250}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 250}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function IsRouteOpenMedanToJapan()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Medan to Japan", bDebug)
	local medanPlot = GetPlot(21, 32)		-- Medan
	if (medanPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Medan has been conquered...", bDebug)
		return true
	else
		Dprint("      - Medan has not been conquered...", bDebug)
		return false
	end
end

function GetMedanToJapanTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_OIL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 250}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 750}
	end
	return transport
end

function IsRouteOpenSingaporeToJapan()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Singapore to Japan", bDebug)
	local singaporePlot = GetPlot(24, 32)		-- Singapore
	if (singaporePlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Singapore has been conquered...", bDebug)
		return true
	else
		Dprint("      - Singapore has not been conquered...", bDebug)
		return false
	end
end

function GetSingaporeToJapanTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_GOLD, Reference = 250} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 125}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 175}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_MATERIEL, Reference = 250}
	end
	return transport
end

function IsRouteOpenPanamaToUSATransport()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Panama to America", bDebug)
	local losAngelesPlot = GetPlot(102, 54)		-- Los Angeles
	local sanDiegoPlot = GetPlot(104, 50)		-- San Diego
	if (losAngelesPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) and sanDiegoPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Los Angeles and San Diego have been conquered...", bDebug)
		return false
	else
		Dprint("      - Los Angeles and San Diego has not been conquered...", bDebug)
		return true
	end
end

function GetPanamaToUSATransport()
	local rand = math.random( 1, 7 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_OIL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 175}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	else
		transport = {Type = TRANSPORT_GOLD, Reference = 750}
	end
	return transport
end

function IsRouteOpenSuezToIndiaTransport()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Suez to India", bDebug)
	local bombayPlot = GetPlot(6, 41)		-- Bombay

	if (bombayPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Bombay has been conquered...", bDebug)
		return false
	else
		Dprint("      - Bombay has not been conquered...", bDebug)
		return true
	end
end

function GetSuezToIndiaTransport()
	local transport
	transport = {Type = TRANSPORT_GOLD, Reference = 450}
	return transport
end

function IsRouteOpenUSToNoumeaTransport()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Los Angeles to Noumea", bDebug)
	local noumeaPlot = GetPlot(57, 14)		-- Noumea

	if (noumeaPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Noumea has been conquered...", bDebug)
		return false
	else
		Dprint("      - Noumea has not been conquered...", bDebug)
		return true
	end
end

function GetUStoNoumeaTransport()
	local rand = math.random( 1, 5 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 250} -- Reference is quantity of materiel, personnel or gold. For TRANSPORT_UNIT, Reference is the unit type ID
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 150}
	elseif rand == 3 then
		if turnDate < 19400101 then
			transport = {Type = TRANSPORT_GOLD, Reference = 300}
		elseif turnDate < 19420601 or turnDate >= 19400101 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B17}
		elseif turnDate < 19430601 or turnDate >= 19420601 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B24}
		elseif turnDate >= 19431001 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B29}
		end
	elseif rand == 4 then
		if turnDate < 19400101 then
			transport = {Type = TRANSPORT_GOLD, Reference = 300}
		elseif turnDate < 19420601 or turnDate >= 19400101 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_P40}
		elseif turnDate < 19430601 or turnDate >= 19420601 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_P47}
		elseif turnDate >= 19431001 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_P51}
		end
	else 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	end
	return transport
end

function IsRouteOpenUKToIndiaTransport()
	local bDebug = false
	Dprint("   - Checking possible maritime route from UK to India", bDebug)
	local bombayPlot = GetPlot(6, 41)		-- Bombay

	if (bombayPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Bombay has been conquered...", bDebug)
		return false
	else
		Dprint("      - Bombay has not been conquered...", bDebug)
		return true
	end
end

function GetUKToIndiaTransport()	     
	local rand = math.random( 1, 23 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_UNIT, Reference = UK_CHURCHILL} -- Reference is quantity of materiel, personnel or gold. For TRANSPORT_UNIT, Reference is the unit type ID
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_UNIT, Reference = US_M7}
	elseif rand == 3 then
			transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 4 then
			transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 5 then
		transport = {Type = TRANSPORT_UNIT, Reference = UK_SPITFIRE_IX}
	elseif rand == 6 then 
		transport = {Type = TRANSPORT_UNIT, Reference = UK_WELLINGTON}
	else
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function IsRouteOpenSeoulToJapanTransport()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Seoul to Japan", bDebug)
	local nagasakiPlot = GetPlot(41, 56)		-- Nagasaki

	if (nagasakiPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true)) then
		Dprint("      - Bombay has not been conquered...", bDebug)
		return true
	else
		Dprint("      - Bombay has been conquered...", bDebug)
		return false
	end
end

function GetSeoulToJapanTransport()
	local transport
	transport = {Type = TRANSPORT_MATERIEL, Reference = 500}
	return transport
end

-- ... then define the convoys table
-- don't move those define from this files, they must be set AFTER the functions definition...

-- Route list
BANJARMASIN_TO_JAPAN		= 1
MEDAN_TO_JAPAN				= 2
SINGAPORE_TO_JAPAN			= 3
PANAMA_TO_AMERICA			= 4
SUEZ_TO_INDIA				= 5
AMERICA_TO_NOUMEA			= 6
UK_TO_INDIA					= 7
SEOUL_TO_JAPAN				= 8

-- Convoy table
g_Convoy = { 
	[BANJARMASIN_TO_JAPAN] = {
		Name = "Banjarmasin to Japan",
		SpawnList = { {X=31, Y=29}, {X=32, Y=28}, {X=33, Y=28}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=43, Y=56}, {X=45, Y=57}, }, -- Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		UnitsName = {"Banjarmasin-Convoy to Japan"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 50, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenBanjarmasinToJapan, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetBanjarmasinToJapanTransport, -- Must refer to a function, remove this line to use the default function
	},
	[MEDAN_TO_JAPAN] = {
		Name = "Medan to Japan",
		SpawnList = { {X=20, Y=32}, {X=20, Y=31}, {X=21, Y=33}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=43, Y=56}, {X=45, Y=57}, }, -- Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		UnitsName = {"Medan-Convoy to Japan"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 50, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenMedanToJapan, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetMedanToJapanTransport, -- Must refer to a function, remove this line to use the default function
	},
	[SINGAPORE_TO_JAPAN] = {
		Name = "Singapore to Japan",
		SpawnList = { {X=24, Y=31}, {X=25, Y=32}, {X=24, Y=33}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=43, Y=56}, {X=45, Y=57}, }, -- Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		UnitsName = {"Singapore-Convoy to Japan"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 35, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenSingaporeToJapan, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetSingaporeToJapanTransport, -- Must refer to a function, remove this line to use the default function
	},
	[PANAMA_TO_AMERICA] = {
		Name = "Panama to America",
		SpawnList = { {X=114, Y=35}, {X=114, Y=35}, {X=114, Y=31}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=102, Y=54}, {X=104, Y=50}, }, -- Los Angeles, San Diego
		RandomDestination = false, -- false : sequential try in destination list
		CivID = AMERICA,
		UnitsName = {"Panama-Convoy to America"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 35, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenPanamaToUSATransport, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetPanamaToUSATransport, -- Must refer to a function, remove this line to use the default function
	},
	[SUEZ_TO_INDIA] = {
		Name = "Suez to India",
		SpawnList = { {X=0, Y=45}, {X=0, Y=44}, {X=0, Y=43}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=6, Y=41}, }, -- Bombay
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"Suez-Convoy to India"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 35, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenSuezToIndiaTransport, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetSuezToIndiaTransport, -- Must refer to a function, remove this line to use the default function
	},
	[AMERICA_TO_NOUMEA] = {
		Name = "Los Angeles to Noumea",
		SpawnList = { {X=101, Y=53}, {X=103, Y=50}, {X=100, Y=57}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=57, Y=14}, }, -- Noumea
		RandomDestination = false, -- false : sequential try in destination list
		CivID = AMERICA,
		UnitsName = {"America-Convoy to Noumea"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 45, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSToNoumeaTransport, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoNoumeaTransport, -- Must refer to a function, remove this line to use the default function
	},
	[UK_TO_INDIA] = {
		Name = "UK to India",
		SpawnList = { {X=0, Y=45}, {X=0, Y=44}, {X=0, Y=43}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=6, Y=41}, }, -- Bombay
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"UK-Convoy to India"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 35, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUKToIndiaTransport, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUKToIndiaTransport, -- Must refer to a function, remove this line to use the default function
	},
	[SEOUL_TO_JAPAN] = {
		Name = "Seoul to Japan",
		SpawnList = { {X=37, Y=59}, {X=38, Y=58}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=43, Y=56}, {X=45, Y=57}, {X=41, Y=56}, }, -- Osaka, Tokyo, Nagasaki
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		UnitsName = {"Seoul-Convoy to Japan"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 50, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenSeoulToJapanTransport, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetSeoulToJapanTransport, -- Must refer to a function, remove this line to use the default function
	},
}

function ReadyForAustralia()
	local PortMoresby = GetPlot(47, 23):GetPlotCity()		-- Port Moresby
	if (PortMoresby:IsOccupied()) then
		return true
	else
		return false
	end
end

function AustraliaConquered()
	local sydneyPlot = GetPlot(50, 6)	-- Sydney
	local aliceSpringsPlot = GetPlot(40, 13)		-- Alice Springs
	local perthPlot = GetPlot(32, 8)		-- Perth
	local darwinPlot = GetPlot(42, 21)		-- Darwin
	
	if (sydneyPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) and aliceSpringsPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) and perthPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) and darwinPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) ) then
		return true
	else
		return false
	end
end

g_Military_Project = {
	---------------------------------------------------------------------------------------------------
	[ENGLAND] = {
	---------------------------------------------------------------------------------------------------
		[OPERATION_FOURTEENTH_ARMY] = {
			Name = "TXT_KEY_OPERATION_FOURTEENTH_ARMY",
			OrderOfBattle = {
				{	Name = "Infantry Group", X = 16, Y = 46, Domain = "Land", CivID = ENGLAND, -- spawn near Calcutta
					Group = {		UK_INFANTRY,	UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, UK_INFANTRY,	},
					UnitsXP = {		15,					15,	     15,     15,     15,          15,}, 
					--InitialObjective = "44,50",  
				},
				{	Name = "Artillery Group", X = 12, Y = 45, Domain = "Land", CivID = ENGLAND, -- spawn near Calcutta
					Group = {		AT_GUN,	AT_GUN, AT_GUN, AT_GUN, ARTILLERY, ARTILLERY, ARTILLERY,	},
					--InitialObjective = "44,50", 
				},
				{	Name = "Army Group 2", X = 10, Y = 46, Domain = "Land", CivID = ENGLAND, AI = true, -- spawn near Delhi
					Group = {		UK_INFANTRY,	UK_A30, UK_INFANTRY, ARTILLERY, ARTILLERY, 	},
					UnitsXP = {		15,					15,       15,    15,     15,}, 
					--InitialObjective = "44,50",  
				},

				
			},	
			-- Quick Description: Requires the British AI/player to survive in India until 1943 before they receive land reinforcements. 	
		},	
		[OPERATION_TASK_FORCE_57] = {
			Name = "TXT_KEY_OPERATION_TASK_FORCE_57",
			OrderOfBattle = {
				{	Name = "Task Force 57 Group 1", X = 56, Y = 6, Domain = "Sea", CivID = ENGLAND, -- spawn near Sydney
					Group = {		UK_TRIBA, UK_TRIBA, UK_LEANDER, UK_LEANDER, UK_BATTLESHIP_2, UK_BATTLESHIP_2,  UK_SUBMARINE	},
					UnitsXP = {		15,		15,	     15,     15,     15,	15, 15}, 
					--InitialObjective = "44,50",  
				},	
				{	Name = "Task Force 57 Group 2", X = 59, Y = 8, Domain = "Sea", CivID = ENGLAND, -- spawn near Sydney
					Group = {		UK_TRIBA, UK_TRIBA, UK_SUBMARINE, UK_SUBMARINE, UK_LEANDER	},
					UnitsXP = {		15,		15,	     15,     15,     15}, 
					--InitialObjective = "44,50",  
				},		
			},		
		},
		-- Quick Description: Requires the British AI/player to survive in India until 1943 before they receive naval reinforcements.
	},	
	---------------------------------------------------------------------------------------------------
	[JAPAN] = {
	---------------------------------------------------------------------------------------------------
		[OPERATION_ALEUTIAN_ISLANDS] = {
			Name = "TXT_KEY_OPERATION_ALEUTIAN_ISLANDS",
			OrderOfBattle = {
				{	Name = "Aleutian Invasion", X = 69, Y = 64, Domain = "Land", CivID = JAPAN, -- spawn near Attu
					Group = {		JP_INFANTRY, JP_INFANTRY		},
					UnitsXP = {		15,					15}, 
					--InitialObjective = "44,50",  
				},
				
			},			
			-- Quick Description: Sort of a diversion invasion. Might not keep
		},
		[OPERATION_AUSTRALIA] = {
			Name = "TXT_KEY_OPERATION_AUSTRALIA",
			OrderOfBattle = {
				{	Name = "Perth Invasion", X = 29, Y = 8, Domain = "Land", CivID = JAPAN, -- spawn near Perth
					Group = {		JP_INFANTRY, JP_INFANTRY, JP_INFANTRY, JP_INFANTRY, AT_GUN, AT_GUN	},
					UnitsXP = {		15,	15, 15, 15, 15, 15, 15}, 
					InitialObjective = "32,8",  -- Perth
				},
				{	Name = "Sydney Invasion", X = 52, Y = 5, Domain = "Land", CivID = JAPAN,-- spawn near Sydney
					Group = {		JP_INFANTRY, JP_INFANTRY, JP_INFANTRY, JP_TYPE4, AT_GUN, AT_GUN	},
					UnitsXP = {		15,	15, 15, 15, 15, 15, 15}, 
					InitialObjective = "50,6",  -- Sydney
				},
				{	Name = "Darwin Invasion", X = 42, Y = 23, Domain = "Land", CivID = JAPAN, -- spawn near Darwin
					Group = {		JP_INFANTRY, JP_INFANTRY, JP_INFANTRY, JP_TYPE4, AT_GUN, AT_GUN	},
					UnitsXP = {		15,	15, 15, 15, 15, 15, 15}, 
					InitialObjective = "42,21",  -- Darwin
				},
				{	Name = "USA-Australian Army", X = 49, Y = 8, Domain = "Land", CivID = AMERICA, AI = true, -- spawn near Sydney
					Group = {US_INFANTRY, US_INFANTRY, AT_GUN},
					UnitsXP = {9,9,9}, 
					InitialObjective = "50,6",  -- Sydney
				},
				{	Name = "Anglo-Australian Army", X = 34, Y = 8, Domain = "Land", CivID = ENGLAND, -- spawn near Perth
					Group = {UK_INFANTRY, UK_INFANTRY, AT_GUN},
					UnitsXP = {9,9,9}, 
					InitialObjective = "32,8",  -- Sydney
				},
			},			
			Condition = ReadyForAustralia,
		},	
			-- Quick Description: This can only be launched by the AI Japan after they conquer Port Moresby.
	},	
	---------------------------------------------------------------------------------------------------
	[AMERICA] = {
	---------------------------------------------------------------------------------------------------
		[OPERATION_AUSTRALIAN_LIBERATION] = {
			Name = "TXT_KEY_OPERATION_AUSTRALIAN_LIBERATION",
			OrderOfBattle = {
				{	Name = "Perth Group", X = 35, Y = 8, Domain = "City", CivID = AMERICA, -- spawn near Perth
					Group = {US_PARATROOPER, US_PARATROOPER, US_MARINES, US_MARINES, US_SHERMAN_IV, US_SHERMAN_IV},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
					InitialObjective = "32,8",  -- Perth
					LaunchType = "ParaDrop",
					LaunchX = 35, -- Destination plot
					LaunchY = 9, -- (35,9) = Near Perth
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Sydney Group", X = 52, Y = 5, Domain = "City", CivID = AMERICA,-- spawn near Sydney
					Group = {US_MARINES, US_MARINES, US_MARINES, ARTILLERY, ARTILLERY, AT_GUN, US_SHERMAN_IV},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
					InitialObjective = "52,5",  -- Perth
					LaunchType = "ParaDrop",
					LaunchX = 47, -- Destination plot
					LaunchY = 9, -- (47,9) = Near Sydney
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Darwin Invasion", X = 42, Y = 23, Domain = "City", CivID = AMERICA, -- spawn near Darwin
					Group = {US_MARINES, US_MARINES, ARTILLERY, ARTILLERY},
					UnitsXP = {15, 15, 15, 15}, 
					InitialObjective = "42,23",  -- Perth
					LaunchType = "ParaDrop",
					LaunchX = 40, -- Destination plot
					LaunchY = 17, -- (40,17) = Near Darwin
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Anglo-Australian Army", X = 34, Y = 11, Domain = "City", CivID = ENGLAND, -- spawn near Perth
					Group = {UK_INFANTRY, UK_INFANTRY, AT_GUN},
					UnitsXP = {9,9,9}, 
					InitialObjective = "32,8",  -- Sydney
					LaunchType = "ParaDrop",
					LaunchX = 34, -- Destination plot
					LaunchY = 11, -- (34,11) = Near Darwin
					LaunchImprecision = 2, -- landing area
				},
			},			
			Condition = AustraliaConquered,
		},	
		[OPERATION_WATCHTOWER] = {
			Name = "TXT_KEY_OPERATION_WATCHTOWER",
			OrderOfBattle = {
				{	Name = "1st Fleet", X = 54, Y = 15, Domain = "Sea", CivID = AMERICA, -- spawn northwest of Noumea
					Group = {US_BATTLESHIP, US_BENSON, US_BALTIMORE, US_BALTIMORE, US_BALTIMORE, US_BENSON, US_FLETCHER},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "2nd Fleet", X = 61, Y = 21, Domain = "Sea", CivID = AMERICA, -- spawn northeast of San Cristobal
					Group = {US_BALTIMORE, US_BENSON, US_SUBMARINE, US_SUBMARINE, US_SUBMARINE, US_BENSON, US_BENSON},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "San Cristobal Assault", X = 57, Y = 19, Domain = "City", CivID = AMERICA,-- spawn near San Cristobal
					Group = {US_MARINES, ARTILLERY},
					UnitsXP = {15,	15}, 
				},
				{	Name = "Darwin Invasion", X = 55, Y = 20, Domain = "Land", CivID = AMERICA, -- spawn near Guadalcanal
					Group = {US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15, 15, 15}, 
				},
			},			
		},	
			-- Quick Description: This can only be launched by the AI Japan after they conquer Port Moresby.	
		[OPERATION_MARCH_BACK] = {
			Name = "TXT_KEY_OPERATION_MARCH_BACK",
			OrderOfBattle = {
				{	Name = "Jaypara Attack", X = 45, Y = 26, Domain = "City", CivID = AMERICA, -- spawn near Jaypara
					Group = {US_INFANTRY, US_INFANTRY, ARTILLERY},
					UnitsXP = {9,9,9}, 
					InitialObjective = "44,27",  -- Jaypara
					LaunchType = "ParaDrop",
					LaunchX = 45, -- Destination plot
					LaunchY = 26, -- (34,11) = Near Darwin
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Darwin Invasion", X = 63, Y = 41, Domain = "Land", CivID = AMERICA, -- spawn near Wake
					Group = {US_MARINES, US_MARINES},
					UnitsXP = {15, 15}, 
				},
				{	Name = "Bougainville Invasion", X = 56, Y = 24, Domain = "Land", CivID = AMERICA, -- spawn near Wake
					Group = {US_MARINES, US_MARINES},
					UnitsXP = {15, 15}, 
				},
				{	Name = "Tarawa Invasion", X = 56, Y = 33, Domain = "Land", CivID = AMERICA, -- spawn near Tarawa
					Group = {US_MARINES, US_MARINES},
					UnitsXP = {15, 15}, 
				},
				{	Name = "Guam and Saipan Invasion", X = 51, Y = 41, Domain = "Land", CivID = AMERICA, -- spawn near Guam and Saipan
					Group = {US_MARINES, US_MARINES, US_MARINES, US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "Mandanao Invasion 1", X = 38, Y = 32, Domain = "Land", CivID = AMERICA, -- spawn near Mandanao
					Group = {US_MARINES, ARTILERY},
					UnitsXP = {15, 15}, 
				},
				{	Name = "Mandanao Invasion 2", X = 36, Y = 32, Domain = "Land", CivID = AMERICA, -- spawn near Mandanao
					Group = {US_MARINES},
					UnitsXP = {15}, 
				},
				{	Name = "Phillipines Fleet", X = 39, Y = 31, Domain = "Sea", CivID = AMERICA, -- spawn near Mandanao
					Group = {US_PENNSYLVANIA, US_BALTIMORE, US_FLETCHER, US_FLETCHER},
					UnitsXP = {15, 15, 15, 15}, 
				},
				{	Name = "Guam Saipan Fleet", X = 46, Y = 43, Domain = "Sea", CivID = AMERICA, -- spawn near Guam and Saipan
					Group = {US_SUBMARINE, US_BALTIMORE, US_FLETCHER, US_FLETCHER, US_SUBMARINE},
					UnitsXP = {15, 15, 15, 15, 15}, 
				},
			},			
		},	
			-- Quick Description: Conquer Japyara, 	Wake, Bouganville, Tarawa, Palau, Guam, Saipan, Mandanao.

		[OPERATION_TAKE_DOWN] = {
			Name = "TXT_KEY_OPERATION_TAKE_DOWN",
			OrderOfBattle = {
				{	Name = "1st Invasion Fleet", X = 44, Y = 50, Domain = "Sea", CivID = AMERICA, -- spawn northwest of Noumea
					Group = {US_BATTLESHIP_2, US_BATTLESHIP_2, US_BATTLESHIP_2, US_FLETCHER, US_FLETCHER, US_FLETCHER, US_BALTIMORE},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "2nd Invasion Fleet", X = 49, Y = 57, Domain = "Sea", CivID = AMERICA, -- spawn northeast of San Cristobal
					Group = {US_BALTIMORE, US_BALTIMORE, US_SUBMARINE, US_SUBMARINE, US_SUBMARINE, US_SUBMARINE, US_FLETCHER},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "3rd Invasion Fleet", X = 47, Y = 53, Domain = "Sea", CivID = AMERICA, -- spawn northeast of San Cristobal
					Group = {US_BALTIMORE, US_FLETCHER, US_SUBMARINE, US_SUBMARINE, US_SUBMARINE, US_FLETCHER, US_FLETCHER},
					UnitsXP = {15,	15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "Manila Assault", X = 34, Y = 42, Domain = "Land", CivID = AMERICA,-- spawn near Manila
					Group = {US_MARINES, US_MARINES, US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15,	15,	15,	15,	15}, 
				},
				{	Name = "Davao Invasion", X = 40, Y = 37, Domain = "Land", CivID = AMERICA, -- spawn near Davao
					Group = {US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15, 15, 15}, 
				},
				{	Name = "Iwo Jima Invasion", X = 50, Y = 50, Domain = "Land", CivID = AMERICA, -- spawn near Iwo Jima
					Group = {US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15, 15, 15}, 
				},
				{	Name = "Okinawa Invasion", X = 40, Y = 52, Domain = "Land", CivID = AMERICA, -- spawn near Okinawa
					Group = {US_MARINES, US_MARINES, US_MARINES},
					UnitsXP = {15, 15, 15}, 
				},
				{	Name = "Homeland Invasion 1", X = 43, Y = 60, Domain = "Land", CivID = AMERICA, -- spawn near Japan
					Group = {US_MARINES, US_MARINES, US_MARINES, US_MARINES, ARTILLERY, ARTILLERY, ARTILLERY},
					UnitsXP = {15, 15, 15, 15, 15, 15, 15}, 
				},
				{	Name = "Homeland Invasion 2", X = 45, Y = 54, Domain = "Land", CivID = AMERICA, -- spawn near Japan
					Group = {US_MARINES, US_INFANTRY, US_MARINES, US_MARINES, ARTILLERY, ARTILLERY, ARTILLERY},
					UnitsXP = {15, 15, 15, 15, 15, 15, 15}, 
				},
			},			
		},	
		-- Quick Description: Conquer Davao, Manila, Iwo JIma, Okinawa, Tokyo, Osaka, Nagasaki. 
	},
}

-------------------------------------------------------------
-- UI functions
--------------------------------------------------------------
include("InstanceManager")

-- Tooltip init
function DoInitPacific1942UI()
	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetToolTipCallback( ToolTipPacific1942Score )
	UpdatePacific1942ScoreString()
end

local tipControlTable = {};
TTManager:GetTypeControlTable( "TooltipTypeTopPanel", tipControlTable );

-- Score Tooltip for Pacific 42-45
function ToolTipPacific1942Score( control )

	local playerID = Game:GetActivePlayer()
	local player = Players[playerID]

	local strText = "[ICON_MEDAL] Objective :[NEWLINE][NEWLINE]All key cities of your opponents must have been captured by you or your allies while all of your cities (and those of your allies) must still be under your control.[NEWLINE]";
	
	local strAlliedColor = "[COLOR_POSITIVE_TEXT]"
	local strAxisColor = "[COLOR_NEGATIVE_TEXT]"
	if IsAxis(playerID) then	
		strAlliedColor = "[COLOR_NEGATIVE_TEXT]"
		strAxisColor = "[COLOR_POSITIVE_TEXT]"
	end

	-- Allied cities
	strText = strText .. "[NEWLINE]----------------------------------------------------------------[NEWLINE]"
	strText = strText .. "[NEWLINE]Allied cities: "

	for i, city in ipairs(GetAlliedKeyCities()) do
		local playerID = city:GetOwner()
		local player = Players[playerID]
		if IsAxis(playerID) then
			strText = strText .. "[NEWLINE][ICON_BULLET] ".. strAxisColor .. city:GetName() .."[ENDCOLOR] controlled by ".. strAxisColor .. player:GetName() .. "[ENDCOLOR]"
		else
			strText = strText .. "[NEWLINE][ICON_BULLET] ".. strAlliedColor .. city:GetName() .."[ENDCOLOR] controlled by ".. strAlliedColor .. player:GetName() .. "[ENDCOLOR]"
		end
	end
	strText = strText .. "[NEWLINE]----------------------------------------------------------------[NEWLINE]"
	strText = strText .. "[NEWLINE]Axis cities: "

	-- Axis cities
	for i, city in ipairs(GetAxisKeyCities()) do
		local playerID = city:GetOwner()
		local player = Players[playerID]
		if IsAxis(playerID) then
			strText = strText .. "[NEWLINE][ICON_BULLET] ".. strAxisColor .. city:GetName().."[ENDCOLOR] controlled by ".. strAxisColor .. player:GetName() .. "[ENDCOLOR]"
		else
			strText = strText .. "[NEWLINE][ICON_BULLET] ".. strAlliedColor .. city:GetName().."[ENDCOLOR] controlled by ".. strAlliedColor .. player:GetName() .. "[ENDCOLOR]"
		end
	end

	
	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end

function UpdatePacific1942ScoreString()

	local playerID = Game:GetActivePlayer()
	--local player = Players[playerID]

	local scoreString = "[ICON_MEDAL] Captured cities: "

	if g_Axis[civID] then	
		strAlliedColor = "[COLOR_NEGATIVE_TEXT]"
		strAxisColor = "[COLOR_POSITIVE_TEXT]"
	end

	local capturedAllied = 0
	local totalAllied = 0
	for i, city in ipairs(GetAlliedKeyCities()) do
		totalAllied = totalAllied + 1
		if IsAxis(city:GetOwner()) then
			capturedAllied = capturedAllied + 1
		end
	end
	
	local capturedAxis = 0
	local totalAxis = 0
	for i, city in ipairs(GetAxisKeyCities()) do
		totalAxis = totalAxis + 1
		if IsAllied(city:GetOwner()) then
			capturedAxis = capturedAxis + 1
		end
	end
	
	local strAlliedColor = "[COLOR_NEGATIVE_TEXT]"
	local strAxisColor = "[COLOR_POSITIVE_TEXT]"

	if capturedAllied > 0 and IsAxis(playerID) then
		strAlliedColor = "[COLOR_POSITIVE_TEXT]"
	end
	
	if capturedAxis > 0 and IsAxis(playerID) then
		strAxisColor = "[COLOR_NEGATIVE_TEXT]"
	end

	scoreString = scoreString .. "Allied = " .. strAlliedColor .. capturedAllied .. "[ENDCOLOR]/" .. totalAllied .. ", Axis = " .. strAxisColor .. capturedAxis .. "[ENDCOLOR]/" .. totalAxis

	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetText( scoreString )
	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetHide( false )
end

function GetAlliedKeyCities()	
	local cities = {}

	if not g_Cities then
		return cities
	end

	for i, data in ipairs(g_Cities) do
		if data.Key then

			local plot = GetPlot(data.X, data.Y)
			local city = plot:GetPlotCity()	
			if city and IsAllied(GetPlotFirstOwner(GetPlotKey(plot))) then
				table.insert(cities, city)
			end
		end
	end

	return cities
end

function GetAxisKeyCities()	
	local cities = {}

	if not g_Cities then
		return cities
	end

	for i, data in ipairs(g_Cities) do
		if data.Key then

			local plot = GetPlot(data.X, data.Y)
			local city = plot:GetPlotCity()	
			if city and IsAxis(GetPlotFirstOwner(GetPlotKey(plot))) then
				table.insert(cities, city)
			end
		end
	end

	return cities
end


function InitializePacific1942rojects()

	local bDebug = false

	Dprint("-------------------------------------", bDebug)
	Dprint("Initializing specific projects for Pacific 1942-1945 scenario...", bDebug)

	if not g_ProjectsTable then
		return
	end

	local turn = Game.GetGameTurn()
	local date = g_Calendar[turn]
	-- America
	if date.Number >= 19420101 and PROJECT_M3A1HT and not IsProjectDone(PROJECT_M3A1HT) then
		local projectInfo = GameInfo.Projects[PROJECT_M3A1HT]
		MarkProjectDone(PROJECT_M3A1HT, AMERICA)
		Events.GameplayAlertMessage(Locale.ConvertTextKey(projectInfo.Description) .." has been completed !")
	end
end

function BalanceScenario()
	-- Place the line at India
	SetBunkerAt(17, 47)
	SetBunkerAt(18, 46)	
end




