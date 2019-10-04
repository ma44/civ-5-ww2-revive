-- ScriptEuro1940
-- Author: Gedemon
-- DateCreated: 8/23/2011 10:36:46 PM
--------------------------------------------------------------

print("Loading Red Europe 1940 Scripts...")
print("-------------------------------------")

-----------------------------------------
-- Capitulation: Capture a enemy capital that isn't the original or all city states
-----------------------------------------

-----------------------------------------
-- Functions override
-----------------------------------------
function RemoveHiddenCivs()
	local bDebug = false
	Dprint("-------------------------------------", bDebug)
	Dprint("Remove starting units from hidden minor civs ...", bDebug)
	for playerID = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
		local player = Players[playerID]
		local minorCivID = player:GetMinorCivType()
		-- Does this civ exist ?
		if minorCivID ~= -1 then
			for v in player:Units() do
				if (v:GetUnitType() == SETTLER) then
					v:SetDamage( v:GetMaxHitPoints() )
				end
			end
		end
	end
	
	if HOTSEAT_CIV_TO_KILL then
		Dprint("-------------------------------------", bDebug)
		Dprint("Remove starting units from hidden major civs ...", bDebug)
		local player = Players[GetPlayerIDFromCivID (HOTSEAT_CIV_TO_KILL, false, true)]
		if player then
			for v in player:Units() do
				v:Kill(true, -1)
			end
		end
	end

	-- No America at start
	local player = Players[GetPlayerIDFromCivID (AMERICA, false, true)]
	if player then		
		if not player:IsHuman() then
			for v in player:Units() do
				v:Kill(true, -1)
			end
		else
			-- spectator/auto-play mode
			local newUnit = player:InitUnit(US_SPECIAL_FORCES, 1, 88)
			for v in player:Units() do				
				if (v:GetUnitType() ~= US_SPECIAL_FORCES) then
					v:Kill(true, -1)
				end
			end
			local spectateTeam = player:GetTeam()
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				if (plot:GetVisibilityCount(spectateTeam) > 0) then
					plot:ChangeVisibilityCount(spectateTeam, -1, -1, true)
				end
				plot:SetRevealed(spectateTeam, false)
				plot:ChangeVisibilityCount(spectateTeam, 1, -1, true)
				plot:SetRevealed(spectateTeam, true)
			end
			OptionsManager.SetSinglePlayerAutoEndTurnEnabled_Cached(true)
		end
	end
end

function AreSameSide( player1ID, player2ID)

	local bDebug = false

	if player1ID == player2ID then -- obvious but useful !
		return true
	end
	local player = Players[ player1ID ]
	local player2 = Players[ player2ID ]

	if not player then
		return false
	end
	if not player2 then
		return false
	end

	Dprint ("testing same side for : " .. player:GetName() .." and " .. player2:GetName(), bDebug )
	local team = Teams[ player:GetTeam() ]
	local team2 = Teams[ player2:GetTeam() ]

	local civ1ID = GetCivIDFromPlayerID (player1ID)
	local civ2ID = GetCivIDFromPlayerID (player2ID)

	if not player:IsMinorCiv() and not player2:IsMinorCiv() then	
		Dprint ("Both are major...", bDebug )

		-- to simulate non agression pact and resource sharing before Barbarossa...
		if ( civ1ID == GERMANY and civ2ID == USSR ) then 
			if not team:IsAtWar( player2:GetTeam() ) then
				return true
			end
		end
		if ( civ1ID ==  USSR and civ2ID == GERMANY) then
			if not team:IsAtWar( player2:GetTeam() ) then
				return true
			end
		end
		----

		if ( g_Allied[civ1ID] and g_Allied[civ2ID] ) then
			if not team:IsAtWar( player2:GetTeam() ) then
				return true
			end
		end
		if ( g_Axis[civ1ID] and g_Axis[civ2ID] ) then
			if not team:IsAtWar( player2:GetTeam() ) then
				return true
			end
		end
	end
	if player:IsMinorCiv() then
		Dprint ("first is minor...", bDebug )
		if player:IsFriends(player2ID) or player:IsAllies(player2ID) then
			return true
		end
	end
	if player2:IsMinorCiv() then
		Dprint ("second is minor...", bDebug )
		if player2:IsFriends(player1ID) or player2:IsAllies(player1ID) then
			return true
		end
	end
	Dprint ("No positive result...", bDebug )
	Dprint ("---------------------", bDebug )

	return false
end

-----------------------------------------
-- Strategic AI
-----------------------------------------

g_Norway_Land_Ratio = 1
g_Egypt_Land_Ratio = 1
g_Libya_Land_Ratio = 1
g_Albania_Land_Ratio = 1
g_NAfrica_Land_Ratio = 1
g_France_Land_Ratio = 1
g_USSR_Land_Ratio = 1

-- limit troops route on specific fronts
g_MaxForceInNorway = 100000
g_MaxForceInAfrica = 200000

function SetAIStrategicValues()

	local bDebug = false
	
	Dprint ("-------------------------------------", bDebug)
	Dprint ("Cache scenario AI Strategic values...", bDebug)
	local t_start = os.clock()


	local initialNorway, initialEgypt, initialLibya, initialNAfrica, initialAlbania = 0, 0, 0, 0, 0
	local actualNorway, actualEgypt, actualLibya, actualNAfrica, actualAlbania = 0, 0, 0, 0, 0

	local iNorway = GetPlayerIDFromCivID (NORWAY, true, true)
	local iEgypt = GetPlayerIDFromCivID (EGYPT, true, true)
	local iLibya = GetPlayerIDFromCivID (LIBYA, true, true)
	local iAlgeria = GetPlayerIDFromCivID (ALGERIA, true, true)
	local iTunisia = GetPlayerIDFromCivID (TUNISIA, true, true)
	local iMorocco = GetPlayerIDFromCivID (MOROCCO, true, true)
	local iAlbania = GetPlayerIDFromCivID (ALBANIA, true, true)

	
	local initialFrance = 0
	local actualFrance = 0
	local initialUSSR = 0
	local actualUSSR = 0

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local iUSSR = GetPlayerIDFromCivID (USSR, false, true)

	local territoryMap = LoadTerritoryMap()

	for i, data in pairs (territoryMap) do
		local originalOwner = data.PlayerID
		if originalOwner == iNorway then
			initialNorway = initialNorway + 1

		elseif originalOwner == iEgypt then
			initialEgypt = initialEgypt + 1

		elseif originalOwner == iLibya then
			initialLibya = initialLibya + 1		

		elseif originalOwner == iAlgeria or originalOwner == iTunisia or originalOwner == iMorocco then
			initialNAfrica = initialNAfrica + 1

		elseif originalOwner == iAlbania then
			initialAlbania = initialAlbania + 1
			
		elseif originalOwner == iFrance then
			initialFrance = initialFrance + 1
			
		elseif originalOwner == iUSSR then
			initialUSSR = initialUSSR + 1
		end
	end

	for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
		local plot = Map.GetPlotByIndex(iPlotLoop)
		local owner = plot:GetOwner()

		if owner == iNorway then
			actualNorway = actualNorway + 1

		elseif owner == iEgypt then
			actualEgypt = actualEgypt + 1

		elseif owner == iLibya then
			actualLibya = actualLibya + 1		

		elseif owner == iAlgeria or owner == iTunisia or owner == iMorocco then
			actualNAfrica = actualNAfrica + 1

		elseif owner == iAlbania then
			actualAlbania = actualAlbania + 1	

		elseif owner == iFrance then
			actualFrance = actualFrance + 1
			
		elseif owner == iUSSR then
			actualUSSR = actualUSSR + 1
		end
	end
	g_Norway_Land_Ratio = actualNorway / initialNorway
	g_Egypt_Land_Ratio = actualEgypt / initialEgypt
	g_Libya_Land_Ratio = actualLibya / initialLibya
	g_NAfrica_Land_Ratio = actualNAfrica / initialNAfrica
	g_Albania_Land_Ratio = actualAlbania / initialAlbania

	g_France_Land_Ratio = actualFrance / initialFrance
	g_USSR_Land_Ratio = actualUSSR / initialUSSR

	local t_end = os.clock()
	Dprint("  - Total time :		" .. t_end - t_start .. " s")
end

-----------------------------------------
-- France
-----------------------------------------

-- to do : 
-- liberation of Paris -> liberate vichy France if still existing
-- annexation of Vichy France -> when Morocco, Algeria or Tunisia is liberated by allies (then maybe giving vichy units to axis or France ?)

function NorthFranceInvaded()
	local Dunkerque = GetPlot(29, 50):GetPlotCity()	-- Dunkerque
	local Metz = GetPlot(34, 46):GetPlotCity()		-- Metz
	local Mulhouse = GetPlot(34, 42):GetPlotCity()	-- Mulhouse
	local Reims = GetPlot(31, 46):GetPlotCity()		-- Reims
	local Paris = GetPlot(28, 45):GetPlotCity()		-- Paris
	local Caen = GetPlot(25, 46):GetPlotCity()		-- Caen
	local Cherbourg = GetPlot(23, 48):GetPlotCity()		-- Cherbourg
	if (Dunkerque:IsOccupied() and Metz:IsOccupied() and Mulhouse:IsOccupied() and Reims:IsOccupied() and Paris:IsOccupied() and Caen:IsOccupied() and Cherbourg:IsOccupied()) then
		return true
	else
		return false
	end
end

function NorthAfricaInvaded()
	local Algier = GetPlot(21, 21):GetPlotCity()		-- Algier
	local Oran = GetPlot(15, 20):GetPlotCity()			-- Oran
	local Casablanca = GetPlot(4, 17):GetPlotCity()		-- Casablanca
	local Rabat= GetPlot(7, 18):GetPlotCity()			-- Rabat
	if (Algier:IsOccupied() and Oran:IsOccupied() and Casablanca:IsOccupied() and Rabat:IsOccupied()) then
		return true
	else
		return false
	end
end

function NorthAfricaLiberated()
	local Tobruk		= GetPlot(56, 5):GetPlotCity()		-- Tobruk
	local Tripolis		= GetPlot(39, 7):GetPlotCity()		-- Tripolis
	local Benghazi		= GetPlot(51, 5):GetPlotCity()		-- Benghazi
	local Algier		= GetPlot(21, 21):GetPlotCity()		-- Algier
	local Oran			= GetPlot(15, 20):GetPlotCity()		-- Oran
	local Casablanca	= GetPlot(4, 17):GetPlotCity()		-- Casablanca
	local Rabat			= GetPlot(7, 18):GetPlotCity()		-- Rabat
	local Tunis			= GetPlot(33, 17):GetPlotCity()		-- Tunis
	local Marrakech		= GetPlot(4, 14):GetPlotCity()		-- Marrakech
	
	if (Tobruk:IsOccupied() and Tripolis:IsOccupied() and Benghazi:IsOccupied()) then
		if (Algier:IsOccupied() or Oran:IsOccupied() or Casablanca:IsOccupied() or Rabat:IsOccupied()or Tunis:IsOccupied()or Marrakech:IsOccupied()) then
			return false
		else
			return true
		end
	else
		return false
	end
end

function FranceHasFallen()
	local savedData = Modding.OpenSaveData()
	local iValue = savedData.GetValue("FranceHasFallen")
	if (iValue == 1) then
		return true
	else
		return false
	end
end

function IsFranceStanding()
	if FranceHasFallen() then
		return false
	else
		return true
	end
end

g_CapturingPlayer = nil

function FallOfFrance(hexPos, playerID, cityID, newPlayerID)
	local bDebug = false	

	if  not ALLOW_SCRIPTED_EVENTS then
		return
	end

	local turn = Game.GetGameTurn()
	local turnDate = REAL_WORLD_ENDING_DATE  
	if g_Calendar[turn] then 
		if g_Calendar[turn].Number > MAX_FALL_OF_FRANCE_DATE then -- Fall of france has a date of peremption...
			return 
		end
	end 
	
	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local iUSSR = GetPlayerIDFromCivID (USSR, false, true)

	if AreAtWar( iGermany, iUSSR) then -- There is hope in the East !
		return
	end

	local cityPlot = Map.GetPlot( ToGridFromHex( hexPos.x, hexPos.y ) )
	
	local x, y = ToGridFromHex( hexPos.x, hexPos.y )
	local civID = GetCivIDFromPlayerID(newPlayerID, false)
	g_CapturingPlayer = Players[newPlayerID]
	if x == 28 and y == 45 then -- city of Paris
	
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Paris Captured !")
		if (civID == GERMANY or civID == ITALY) then -- captured by Germany or Italy...
			local pParis = cityPlot:GetPlotCity()
			Dprint("- Captured by Axis power ...")
			local savedData = Modding.OpenSaveData()
			local iValue = savedData.GetValue("FranceHasFallen")
			if (iValue ~= 1) then
				Dprint("- First occurence, launching script ...")

				local co = StartCoroutine( CoCallOfFrance )
				coroutine.resume(co)
			else
				Dprint("- Duplicate event, script was not launched ...")
			end
		end
	end
end
-- add to Events.SerialEventCityCaptured in main scenario Lua

function CoCallOfFrance()
	
	local savedData = Modding.OpenSaveData()
	local bDebug = false
	-- todo: learn how to pass those to the coroutine...
	local cityPlot = GetPlot (28,45)
	local pParis = cityPlot:GetPlotCity()
	local pAxis = g_CapturingPlayer
	local iAxis = pAxis:GetID()
	g_CapturingPlayer = nil
	--

	savedData.SetValue("FranceHasFallen", 1) 

	local iVichy = GetPlayerIDFromCivID (VICHY, true, true)
	local pVichy = Players[iVichy]

	local iAlgeria = GetPlayerIDFromCivID (ALGERIA, true, true)
	local pAlgeria = Players[iAlgeria]
	local iMorocco = GetPlayerIDFromCivID (MOROCCO, true, true)
	local pMorocco = Players[iMorocco]
	local iSyria = GetPlayerIDFromCivID (SYRIA, true, true)
	local pSyria = Players[iSyria]
	local iTunisia = GetPlayerIDFromCivID (TUNISIA, true, true)
	local pTunisia = Players[iTunisia]
	local iLebanon = GetPlayerIDFromCivID (LEBANON, true, true)
	local pLebanon = Players[iLebanon]

	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local pItaly = Players[iItaly]

	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local pGermany = Players[iGermany]
				
	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local pFrance = Players[iFrance]

	local iEngland = GetPlayerIDFromCivID (ENGLAND, false, true)
	local pEngland = Players[iEngland]

	-- save processor time, only get one city by nation (capital or closest from Paris) and send all units there				
	local EnglandCity = pEngland:GetCapitalCity()
	if not EnglandCity then
		EnglandCity = GetCloseCity ( iEngland, cityPlot , true)
	end
	local iEnglandCityX = EnglandCity:GetX()
	local iEnglandCityY = EnglandCity:GetY()

	local AlgeriaCity = Players[iAlgeria]:GetCapitalCity()
	if not AlgeriaCity then
		AlgeriaCity = GetCloseCity ( iAlgeria, cityPlot , true)
	end
	local iAlgeriaCityX = AlgeriaCity:GetX()
	local iAlgeriaCityY = AlgeriaCity:GetY()

	local TunisiaCity = Players[iTunisia]:GetCapitalCity()
	if not TunisiaCity then
		TunisiaCity = GetCloseCity ( iTunisia, cityPlot , true)
	end
	local iTunisiaCityX = TunisiaCity:GetX()
	local iTunisiaCityY = TunisiaCity:GetY()

	local MoroccoCity = Players[iMorocco]:GetCapitalCity()
	if not MoroccoCity then
		MoroccoCity = GetCloseCity ( iMorocco, cityPlot , true)
	end
	local iMoroccoCityX = MoroccoCity:GetX()
	local iMoroccoCityY = MoroccoCity:GetY()

	local SyriaCity	= Players[iSyria]:GetCapitalCity()
	if not SyriaCity then
		SyriaCity = GetCloseCity ( iSyria, cityPlot , true)
	end				
	local iSyriaCityX = SyriaCity:GetX()
	local iSyriaCityY = SyriaCity:GetY()

	local LebanonCity = Players[iLebanon]:GetCapitalCity()
	if not LebanonCity then
		LebanonCity = GetCloseCity ( iLebanon, cityPlot , true)
	end
	local iLebanonCityX = LebanonCity:GetX()
	local iLebanonCityY = LebanonCity:GetY()
				
	Dprint("- Each U.K. unit on french territory get 50% chance to go back to London (or die trying)", bDebug)
	for unit in pEngland:Units() do 
		if unit:GetPlot():GetOwner() == iFrance then
			if math.random( 1, 100 ) > 50 or unit:GetDomainType() == DomainTypes.DOMAIN_SEA then
				Dprint("  Killed : " .. unit:GetName(), bDebug)
				unit:Kill(false, -1)
			else
				Dprint("  Escape : " .. unit:GetName(), bDebug)
				CleanOrdersRED (unit)
				unit:SetXY(iEnglandCityX, iEnglandCityY)
			end
		end
	end
	coroutine.yield()

	Dprint("- Change french units ownership ...", bDebug)
	local palmyraPlot = GetPlot (84,12)
	local palmyra = palmyraPlot:GetPlotCity()
	if palmyra:GetOwner() ~= iFrance then -- give back Palmyra to France
		EscapeUnitsFromPlot(palmyraPlot)
		Players[iFrance]:AcquireCity(palmyra, false, true)
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, palmyra:GetName() .. " has revolted and is joigning Free France.", palmyra:GetName() .. " has revolted !", -1, -1)
	end
				
	local Air = {}
	local Sea = {}
	local Land = {}

	-- fill table (remove convoy and fortifications)
	for unit in pFrance:Units() do 
		--local newUnit = ChangeUnitOwner (unit, iVichy)
		if (unit:GetUnitType() == CONVOY or unit:GetUnitType() == FORTIFIED_GUN) then
			Dprint(" - Killing " .. unit:GetName(), bDebug)
			unit:Kill(false, -1)
		elseif not unit:IsDead() then
			if unit:GetDomainType() == DomainTypes.DOMAIN_AIR then
				table.insert(Air, { Unit = unit, XP = unit:GetExperience() })
			elseif unit:GetDomainType() == DomainTypes.DOMAIN_SEA then
				table.insert(Sea, { Unit = unit, XP = unit:GetExperience() })
			else
				table.insert(Land, { Unit = unit, XP = unit:GetExperience() })
			end
		end
	end
	table.sort(Air, function(a,b) return a.XP < b.XP end)
	table.sort(Sea, function(a,b) return a.XP < b.XP end)
	table.sort(Land, function(a,b) return a.XP < b.XP end)

	-- Air Units
	Dprint("   - Air units ...", bDebug)
	local countUnit = 0
	for i, data in ipairs(Air) do
		countUnit = countUnit + 1					
		Dprint("     - " .. data.Unit:GetName(), bDebug )
		if data.Unit:IsFighting() then
			Dprint("       - Is Fighting, can't be transfered, leave alone...", bDebug )
						
		elseif data.Unit:IsDead() then
			Dprint("       - Is Dead, can't be transfered, leave alone...", bDebug )

		elseif countUnit > 10 then -- military restriction
			Dprint("       - Can't have more than 10 units, disbanded...", bDebug )
			data.Unit:Kill(false, -1)

		elseif i == 1 then -- save the best for the player
			data.Unit:SetXY(84,12) -- PALMYRA
		else
			local rand = math.random( 1, 100 )
			CleanOrdersRED (data.Unit)					
			if rand <= 5 and EnglandCity then -- 5% chance to flew to England							
				Dprint("       - goes to England ", bDebug )
				data.Unit:SetXY(iEnglandCityX, iEnglandCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iEngland)
			elseif rand <= 30 and AlgeriaCity then -- 25% to Algeria
				Dprint("       - goes to Algeria ", bDebug )
				data.Unit:SetXY(iAlgeriaCityX, iAlgeriaCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iAlgeria)
			elseif rand <= 50 and TunisiaCity then -- 20% to Tunisia
				Dprint("       - goes to Tunisia ", bDebug )
				data.Unit:SetXY(iTunisiaCityX, iTunisiaCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iTunisia)
			elseif rand <= 70 and MoroccoCity then -- 20% to Morocco
				Dprint("       - goes to Morocco ", bDebug )
				data.Unit:SetXY(iMoroccoCityX, iMoroccoCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iMorocco)
			elseif rand <= 95 and SyriaCity then -- 25% to Syria
				Dprint("       - goes to Syria ", bDebug )
				data.Unit:SetXY(iSyriaCityX, iSyriaCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iSyria)
			elseif LebanonCity then -- 5% to Lebanon
				Dprint("       - goes to Lebanon ", bDebug )
				data.Unit:SetXY(iLebanonCityX, iLebanonCityY)
				local newUnit = ChangeUnitOwner (data.Unit, iLebanon)
			end
		end
					
		Dprint("      - done for " .. data.Unit:GetName(), bDebug )
	end
	coroutine.yield()
				
	-- Land Units
	Dprint("   - Land units ...", bDebug)
	countUnit = 0 -- reset counter
	for i, data in ipairs(Land) do
		countUnit = countUnit + 1					
		Dprint("     - " .. data.Unit:GetName(), bDebug )
		if data.Unit:IsFighting() then
			Dprint("       - Is Fighting, can't be transfered, leave alone...", bDebug )
						
		elseif data.Unit:IsDead() then
			Dprint("       - Is Dead, can't be transfered, leave alone...", bDebug )

		elseif countUnit > 10 then -- military restriction
			Dprint("       - Can't have more than 10 units, disbanded...", bDebug )
			data.Unit:Kill(false, -1)

		elseif i == 1 then -- save the best for the player
			data.Unit:SetXY(84,12) -- PALMYRA
		elseif data.Unit:GetUnitType() == FR_LEGION then -- Special treatment for Legion
			local rand = math.random( 1, 100 )
			CleanOrdersRED (data.Unit)
			if rand <= 25 then
				Dprint("       - goes to Algeria ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iAlgeria)
				newUnit:SetXY(iAlgeriaCityX, iAlgeriaCityY)
			elseif rand <= 50 then
				Dprint("       - goes to Syria ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iSyria)
				newUnit:SetXY(iSyriaCityX, iSyriaCityY)
			else
				data.Unit:SetXY(84,12) -- PALMYRA
			end
		else
			local rand = math.random( 1, 100 )
					
			if rand <= 5 and EnglandCity then -- 5% chance to flew to England
				Dprint("       - goes to England ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iEngland)
				Dprint("       - owner changed ", bDebug )
				newUnit:SetXY(iEnglandCityX, iEnglandCityY)
				Dprint("       - teleportation done ", bDebug )
			elseif rand <= 30 and AlgeriaCity then -- 25% to Algeria
				Dprint("       - goes to Algeria ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iAlgeria)
				newUnit:SetXY(iAlgeriaCityX, iAlgeriaCityY)
			elseif rand <= 50 and TunisiaCity then -- 20% to Tunisia
				Dprint("       - goes to Tunisia ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iTunisia)
				newUnit:SetXY(iTunisiaCityX, iTunisiaCityY)
			elseif rand <= 70 and MoroccoCity then -- 20% to Morocco
				Dprint("       - goes to Morocco ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iMorocco)
				newUnit:SetXY(iMoroccoCityX, iMoroccoCityY)
			elseif rand <= 95 and SyriaCity then -- 25% to Syria
				Dprint("       - goes to Syria ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iSyria)
				newUnit:SetXY(iSyriaCityX, iSyriaCityY)
			elseif LebanonCity then -- 5% to Lebanon
				Dprint("       - goes to Lebanon ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iLebanon)
				newUnit:SetXY(iLebanonCityX, iLebanonCityY)
			--else -- Vichy metropole force
				--local newUnit = ChangeUnitOwner (data.Unit, iVichy)
				--newUnit:SetXY(27, 39) -- VICHY
			end
		end
		Dprint("      - done for " .. data.Unit:GetName(), bDebug )
	end
	coroutine.yield()

	-- Fleet is simply split in 2	
	Dprint("   - Sea units ...", bDebug)		
	for i, data in ipairs(Sea) do
		Dprint("     - " .. data.Unit:GetName() , bDebug)	
		CleanOrdersRED (data.Unit)
		-- save the best for the player
		if data.Unit:IsFighting() then
			Dprint("       - Is Fighting, can't be transfered, leave alone...", bDebug )
						
		elseif data.Unit:IsDead() then
			Dprint("       - Is Dead, can't be transfered, leave alone...", bDebug )

		elseif i == 1 then
			-- do nothing, become Free France
		else
			local rand = math.random( 1, 100 )					
			if rand <= 75 then -- 75% chance to follow governement in Vichy
				Dprint("       - goes to Vichy ", bDebug )
				local newUnit = ChangeUnitOwner (data.Unit, iVichy)
			end
		end
					
		Dprint("      - done for " .. data.Unit:GetName(), bDebug )
	end
	coroutine.yield()

	Dprint("- Change (captured by french) cities ownership ...", bDebug)	
	for city in pFrance:Cities() do  -- todo : handle french owned cities in colonies
		local plot = city:Plot()
		local plotKey = GetPlotKey ( plot )
		local originalOwner = GetPlotFirstOwner(plotKey)
		if originalOwner ~= iFrance then -- liberate cities captured by France
			Dprint(" - liberate city captured by France: " .. city:GetName(), bDebug )
			local originalPlayer = Players[originalOwner]
			EscapeUnitsFromPlot(plot)			
			coroutine.yield()
			originalPlayer:AcquireCity(city, false, true)
			coroutine.yield()		
		end
	end

	Dprint("Updating territory map ...", bDebug)	
	for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
		local plot = Map.GetPlotByIndex(iPlotLoop)
		local x = plot:GetX()
		local y = plot:GetY()
		local ownerID = plot:GetOwner()
		-- check only owned plot...
		if (ownerID ~= -1) then
			local plotKey = GetPlotKey ( plot )
			local originalOwner = GetPlotFirstOwner(plotKey)

			-- restore french colonies territory
			if (originalOwner ~= ownerID) and (originalOwner == iAlgeria or originalOwner == iMorocco or originalOwner == iSyria or originalOwner == iTunisia or originalOwner == iLebanon) then
				plot:SetOwner(originalOwner, -1 )
				if plot:IsCity() then
					local city = plot:GetPlotCity()
					EscapeUnitsFromPlot(plot)
					coroutine.yield()
					Players[originalOwner]:AcquireCity(city, false, true)
					coroutine.yield()
				end

			-- liberate plot captured by France
			elseif originalOwner ~= iFrance and ownerID == iFrance then
				plot:SetOwner(originalOwner, -1 ) 

			-- occupied territory
			elseif ownerID ~= iVichy and originalOwner == iFrance and ((x < 24 and y > 32) or (y > 42 and x < 33)) then 
				--Dprint("(".. x ..",".. y ..") = Plot in occupied territory")
				if plot:IsCity() and ownerID ~= iAxis then -- handle already captured french cities
					local city = plot:GetPlotCity()
					EscapeUnitsFromPlot(plot)
					coroutine.yield()
					pAxis:AcquireCity(city, false, true)
					coroutine.yield()
				else
					plot:SetOwner(iAxis, -1 ) 
				end

			-- Vichy territory
			elseif originalOwner == iFrance and ((y > 32 and x < 32))  then 
				--Dprint("(".. x ..",".. y ..") = Plot in Vichy territory")
				if plot:IsCity() and ownerID ~= iVichy then
					local city = plot:GetPlotCity()
					EscapeUnitsFromPlot(plot)
					coroutine.yield()
					Players[iVichy]:AcquireCity(city, false, true)
					coroutine.yield()
				else
					plot:SetOwner(iVichy, -1 ) 
				end

			-- Nice, Ajaccio region to Italy
			elseif originalOwner == iFrance and (y > 26 and x > 31 and y < 38 and x < 36) then
				--Dprint("(".. x ..",".. y ..") = Plot in Italy occupied territory")
				if plot:IsCity() and ownerID ~= iItaly then
					local city = plot:GetPlotCity()
					EscapeUnitsFromPlot(plot)
					coroutine.yield()
					Players[iItaly]:AcquireCity(city, false, true)
					coroutine.yield()
				else
					plot:SetOwner(iItaly, -1 ) 
				end

			-- Metz, Strasbourg region to Germany
			elseif originalOwner == iFrance and (y > 39 and x > 31 and y < 47 and x < 37) then 
				--Dprint("(".. x ..",".. y ..") = Plot in Germany occupied territory")
				if plot:IsCity() and ownerID ~= iGermany then
					local city = plot:GetPlotCity()
					EscapeUnitsFromPlot(plot)
					coroutine.yield()
					pGermany:AcquireCity(city, false, true)
					coroutine.yield()
				else
					plot:SetOwner(iGermany, -1 ) 
				end
			end
		end
	end
	coroutine.yield()
				
	-- change minor diplomacy
	local teamGermany = Teams[ pGermany:GetTeam() ]
	local teamItaly = Teams[ pItaly:GetTeam() ]
	local teamFrance = Teams[ pFrance:GetTeam() ]

	-- Change relation before declaring war or after peace !
				
	Dprint("Updating relations ...", bDebug)	

	pVichy:ChangeMinorCivFriendshipWithMajor( iGermany, 50 )
	pVichy:ChangeMinorCivFriendshipWithMajor( iItaly, 50 )
				
	pSyria:ChangeMinorCivFriendshipWithMajor( iFrance, - pSyria:GetMinorCivFriendshipWithMajor(iFrance) )
	pSyria:ChangeMinorCivFriendshipWithMajor( iEngland, - pSyria:GetMinorCivFriendshipWithMajor(iEngland) )
	pLebanon:ChangeMinorCivFriendshipWithMajor( iFrance, - pLebanon:GetMinorCivFriendshipWithMajor(iFrance) )
	pLebanon:ChangeMinorCivFriendshipWithMajor( iEngland, - pLebanon:GetMinorCivFriendshipWithMajor(iEngland) )
	
	coroutine.yield()
				
	Dprint("Updating war/peace ...", bDebug)	
			
	DeclarePermanentWar(iFrance, iSyria)
	coroutine.yield()
	teamGermany:MakePeace( pSyria:GetTeam() )
	coroutine.yield()
	teamItaly:MakePeace( pSyria:GetTeam() )
	coroutine.yield()
	pSyria:ChangeMinorCivFriendshipWithMajor( iGermany, 50 - pSyria:GetMinorCivFriendshipWithMajor(iGermany) )
	pSyria:ChangeMinorCivFriendshipWithMajor( iItaly, 50 - pSyria:GetMinorCivFriendshipWithMajor(iItaly) )
				
	DeclarePermanentWar(iFrance, iLebanon) -- wait for Operation Torch
	teamGermany:MakePeace( pLebanon:GetTeam() )
	coroutine.yield()
	teamItaly:MakePeace( pLebanon:GetTeam() )
	coroutine.yield()
	pLebanon:ChangeMinorCivFriendshipWithMajor( iGermany, 50 - pLebanon:GetMinorCivFriendshipWithMajor(iGermany) )
	pLebanon:ChangeMinorCivFriendshipWithMajor( iItaly, 50 - pLebanon:GetMinorCivFriendshipWithMajor(iItaly) )
	
	coroutine.yield()
				
	Dprint("Finalizing Fall of France ...", bDebug)	

	-- remove resistance in Axis occupied cities that were french
	for city in pGermany:Cities() do
		local plot = city:Plot()
		local plotKey = GetPlotKey ( plot )
		local originalOwner = GetPlotFirstOwner(plotKey)
		if originalOwner == iFrance then
			Dprint(" - Remove resistance in captured french city: " .. city:GetName(), bDebug )
			if city:GetResistanceTurns() > 0 then
				city:ChangeResistanceTurns(-city:GetResistanceTurns())
			end
		end
	end
	coroutine.yield()

	for city in pItaly:Cities() do
		local plot = city:Plot()
		local plotKey = GetPlotKey ( plot )
		local originalOwner = GetPlotFirstOwner(plotKey)
		if originalOwner == iFrance then
			Dprint(" - Remove resistance in captured french city: " .. city:GetName(), bDebug )
			if city:GetResistanceTurns() > 0 then
				city:ChangeResistanceTurns(-city:GetResistanceTurns())
			end
		end
	end
	coroutine.yield()

	for city in pVichy:Cities() do
		local plot = city:Plot()
		local plotKey = GetPlotKey ( plot )
		local originalOwner = GetPlotFirstOwner(plotKey)
		if originalOwner == iFrance then
			Dprint(" - Remove resistance in captured french city: " .. city:GetName(), bDebug )
			if city:GetResistanceTurns() > 0 then
				city:ChangeResistanceTurns(-city:GetResistanceTurns())
			end
		end
	end
	coroutine.yield()	

	-- french may try to restart...
	if Game.GetActivePlayer() ~= iFrance then
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pFrance:GetName() .. " has fled from Paris with all the gold of France promising to continue the fight from french colonies.", pFrance:GetName() .. " in exil !", -1, -1)
	end
	pFrance:SetGold(pFrance:GetGold() + 5000)


	Dprint("Fall of France event completed...", bDebug)	
end

function ConvertToFreeFrance (iAttackingPlayer, iAttackingUnit, attackerDamage, attackerFinalDamage, attackerMaxHP, iDefendingPlayer, iDefendingUnit, defenderDamage, defenderFinalDamage, defenderMaxHP)

	local franceID = GetPlayerIDFromCivID (FRANCE, false, true)
	if (FranceHasFallen() and (AreSameSide(iAttackingPlayer, franceID) or AreSameSide(iDefendingPlayer, franceID))) then -- Free France or an ally is attacking

		if iAttackingUnit > 0 and iDefendingUnit > 0 then
			local attPlayer = Players[iAttackingPlayer]
			local defPlayer = Players[iDefendingPlayer]
			local attUnit = attPlayer:GetUnitByID( iAttackingUnit )
			local defUnit = defPlayer:GetUnitByID( iDefendingUnit )
			if not (attUnit and defUnit) then -- One can be dead...
				return
			end
			local attUnitKey =  GetUnitKey(attUnit)
			local attUnitData = MapModData.RED.UnitData[attUnitKey]
			local defUnitKey =  GetUnitKey(defUnit)
			local defUnitData = MapModData.RED.UnitData[defUnitKey]
			if not attUnitData then
				Dprint ("ERROR : attUnitData is NIL in ConvertToFreeFrance, unit key = " .. tostring(attUnitKey)) -- how ?
				return
			end
			
			if not defUnitData then
				Dprint ("ERROR : defUnitData is NIL in ConvertToFreeFrance, unit key = " .. tostring(defUnitKey))
				return
			end

			if (attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and defUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and defUnitData) then
				if AreSameSide(iAttackingPlayer, franceID) and defUnitData.BuilderID == franceID then -- ally attacks old french unit, try to convert
					Dprint ("Ally unit is attacking a Vichy France unit")
					local rand = math.random( 1, 200 )
					if iAttackingPlayer == franceID then
						rand = (rand * 0.5)
					end

					local diffDamage = attackerDamage - defenderDamage
					local defenderHealth = defenderMaxHP - defenderFinalDamage
					local defenderHealthRatio =  defenderHealth / defenderMaxHP * rand -- 0 to 100
					local damageRatio = diffDamage * rand  -- (- diffDamage * 100) to (diffDamage * 100)

					if defenderHealth > 0 and (defenderHealthRatio < 10 or damageRatio < - 100) then
						-- chance are relative to lower health of old unit or low damage received on defeat
						Events.GameplayAlertMessage(defUnit:GetName() .. " has joined Free France Army after a fight against " .. attUnit:GetNameNoDesc() )
						local newUnit = ChangeUnitOwner (defUnit, franceID)
					end
				elseif AreSameSide(iDefendingPlayer, franceID) and attUnitData.BuilderID == franceID then -- ally defend against old french unit, try to convert
					Dprint ("Vichy France unit is attacking an ally unit")
					local rand = math.random( 1, 200 )
					if iDefendingPlayer == franceID then
						rand = (rand * 0.5)
					end

					local diffDamage = defenderDamage - attackerDamage
					local attHealth = attackerMaxHP - attackerFinalDamage
					local attHealthRatio =  attHealth / attackerMaxHP * rand -- 0 to 100
					local damageRatio = diffDamage * rand  -- (- diffDamage * 100) to (diffDamage * 100)

					if attHealth > 0 and (attHealthRatio < 10 or damageRatio < - 100) then
						-- chance are relative to lower health of old unit or low damage received on defeat
						Events.GameplayAlertMessage(attUnit:GetName() .. " has joined Free France Army after a fight against " .. defUnit:GetNameNoDesc() )
						local newUnit = ChangeUnitOwner (defUnit, franceID)
					end

				end
			end
		end
	end
end
-- add to Events.EndCombatSim in main scenario Lua

function ColonyReconquest(hexPos, playerID, cityID, newPlayerID)
	local cityPlot = Map.GetPlot( ToGridFromHex( hexPos.x, hexPos.y ) )

	local x, y = ToGridFromHex( hexPos.x, hexPos.y )
	local civID = GetCivIDFromPlayerID(newPlayerID, false)

	if FranceHasFallen() and g_Allied[civID]
		and ( (x == 80 and y == 9) -- Damascus
		or (x == 33 and y == 17) -- Tunis
		or (x == 78 and y == 10) -- Beiruth
		or (x == 7 and y == 18) -- Rabat
		or (x == 21 and y == 21) ) -- Alger
		then -- Allies have conquered an old colony capital city	
				
		local colony = Players[playerID]

		EscapeUnitsFromPlot(cityPlot) -- remove the capturing unit from the plot before reversing city ownership...

		local saveStr = colony:GetName() .. "HasBeenLiberated"
		
		local savedData = Modding.OpenSaveData()
		local alreadyLiberated = savedData.GetValue(saveStr)
		
		if alreadyLiberated ~= 1 then

			local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
			local pItaly = Players[iItaly]

			local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
			local pGermany = Players[iGermany]
				
			local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
			local pFrance = Players[iFrance]

			local iEngland = GetPlayerIDFromCivID (ENGLAND, false, true)
			local pEngland = Players[iEngland]
			
			Dprint ("-------------------------------------")
			Dprint ("Scripted Event : Liberation of " .. colony:GetName())

			for unit in colony:Units() do
				if not unit:IsDead() then
					if unit:GetOriginalOwner() == iFrance then
						local newUnit = ChangeUnitOwner (unit, iFrance)
					end
				end
			end

			Dprint("Updating territory map ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local ownerID = plot:GetOwner()
				-- check only owned plot...
				if (ownerID ~= -1) then
					local plotKey = GetPlotKey ( plot )
					local originalOwner = GetPlotFirstOwner(plotKey)
					if (originalOwner ~= ownerID) and (originalOwner == playerID) then -- restore french colony territory
						plot:SetOwner(originalOwner, -1 )
						if plot:IsCity() then
							local city = plot:GetPlotCity()
							EscapeUnitsFromPlot(plot)
							Players[originalOwner]:AcquireCity(city, false, true)
						end
					end
				end
			end
				
			-- change diplomacy
			local teamGermany = Teams[ pGermany:GetTeam() ]
			local teamItaly = Teams[ pItaly:GetTeam() ]
			local teamFrance = Teams[ pFrance:GetTeam() ]
			local teamEngland = Teams[ pEngland:GetTeam() ]
				
			colony:ChangeMinorCivFriendshipWithMajor( iFrance, 100 - colony:GetMinorCivFriendshipWithMajor(iFrance) )
			colony:ChangeMinorCivFriendshipWithMajor( iEngland, 50 - colony:GetMinorCivFriendshipWithMajor(iEngland) )

			teamFrance:MakePeace( colony:GetTeam() )
			teamEngland:MakePeace( colony:GetTeam() )
			--teamGermany:DeclareWar( colony:GetTeam() )
			--teamItaly:DeclareWar( colony:GetTeam() )
			DeclarePermanentWar(iGermany, playerID)
			DeclarePermanentWar(iItaly, playerID)
			
			colony:ChangeMinorCivFriendshipWithMajor( iGermany, -60 - colony:GetMinorCivFriendshipWithMajor(iFrance) )
			colony:ChangeMinorCivFriendshipWithMajor( iItaly, -60 - colony:GetMinorCivFriendshipWithMajor(iEngland) )

			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, colony:GetName() .. " has changed governement and joins the Allies.", colony:GetName() .. " liberated !", -1, -1)

			savedData.SetValue(saveStr, 1)
		end
	end
end
-- add to Events.SerialEventCityCaptured in main scenario Lua

function IsFranceNeedFighter()
	local bDebug = false
	local germanFighters = CountUnitClassAlive(CLASS_FIGHTER, GetPlayerIDFromCivID(GERMANY, false))
	local frenchFighters = CountUnitClassAlive(CLASS_FIGHTER, GetPlayerIDFromCivID(FRANCE, false))	
	Dprint ("-------------------------------------", bDebug)
	Dprint ("Check if France need Fighters...", bDebug)
	Dprint (" - Germany fighters = " .. tostring(germanFighters), bDebug)
	Dprint (" - France fighters = " .. tostring(frenchFighters), bDebug)
	Dprint (" - France want at least 3/4 of Germany Fighters = " .. tostring(germanFighters*3/4), bDebug)
	if (germanFighters*3/4) > frenchFighters then
		return true
	end
	return false
end

-----------------------------------------
-- Poland
-----------------------------------------


function FallOfPoland(hexPos, playerID, cityID, newPlayerID)
  if ALLOW_SCRIPTED_EVENTS then
	local cityPlot = Map.GetPlot( ToGridFromHex( hexPos.x, hexPos.y ) )
	local bDebug = false	
	local x, y = ToGridFromHex( hexPos.x, hexPos.y )
	local civID = GetCivIDFromPlayerID(newPlayerID, false)
	local pAxis = Players[newPlayerID]
	if x == 53 and y == 48 then -- city of Warsaw 
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Warsaw Captured !")		

		if (civID == GERMANY or civID == USSR) then -- captured by Germany or USSR...
			Dprint("- Captured by Germany or USSR ...")

			local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
			local pUSSR = Players[iUSSR]

			local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
			local pGermany = Players[iGermany]

			local team = Teams[ pGermany:GetTeam() ]
			if not team:IsAtWar( pUSSR:GetTeam() ) then
				Dprint("- Both still at peace ...")
				local pWarsaw = cityPlot:GetPlotCity()
				local savedData = Modding.OpenSaveData()
				local iValue = savedData.GetValue("PolandHasFalled")
				if (iValue ~= 1) then
					Dprint("- First occurence, launching Fall of Poland script ...")

					local iPoland = GetPlayerIDFromCivID (POLAND, true, true)
					local pPoland = Players[iPoland]

					-- todo :
					-- save from units for UK
					--Dprint("- Change Poland units ownership ...")	
					for unit in pPoland:Units() do 
						--local newUnit = ChangeUnitOwner (unit, iEngland)
						unit:Kill(false, -1)
					end						

					Dprint("- Change (captured by) Poland cities ownership ...")	
					for city in pPoland:Cities() do  
						local plot = city:Plot()
						local plotKey = GetPlotKey ( plot )
						local originalOwner = GetPlotFirstOwner(plotKey)
						if originalOwner ~= iPoland then
							Dprint(" - liberate city captured by Poland: " .. city:GetName(), bDebug )
							local originalPlayer = Players[originalOwner]
							EscapeUnitsFromPlot(plot)
							originalPlayer:AcquireCity(city, false, true)
						end
					end

					Dprint("Updating territory map ...")	
					for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
						local plot = Map.GetPlotByIndex(iPlotLoop)
						local x = plot:GetX()
						local y = plot:GetY()
						local ownerID = plot:GetOwner()
						-- check only owned plot...
						if (ownerID ~= -1) then
							local plotKey = GetPlotKey ( plot )
							local originalOwner = GetPlotFirstOwner(plotKey)

							if originalOwner ~= iPoland and ownerID == iPoland then -- liberate plot captured by Poland
								plot:SetOwner(originalOwner, -1 ) 

							elseif originalOwner == iPoland and (x > 46 and x < 51)  then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end

							elseif originalOwner == iPoland and (x > 50 and x < 55) then -- Central territory
								if plot:IsCity() and ownerID ~= newPlayerID then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pAxis:AcquireCity(city, false, true)
								else
									plot:SetOwner(newPlayerID, -1 ) 
								end 

							elseif originalOwner == iPoland and (x > 54 and x < 61) then -- USSR Territory
								if plot:IsCity() and ownerID ~= iUSSR then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pUSSR:AcquireCity(city, false, true)
								else
									plot:SetOwner(iUSSR, -1 ) 
								end 
							end
						end
					end				

					-- remove resistance 
					for city in pGermany:Cities() do
						local plot = city:Plot()
						local plotKey = GetPlotKey ( plot )
						local originalOwner = GetPlotFirstOwner(plotKey)
						if originalOwner == iPoland then
							Dprint(" - Remove resistance in captured polish city: " .. city:GetName(), bDebug )
							if city:GetResistanceTurns() > 0 then
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							end
						end
					end

					for city in pUSSR:Cities() do
						local plot = city:Plot()
						local plotKey = GetPlotKey ( plot )
						local originalOwner = GetPlotFirstOwner(plotKey)
						if originalOwner == iPoland then
							Dprint(" - Remove resistance in captured polish city: " .. city:GetName(), bDebug )
							if city:GetResistanceTurns() > 0 then
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							end
						end
					end
				
					Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "The Polish governement has fled the country, Poland has fallen under German and Soviet control.", "Poland has fallen !", cityPlot:GetX(), cityPlot:GetY())

					savedData.SetValue("PolandHasFalled", 1)
					Dprint("Fall of Poland event completed...", bDebug)	
				end
			end
		end
	end
  end
end
-- add to Events.SerialEventCityCaptured in main scenario Lua

function CapitulationCheck(hexPos, playerID, cityID, newPlayerID)
	
	local original_player = Players[playerID]
	local new_player = Players[newPlayerID]
	if(original_player:IsMinorCiv()) then --If it's a minor civ, we need to capture all the cities to get all the territory automatically
		local has_cities = false
		for city in original_player:Cities() do
			if(city) then
				has_cities = true
			end
		end
		if(has_cities) then
			return
		end
		
		for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
			local plot = Map.GetPlotByIndex(iPlotLoop)
			local ownerID = plot:GetOwner()
			if(ownerID ~= -1) then
				plot:SetOwner(new_player, -1)
			end
		end
	else --Major civ, need to capture a capital city that wasn't the original capital
		local captured_city = new_player:GetCityByID(cityID)
			if(captured_city:IsCapital() and captured_city:IsOriginalCapital() != true) then
				for city in original_player:Cities() do
					new_player:AcquireCity(city, true, true)
				end
				
				for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
					local plot = Map.GetPlotByIndex(iPlotLoop)
					local ownerID = plot:GetOwner()
					if(ownerID ~= -1) then
						plot:SetOwner(new_player, -1)
					end
				end
			end
	end
end
-- add to Events.SerialEventCityCaptured in main scenario Lua

-----------------------------------------
-- Denmark
-----------------------------------------
function FallOfDenmark(iAttackingUnit, defendingPlotKey, iAttackingPlayer, iDefendingPlayer)

	local pAxis = Players[iAttackingPlayer]
	local pAttackingUnit = pAxis:GetUnitByID( iAttackingUnit )
	local cityPlot = GetPlotFromKey ( defendingPlotKey )
	local x = cityPlot:GetX()
	local y = cityPlot:GetY()
	
	local bDebug = false	

	local civID = GetCivIDFromPlayerID(iAttackingPlayer, false)

	if x == 43 and y == 57 or x == 40 and y == 59 then -- Copenhagen, Aalborg 
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Denmark attacked !")		

		if (civID == GERMANY or civID == ITALY) then -- attacked by Germany or Italy...
			Dprint("- Attacked by Germany or Italy ...")

			local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
			local pUK = Players[iUK]

			local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
			local pGermany = Players[iGermany]

			local savedData = Modding.OpenSaveData()
			local iValue = savedData.GetValue("DenmarkHasFalled")
			if (iValue ~= 1) then
				Dprint("- First occurence, launching Fall of Denmark script ...")

				local iDenmark = GetPlayerIDFromCivID (DENMARK, true, true)
				local pDenmark = Players[iDenmark]

				for unit in pDenmark:Units() do 
					unit:Kill()
				end						

				Dprint("- Change (captured by) Denmark cities ownership ...")	-- really just in case !
				for city in pDenmark:Cities() do  
					local plot = city:Plot()
					local plotKey = GetPlotKey ( plot )
					local originalOwner = GetPlotFirstOwner(plotKey)
					if originalOwner ~= iDenmark then
						Dprint(" - liberate city captured by Denmark: " .. city:GetName(), bDebug )
						local originalPlayer = Players[originalOwner]
						EscapeUnitsFromPlot(plot)
						originalPlayer:AcquireCity(city, false, true)
					end
				end

				Dprint("Updating territory map ...")	
				for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
					local plot = Map.GetPlotByIndex(iPlotLoop)
					local x = plot:GetX()
					local y = plot:GetY()
					local ownerID = plot:GetOwner()
					-- check only owned plot...
					if (ownerID ~= -1) then
						local plotKey = GetPlotKey ( plot )
						local originalOwner = GetPlotFirstOwner(plotKey)

						if originalOwner ~= iDenmark and ownerID == iDenmark then -- liberate plot captured by Poland
							plot:SetOwner(originalOwner, -1 ) 

						elseif originalOwner == iDenmark and (x > 35)  then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end 

						elseif originalOwner == iDenmark and (x < 35) and ownerID == iDenmark then -- Denmark to UK
								if plot:IsCity() and ownerID ~= newPlayerID then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pUK:AcquireCity(city, false, true)
								else
									plot:SetOwner(iUK, -1 ) 
								end 

						end
					end
				end				

				-- remove resistance 
				for city in pGermany:Cities() do
					local plot = city:Plot()
					local plotKey = GetPlotKey ( plot )
					local originalOwner = GetPlotFirstOwner(plotKey)
					if originalOwner == iDenmark then
						Dprint(" - Remove resistance in captured dane city: " .. city:GetName(), bDebug )
						if city:GetResistanceTurns() > 0 then
							city:ChangeResistanceTurns(-city:GetResistanceTurns())
						end
					end
				end
				
				for city in pUK:Cities() do
					local plot = city:Plot()
					local plotKey = GetPlotKey ( plot )
					local originalOwner = GetPlotFirstOwner(plotKey)
					if originalOwner == iDenmark then
						Dprint(" - Remove resistance in captured dane city: " .. city:GetName(), bDebug )
						if city:GetResistanceTurns() > 0 then
							city:ChangeResistanceTurns(-city:GetResistanceTurns())
						end
					end
				end
				
				Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "To prevent civilian losses " .. pDenmark:GetName() .. " has surrender to Germany, Denmark has fallen under German control. Remaining Denmark territory is now under U.K. protection", pDenmark:GetName() .. " has fallen !", cityPlot:GetX(), cityPlot:GetY())

				savedData.SetValue("DenmarkHasFalled", 1)
				Dprint("Fall of Denmark event completed...", bDebug)	
			end
		end
	end
end
-- add to LuaEvents.OnCityAttacked in main scenario Lua

-----------------------------------------
-- United Kingdom
-----------------------------------------

function UKIsSafe()
	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local safe = true
	for x = 19, 30, 1 do
		for y = 50, 68, 1 do
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iUK and plot:GetOwner() ~= iUK then -- one of UK plot has been conquered
				safe = false 
			end
		end
	end 
	return safe
end

function IsSuezAlly()
	local suezPlot = GetPlot(73,2) -- Suez
	if suezPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
	end
end

function IsSuezOccupied()
	local suezPlot = GetPlot(73,2) -- Suez
	if suezPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return false
	else
		return true
	end
end

function IsUKNeedTank()
	local bDebug = false
	local germanTanks = CountUnitClassAlive(CLASS_TANK, GetPlayerIDFromCivID(GERMANY, false))
	local UKTanks = CountUnitClassAlive(CLASS_TANK, GetPlayerIDFromCivID(ENGLAND, false))	
	Dprint ("-------------------------------------", bDebug)
	Dprint ("Check if UK need Tanks...", bDebug)
	Dprint (" - Germany Tanks = " .. tostring(germanTanks), bDebug)
	Dprint (" - UK Tanks = " .. tostring(UKTanks), bDebug)
	Dprint (" - UK want at least 3/4 of Germany Tanks = " .. tostring(germanTanks*3/4), bDebug)
	if (germanTanks*3/4) > UKTanks then
		return true
	end
	return false
end

function IsSicilyOccupied()
	local CataniaPlot = GetPlot(42,17) -- Catania
	local PalermoPlot = GetPlot(40,19) -- Palermo

	if CataniaPlot:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) and PalermoPlot:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) then
		return false
	else
		return true
	end
end

function ReadyForOverlord()
	local bDebug = false
	if not UKIsSafe() then
		Dprint ("UK is not safe", bDebug)
		return false
	end
	if not NorthFranceInvaded() then
		Dprint ("North France is not invaded", bDebug)
		return false
	end
	Dprint ("Ready for Overlord", bDebug)
	return true
end


-----------------------------------------
-- Italy
-----------------------------------------

function ItalyIsSafe()
	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local safe = 6
	local lostPlot = 0
	for x = 33, 48, 1 do
		for y = 16, 38, 1 do
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iItaly and plot:GetOwner() ~= iItaly then -- one of Italy plot has been conquered
				lostPlot = lostPlot + 1 
			end
		end
	end 
	local bIsSafe = lostPlot < safe
	return bIsSafe
end

function IsLibyaAlly()
	local Benghazi = GetPlot(51,5):GetPlotCity()		-- Benghazi
	local Tripoli = GetPlot(39,7):GetPlotCity()			-- Tripoli
	if (Benghazi:GetOwner() == GetPlayerIDFromCivID (LIBYA, true, true) and (Tripoli:GetOwner() == GetPlayerIDFromCivID (LIBYA, true, true) )) then
		return true
	else
		return false
	end
end



-----------------------------------------
-- Germany
-----------------------------------------

function GermanyIsSafe()
	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local safe = 10
	local lostPlot = 0
	for x = 35, 79, 1 do
		for y = 39, 55, 1 do
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iGermany and plot:GetOwner() ~= iGermany then -- one of Germany plot has been conquered
				lostPlot = lostPlot + 1 
			end
		end
	end 
	
	local bIsSafe = lostPlot < safe
	return bIsSafe
end


-----------------------------------------
-- USSR
-----------------------------------------

function BalticumAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19400616 <= turnDate and 19400616 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Balticum Annexed !")

		local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
		local pUSSR = Players[iUSSR]
			
		local team = Teams[ pUSSR:GetTeam() ]
		Dprint("- USSR Selected ...")

		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("BalticumHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Balticum script ...")

			local iBaltic = GetPlayerIDFromCivID (BALTIC, true, true)
			local pBaltic = Players[iBaltic]

			for unit in pBaltic:Units() do 
				unit:Kill()
			end							

			Dprint("- Change Baltic cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iBaltic and originalOwner ~= iBaltic then -- liberate cities captured by Baltic
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iBaltic then
						if (x > 1 and x < 115)  then -- USSR
							Dprint(" - " .. city:GetName() .. " is in Russian sphere...")	
							if city:GetOwner() ~= iUSSR then 
								pUSSR:AcquireCity(city, false, true)
								city:SetPuppet(false)
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							else -- just remove resistance if city was already occupied
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							end
						end				
					end
				end
			end

			Dprint("Updating territory map ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local ownerID = plot:GetOwner()
				-- check only owned plot...
				if (ownerID ~= -1) then
					local plotKey = GetPlotKey ( plot )
					local originalOwner = GetPlotFirstOwner(plotKey)
					if originalOwner ~= iBaltic and ownerID == iBaltic then -- liberate plot captured by Baltic
						plot:SetOwner(originalOwner, -1 ) 								 
					elseif originalOwner == iBaltic and (x > 1 and x < 115)  then -- USSR territory
						plot:SetOwner(iUSSR, -1 ) 
					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION,  "Annexation of Estonia, Latvia and Lithuania!", "The Baltic States have fallen to USSR!",-1, -1)
			savedData.SetValue("BalticumHasFalled", 1)
		end
	end
end

function StalingradOccupied()
	local Stalingrad = GetPlot(84, 48):GetPlotCity()		-- Stalingrad
	if (Stalingrad:IsOccupied()) then
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- Lend Lease Act
----------------------------------------------------------------------------------------------------------------------------

function LendLeaseAct()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19410311 <= turnDate and 19410311 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Lend Lease Act in Affect !")		
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION,  "The United States of America has passed the Lend Lease Act - France, the United Kingdom and the USSR will recieve extra convoys.", "Lend Lease Act Passed!", -1, -1)
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- Convoy routes
----------------------------------------------------------------------------------------------------------------------------

-- first define the condition for convoys ... 

function IsRouteOpenUStoFrance()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to France", bDebug)
	if FranceHasFallen() then
		Dprint("      - France has fallen...", bDebug)
		return false
	end
	if not AreAtWar( GetPlayerIDFromCivID(FRANCE, false), GetPlayerIDFromCivID(GERMANY, false)) then
		Dprint("      - France is not at war with Germany, no need for reinforcement...", bDebug)
		return false
	end
	return true
end
function IsRouteOpenSueztoFrance()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Suez to France", bDebug)
	if IsSuezOccupied() or FranceHasFallen() then
		return false
	end
	return true
end
function IsRouteOpenUStoUK()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to UK", bDebug)

	if not AreAtWar( GetPlayerIDFromCivID(ENGLAND, false), GetPlayerIDFromCivID(GERMANY, false)) then
		Dprint("      - UK is not at war with Germany, no need for reinforcement...", bDebug)
		return false
	end
	return true
end
function IsRailOpenMurmansktoMoscow()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(USSR, false), GetPlayerIDFromCivID(GERMANY, false)) then
		Dprint("      - USSR is not at war with Germany, no need for reinforcement...", bDebug)
		return false
	end
	local plotMurmansk = GetPlot(65,85)
	local plotMoscow = GetPlot(72,58)
	local ussr = Players[GetPlayerIDFromCivID(USSR, false)]
	local bRoad = isPlotConnected( ussr , plotMurmansk, plotMoscow, "Railroad", false, nil , PathBlocked)
	if bRoad then
		Dprint("     - Rail from Murmansk to Moscow is open for USSR...", bDebug)
	else
		Dprint("     - Rail from Murmansk to Moscow is closed for USSR...", bDebug)
	end	
	return bRoad
end
function IsRailOpenRostowtoStalingrad()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(USSR, false), GetPlayerIDFromCivID(GERMANY, false)) then
		Dprint("      - USSR is not at war with Germany, no need for reinforcement...", bDebug)
		return false
	end
	local plotRostow = GetPlot(78,38)
	local plotStalingrad = GetPlot(84,48)
	local ussr = Players[GetPlayerIDFromCivID(USSR, false)]	
	local bRoad = isPlotConnected( ussr , plotRostow, plotStalingrad, "Railroad", false, nil , PathBlocked)	
	if bRoad then
		Dprint("     - Rail from Rostow to Stalingrad is open for USSR...", bDebug)
	else
		Dprint("     - Rail from Rostow to Stalingrad is closed for USSR...", bDebug)
	end
	return bRoad
end
function IsRouteOpenFinlandtoGermany()

	local bDebug = false

	local month = TurnToMonth()
	if month > 10 or month < 4 then
		return false -- assume North of Baltic Sea is frozen from November to Mars
	end
	Dprint("     - Baltic Sea is not frozen...", bDebug)
	
	local plotOulu = GetPlot(58,77)
	local plotInari = GetPlot(59,83)
	local germany = Players[GetPlayerIDFromCivID(GERMANY, false)]
	
	local bRoad = isPlotConnected( germany , plotOulu, plotInari, "Railroad", false, nil , PathBlocked)

	if bRoad then
		Dprint("     - Rail from Oulu to Inari is open for Germany...", bDebug)
	else
		Dprint("     - Rail from Oulu to Inari is closed for Germany...", bDebug)
	end

	return bRoad	
end
function IsRouteOpenNorwaytoGermany()
	
	local bDebug = false

	if IsRouteOpenFinlandtoGermany() or IsRouteOpenSwedentoGermany() then
		return false -- Use only if direct routes via Baltic are closed
	end
	Dprint("     - Baltic Sea routes are closed...", bDebug)

	local plotKiruna = GetPlot(53,81)
	local plotNarvik = GetPlot(51,85)
	local germany = Players[GetPlayerIDFromCivID(GERMANY, false)]

	-- No rail on CS cities, so check rail first, then road.
	local bRail = isPlotConnected( germany , plotKiruna, plotNarvik, "Railroad", false, nil , PathBlocked) 	
	if bRail then
		Dprint("     - Railroad from Kiruna to Narvik is open for Germany...", bDebug)
	else
		Dprint("     - Railroad from Kiruna to Narvik is closed for Germany...", bDebug)
	end
	return bRail	
end
function IsRouteOpenSwedentoGermany()

	local bDebug = false

	local month = TurnToMonth()
	if month > 10 or month < 4 then
		return false -- assume North of Baltic Sea is frozen from November to Mars
	end
	Dprint("     - Baltic Sea is not frozen...", bDebug)

	local plotKiruna = GetPlot(53,81)
	local plotLulea = GetPlot(55,78)
	local germany = Players[GetPlayerIDFromCivID(GERMANY, false)]
	
	local bRail = isPlotConnected( germany , plotKiruna, plotLulea, "Railroad", false, nil , PathBlocked)
	if bRail then
		Dprint("     - Railroad from Kiruna to Lulea is open for Germany...", bDebug)
	else
		Dprint("     - Railroad from Kiruna to Lulea is closed for Germany...", bDebug)
	end
	return bRail	
end
function IsRouteOpenUSAFtoUK1()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to UK for Air Force", bDebug)

	if not IsRouteOpenUStoUK() then
		return false
	end
	
	if not UKIsSafe() then
		return false
	end
	
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate < 19420301 or turnDate > 19421231 then		
		Dprint("     - not between march and december 1942...", bDebug)
		return false
	end

	local iUK = GetPlayerIDFromCivID(ENGLAND, false)
	if CountUnitTypeAlive (US_B17, iUK) + CountUnitTypeAlive (US_P40, iUK) > 10 then
		Dprint("     - too many USAF units in Europe...", bDebug)
		return false
	end	

	return true
end
function IsRouteOpenUStoFranceTroops1()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to France for Army", bDebug)

	if not IsRouteOpenUStoFrance() then
		return false
	end

	if not UKIsSafe() then -- priority to UK (reinforcement to France can be send from there once the danger is eliminated)
		return false
	end
	
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate < 19420301 or turnDate > 19421231 then		
		Dprint("     - not between march and december 1942...", bDebug)
		return false
	end

	local iFrance = GetPlayerIDFromCivID(FRANCE, false)
	local numUnitsUS = CountUnitTypeAlive (US_M24CHAFFEE, iFrance) + CountUnitTypeAlive (US_SHERMAN, iFrance) + CountUnitTypeAlive (US_M24CHAFFEE, iFrance) + CountUnitTypeAlive (US_MECH_INFANTRY, iFrance) + CountUnitTypeAlive (US_MARINES, iFrance) + CountUnitTypeAlive (US_INFANTRY, iFrance)
	if numUnitsUS > 30 then
		Dprint("     - too many US Army units in France...", bDebug)
		return false
	end	

	return true
end
function IsRouteOpenUStoUKTroops1()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to France for Army", bDebug)

	if not IsRouteOpenUStoUK() then
		return false
	end
	
	if UKIsSafe() then
		return false
	end
	
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate < 19420301 or turnDate > 19421231 then		
		Dprint("     - not between march and december 1942...", bDebug)
		return false
	end

	local iUK = GetPlayerIDFromCivID(ENGLAND, false)
	local numUnitsUS = CountUnitTypeAlive (US_M24CHAFFEE, iUK) + CountUnitTypeAlive (US_SHERMAN, iUK) + CountUnitTypeAlive (US_M24CHAFFEE, iUK) + CountUnitTypeAlive (US_MECH_INFANTRY, iUK) + CountUnitTypeAlive (US_MARINES, iUK) + CountUnitTypeAlive (US_INFANTRY, iUK)
	if numUnitsUS > 30 then
		Dprint("     - too many US Army units in UK...", bDebug)
		return false
	end	

	return true
end

-- define the transport functions that will be stocked in the g_Convoy table... 

function GetUStoFranceTransport()
	local rand = math.random( 1, 3 )
	local rand1 = math.random( 1, 3 )
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
	else 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	end
	return transport
end

function GetAfricatoFranceTransport()
	local rand = math.random( 1, 3 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 250} -- Reference is quantity of materiel, personnel or gold. For TRANSPORT_UNIT, Reference is the unit type ID
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 150}
	elseif rand == 3 then  
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	end
	return transport
end

function GetUStoUKTransport()
	local rand = math.random( 1, 3 )
	local rand1 = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 250} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 250}
	elseif IsUKNeedTank() then
		if turnDate < 19410101 then 
			transport = {Type = TRANSPORT_UNIT, Reference = UK_M3_GRANT}
		elseif turnDate < 19430601 or turnDate >= 19410101 then
			if rand1 == 1 then
				transport = {Type = TRANSPORT_UNIT, Reference = UK_M3_GRANT}
			elseif rand1 == 2 then 
				transport = {Type = TRANSPORT_UNIT, Reference = US_M7}			
			elseif rand1 > 2 then 
				transport = {Type = TRANSPORT_UNIT, Reference = US_SHERMAN}
			end		
		elseif turnDate >= 19430601 then
			if rand1 < 3 then
				transport = {Type = TRANSPORT_UNIT, Reference = US_SHERMAN_III}
			elseif rand1 == 3 then 
				transport = {Type = TRANSPORT_UNIT, Reference = US_SEXTON}
			elseif rand1 == 4 then  
				transport = {Type = TRANSPORT_UNIT, Reference = UK_ACHILLES}
			end		
		end
	else 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	end
	return transport
end

function GetSueztoUKTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 300}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function GetSueztoFranceTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 300}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function GetSueztoItalyTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 300}
	elseif rand > 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function GetAfricatoItalyTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 200} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 200}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}	
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300}
	end
	return transport
end

function GetFinlandtoGermanyTransport()
	local factor = 1
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate > 19410101 then		
		factor = 2
	end
	if turnDate > 19420101 then		
		factor = 3
	end
	if turnDate > 19430101 then		
		factor = 4
	end
	local rand = math.random( 1, 5 )
	local transport
	if rand < 4 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 250 * factor} 
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 250 * factor} 
	elseif rand == 5 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 250 * factor} 
			
	end
	return transport
end

function GetNorwaytoGermanyTransport()
	local factor = 1
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate > 19410101 then		
		factor = 2
	end
	if turnDate > 19420101 then		
		factor = 3
	end
	if turnDate > 19430101 then		
		factor = 4
	end
	local rand = math.random( 1, 5 )
	local transport
	if rand < 4 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300 * factor} 
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 250 * factor} 
	elseif rand == 5 then 
		transport = {Type = TRANSPORT_OIL, Reference = 250 * factor} 	
	end
	return transport
end

function GetSueztoUSSRTransport()
	local rand = math.random( 1, 3 )
	local rand1 = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	
	elseif rand == 3 then 
		if turnDate < 19410701 then 
			transport = {Type = TRANSPORT_OIL, Reference = 300 } 
		elseif turnDate >= 19410701 or turnDate < 19430601 then
			transport = {Type = TRANSPORT_OIL, Reference = 500 } 
		elseif turnDate >= 19430601 then
			transport = {Type = TRANSPORT_OIL, Reference = 1000 } 
		end
	end
	
	return transport
end

function GetUStoUSSRTransport()
	local transport
	local factor = 1
	local turn = Game.GetGameTurn()
	local turnDate = 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if turnDate > 19420101 then		
		factor = 2
	end
	if turnDate > 19430101 then		
		factor = 3
	end
	local rand = math.random( 1, 4 )
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300 * factor} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300 * factor}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = RU_MECH_INFANTRY}
	elseif rand == 4 then 
			transport = {Type = TRANSPORT_OIL, Reference = 300 * factor} 
	end
	return transport
end

function GetCaraibOilTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_OIL, Reference = 200} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 400}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	
	return transport
end

function GetSueztoGreeceTransport()
	local rand = math.random( 1, 5 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 300}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	end
	return transport
end

function GetUSAFtoUKTransport1()
	local rand = math.random( 1, 4 )
	local transport
	if rand < 3 then
		transport = {Type = TRANSPORT_UNIT, Reference = US_B17}
	else 
		transport = {Type = TRANSPORT_UNIT, Reference = US_P40}
	end
	return transport
end
function GetUStoEuropeTroops1()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_UNIT, Reference = US_M24CHAFFEE}
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_UNIT, Reference = US_SHERMAN}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = US_MECH_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_UNIT, Reference = US_MARINES}
	elseif rand > 4 then 
		transport = {Type = TRANSPORT_UNIT, Reference = US_INFANTRY}
	end
	return transport
end
function GetUStoEuropeArmyResources()
	local rand = math.random( 1, 3 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 1500} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 500}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 2000}
	end
	return transport
end

-- ... then define the convoys table
-- don't move those define from this files, they must be set AFTER the functions definition...

-- Route list
US_TO_FRANCE		= 1
US_TO_UK			= 2
AFRICA_TO_FRANCE	= 3
AFRICA_TO_ITALY		= 4
FINLAND_TO_GERMANY	= 5
SUEZ_TO_UK			= 6
SUEZ_TO_FRANCE		= 7
SUEZ_TO_ITALY		= 8
SUEZ_TO_USSR		= 9
US_TO_USSR			= 10
NORWAY_TO_GERMANY	= 11
SWEDEN_TO_GERMANY	= 12
SUEZ_TO_GREECE		= 13
CARAIB_TO_FRANCE	= 14
CARAIB_TO_UK		= 15
CARAIB_TO_GREECE	= 16
US_TO_UK_USAF1		= 17
US_TO_UK_USAF_RES	= 18
US_TO_FR_ARMY1		= 19
US_TO_FR_ARMY_RES	= 20
US_TO_UK_ARMY1		= 21

-- Convoy table
g_Convoy = { 
	[US_TO_FRANCE] = {
		Name = "US to France",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=21, Y=42}, {X=21, Y=45}, {X=29, Y=50}, {X=29, Y=34}, {X=19, Y=48}, {X=23, Y=48},}, -- La Rochelle, St Nazaire, Dunkerque, Marseille, Brest, Cherbourg
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFrance, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_UK] = {
		Name = "US to UK",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, {X=28, Y=65}, {X=24, Y=62}, {X=26, Y=61}, {X=28, Y=58},}, -- Plymouth, Liverpool, London, Aberdeen, Glasgow, Edinburgh, Newcastle
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK"},
		MaxFleet = 1,
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoUK,
		Transport = GetUStoUKTransport,
	},
	[AFRICA_TO_FRANCE] = {
		Name = "Africa to France",
		SpawnList = { {X=5, Y=18}, {X=22, Y=21}, {X=34, Y=18}, }, -- adjacent to Casablanca, Alger, Tunis
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=29, Y=34}, }, -- Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},
	[AFRICA_TO_ITALY] = {
		Name = "Africa to Italy",
		SpawnList = { {X=39, Y=8}, {X=51, Y=6}, }, -- adjacent to Tripoli, Benghazi
		RandomSpawn = true,
		DestinationList = { {X=44, Y=19}, {X=41, Y=25}, {X=39, Y=28}, {X=46, Y=24}, {X=35, Y=34},}, -- Reggio Calabria, Naples, Rome, Bari, Genova
		RandomDestination = false,
		CivID = ITALY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_ITALY"},
		MaxFleet = 1, 
		Frequency = 25,
		Condition = IsLibyaAlly, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoItalyTransport, -- Must refer to a function, remove this line to use the default function
	},
	[FINLAND_TO_GERMANY] = {
		Name = "Finland to Germany",
		SpawnList = { {X=57, Y=77}, }, -- adjacent to Oulu
		RandomSpawn = false,
		DestinationList = { {X=52, Y=53}, {X=46, Y=52}, {X=40, Y=55}, }, -- Konigsberg, Stettin, Kiel
		RandomDestination = false,
		CivID = GERMANY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_FINLAND_TO_GERMANY"},
		MaxFleet = 3, 
		Frequency = 50,
		Condition = IsRouteOpenFinlandtoGermany,
		Transport = GetFinlandtoGermanyTransport,
	},
	[SUEZ_TO_UK] = {
		Name = "Suez to UK",
		SpawnList = { {X=73, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, }, -- Plymouth, Liverpool, London
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_UK"},
		MaxFleet = 8,
		Frequency = 20, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoUKTransport,
	},
	[SUEZ_TO_FRANCE] = {
		Name = "Suez to France",
		SpawnList = { {X=73, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=33, Y=34}, {X=29, Y=34}, }, -- Nice, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_FRANCE"},
		MaxFleet = 5,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenSueztoFrance,
		Transport = GetSueztoFranceTransport,
	},
	[SUEZ_TO_ITALY] = {
		Name = "Suez to Italy",
		SpawnList = { {X=73, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=44, Y=19}, {X=41, Y=25}, {X=39, Y=28}, {X=46, Y=24}, {X=35, Y=34},}, -- Reggio Calabria, Naples, Rome, Bari, Genova
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ITALY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_ITALY"},
		MaxFleet = 1,
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezOccupied,
		Transport = GetSueztoItalyTransport,
	},
	[SUEZ_TO_USSR] = {
		Name = "Suez to USSR",
		SpawnList = { {X=72, Y=5}, }, -- Suez
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=78, Y=38}, }, -- Rostow
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_USSR"},
		MaxFleet = 5,
		Frequency = 35, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenRostowtoStalingrad,
		Transport = GetSueztoUSSRTransport,
	},
	[US_TO_USSR] = {
		Name = "US to USSR",
		SpawnList = { {X=0, Y=60}, {X=0, Y=64}, {X=0, Y=68}, {X=0, Y=72}, {X=0, Y=76}, {X=0, Y=80}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=85}, }, -- near Murmansk
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_USSR"},
		MaxFleet = 5,
		Frequency = 30, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenMurmansktoMoscow,
		Transport = GetUStoUSSRTransport,
	},
	[NORWAY_TO_GERMANY] = {
		Name = "Norway to Germany",
		SpawnList = { {X=50, Y=85}, }, -- adjacent to Narvik
		RandomSpawn = false,
		DestinationList = { {X=39, Y=53}, {X=40, Y=55}, {X=46, Y=52}, }, -- Hamburg, Kiel, Stettin
		RandomDestination = false,
		CivID = GERMANY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_NORWAY_TO_GERMANY"},
		MaxFleet = 4, 
		Frequency = 50,
		Condition = IsRouteOpenNorwaytoGermany,
		Transport = GetNorwaytoGermanyTransport,
	},
	[SWEDEN_TO_GERMANY] = {
		Name = "Sweden to Germany",
		SpawnList = { {X=56, Y=78}, }, -- adjacent to Lulea
		RandomSpawn = false,
		DestinationList = { {X=52, Y=53}, {X=46, Y=52}, {X=40, Y=55}, }, -- Konigsberg, Stettin, Kiel
		RandomDestination = false,
		CivID = GERMANY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SWEDEN_TO_GERMANY"},
		MaxFleet = 3, 
		Frequency = 50,
		Condition = IsRouteOpenSwedentoGermany, 
		Transport = GetFinlandtoGermanyTransport, -- re-use Finland values...
	},
	[SUEZ_TO_GREECE] = {
		Name = "Suez to Greece",
		SpawnList = { {X=73, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=56, Y=17}, {X=56, Y=22}, {X=59, Y=24}, }, -- Athens, Thessaloniki, Kavala
		RandomDestination = false, -- false : sequential try in destination list
		CivID = GREECE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_GREECE"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoGreeceTransport,
	},
	[CARAIB_TO_FRANCE] = {
		Name = "Caraib to France",
		SpawnList = { {X=0, Y=18}, {X=0, Y=21}, {X=0, Y=24}, {X=0, Y=32}, {X=0, Y=36}, {X=0, Y=40}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=21, Y=42}, {X=21, Y=45}, {X=29, Y=50}, {X=29, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetCaraibOilTransport, -- Must refer to a function, remove this line to use the default function
	},
	[CARAIB_TO_UK] = {
		Name = "Caraib to UK",
		SpawnList = { {X=0, Y=18}, {X=0, Y=21}, {X=0, Y=24}, {X=0, Y=32}, {X=0, Y=36}, {X=0, Y=40}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, {X=28, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_UK"},
		MaxFleet = 1,
		Frequency = 25, -- probability (in percent) of convoy spawning at each turn
		Transport = GetCaraibOilTransport,
	},
	[CARAIB_TO_GREECE] = {
		Name = "Caraib to UK",
		SpawnList = { {X=0, Y=18}, {X=0, Y=21}, {X=0, Y=24}, {X=0, Y=32}, {X=0, Y=36}, {X=0, Y=40}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=56, Y=17}, {X=56, Y=22}, {X=59, Y=24}, }, -- Athens, Thessaloniki, Kavala
		RandomDestination = false, -- false : sequential try in destination list
		CivID = GREECE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_UK"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Transport = GetCaraibOilTransport,
	},
	[US_TO_UK_USAF1] = {
		Name = "US to UK - USAF 1",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, {X=28, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_1"},
		MaxFleet = 1,
		Frequency = 75, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUSAFtoUKTransport1,
	},
	[US_TO_UK_USAF_RES] = {
		Name = "US to UK - USAF Oil",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, {X=28, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_Oil"},
		MaxFleet = 1,
		Frequency = 45, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUStoEuropeArmyResources,
	},
	[US_TO_FR_ARMY1] = {
		Name = "US to France -> Army",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=21, Y=42}, {X=21, Y=45}, {X=29, Y=50}, {X=29, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_MIL"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 75, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeTroops1, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_FR_ARMY_RES] = {
		Name = "US to France -> resources for Army",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=21, Y=42}, {X=21, Y=45}, {X=29, Y=50}, {X=29, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_RES"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 45, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeArmyResources, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_UK_ARMY1] = {
		Name = "US to UK - Army 1",
		SpawnList = { {X=0, Y=50}, {X=0, Y=55}, {X=0, Y=60}, {X=0, Y=65}, {X=0, Y=70}, {X=0, Y=75}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=22, Y=52}, {X=24, Y=57}, {X=27, Y=52}, {X=28, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_MIL"},
		MaxFleet = 1,
		Frequency = 65, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoUKTroops1,
		Transport = GetUStoEuropeTroops1,
	},
}


----------------------------------------------------------------------------------------------------------------------------
-- Troops Naval routes
----------------------------------------------------------------------------------------------------------------------------

function UKReinforcementToFrance()

	local bDebug = false
	
	Dprint ("  - UK is Checking to sent reinforcement troops to France", bDebug)

	if NorthFranceInvaded() then
		Dprint ("   - but France has fallen, now wait for D-Day...", bDebug)
		return false
	end

	if not UKIsSafe() then
		Dprint ("   - but UK is invaded, got priority...", bDebug)
		return false
	end

	if g_Norway_Land_Ratio < 0.75 then
		Dprint ("   - but Norway is invaded, got priority...", bDebug)
		return false
	end

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local pFrance = Players[iFrance]

	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local pUK = Players[iUK]

	if pFrance:GetTeam() ~= pUK:GetTeam() and not Teams[pFrance:GetTeam()]:IsAllowsOpenBordersToTeam(pUK:GetTeam()) then	
		Dprint ("   - but France borders are closed...", bDebug)
		return false
	end

	return true
end
function UKReinforcementToNorway()

	local bDebug = false
	
	Dprint ("  - UK is Checking to sent reinforcement troops to Norway", bDebug)

	if g_Norway_Land_Ratio >= 1 then
		Dprint ("   - but Norway is not invaded...", bDebug)
		return false
	end

	if not UKIsSafe() then
		Dprint ("   - but UK is invaded, got priority...", bDebug)
		return false
	end

	local iNorway = GetPlayerIDFromCivID (NORWAY, true, true)
	local pNorway = Players[iNorway]

	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local pUK = Players[iUK]

	if not (pNorway:IsAllies(iUK) or pNorway:IsFriends(iUK)) then	
		Dprint ("   - but Norway borders are closed...", bDebug)
		return false
	end

	if pNorway:GetNumCities() == 0 and not ReadyForOverlord() then	
		Dprint ("   - but Norway has no cities left, wait until D-day...", bDebug)
		return false
	end	
	
	local allyInNorway = GetTeamLandForceInArea( pUK, 37, 61, 60, 89 ) -- (37,61) -> (60,89) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pUK, 37, 61, 60, 89 )
	
	if (allyInNorway > enemyInNorway) or (allyInNorway > g_MaxForceInNorway) then	
		Dprint ("   - but allied have enough force in Norway, no need to reinforce them...", bDebug)
		return false
	end

	return true
end
function UKReinforcementToAfrica()

	local bDebug = false
	
	Dprint ("  - UK is Checking to sent reinforcement troops to Africa", bDebug)

	if IsSuezOccupied() then
		Dprint ("   - but Suez is occupied, need to prepare an invasion instead...", bDebug)
		return false
	end

	if g_Egypt_Land_Ratio >= 1 then
		Dprint ("   - but Egypt is not invaded...", bDebug)
		return false
	end

	if not UKIsSafe() then
		Dprint ("   - but UK is invaded, got priority...", bDebug)
		return false
	end
	
	--[[
	local iEgypt = GetPlayerIDFromCivID (EGYPT, true, true)
	local pEgypt = Players[iEgypt]

	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local pUK = Players[iUK]

	if not (pEgypt:IsAllies(iUK) or pEgypt:IsFriends(iUK)) then	
		Dprint ("  - but Egyptian borders are closed...", bDebug)
		return false
	end
	--]]

	return true
end

function ItalyReinforcementToAfrica()

	local bDebug = false
	
	Dprint ("  - Italy is Checking to sent reinforcement troops to Africa", bDebug)

	if g_Libya_Land_Ratio >= 1 then
		Dprint ("   - but Libya is not invaded...", bDebug)
		return false
	end

	if not ItalyIsSafe() then
		Dprint ("   - but Italy is invaded, got priority...", bDebug)
		return false
	end
	--[[
	local iLibya = GetPlayerIDFromCivID (LIBYA, true, true)
	local pLibya = Players[iLibya]

	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local pItaly = Players[iItaly]

	if not (pLibya:IsAllies(iItaly) or pLibya:IsFriends(iItaly)) then	
		Dprint ("  - but Libya borders are closed...", bDebug)
		return false
	end

	if pLibya:GetNumCities() == 0 then	
		Dprint ("  - but Libya has no cities left, need an invasion plan instead...", bDebug)
		return false
	end
	--]]

	return true
end
function ItalyReinforcementToAlbania()

	local bDebug = false
	
	Dprint ("  - Italy is Checking to sent reinforcement troops to Albania", bDebug)

	if g_Albania_Land_Ratio >= 1 then
		Dprint ("   - but Albania is not invaded...", bDebug)
		return false
	end

	if not ItalyIsSafe() then
		Dprint ("   - but Italy is invaded, got priority...", bDebug)
		return false
	end
	
	--[[
	local iAlbania = GetPlayerIDFromCivID (ALBANIA, true, true)
	local pAlbania = Players[iAlbania]

	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local pItaly = Players[iItaly]

	if not (pAlbania:IsAllies(iItaly) or pAlbania:IsFriends(iItaly)) then	
		Dprint ("  - but Albania borders are closed...", bDebug)
		return false
	end

	if pAlbania:GetNumCities() == 0 then	
		Dprint ("  - but Albania has no cities left, need an invasion plan instead...", bDebug)
		return false
	end
	--]]

	return true
end

function FranceReinforcementToAfrica()

	local bDebug = false
	
	Dprint ("  - France is Checking to sent reinforcement troops to Africa", bDebug)

	if FranceHasFallen() then
		Dprint ("   - but France has fallen, nothing to send...", bDebug)
		return false
	end

	if g_NAfrica_Land_Ratio >= 1 then
		Dprint ("   - but French North Africa is not invaded...", bDebug)
		return false
	end

	if g_France_Land_Ratio < 0.8 then
		Dprint ("   - but France is invaded...", bDebug)
		return false
	end

	return true
end


function GermanyReinforcementToNorway()

	local bDebug = false
	
	Dprint ("  - Germany is Checking to sent reinforcement troops to Norway", bDebug)

	if not GermanyIsSafe() then
		Dprint ("   - but Germany is invaded, got priority...", bDebug)
		return false
	end

	local iNorway = GetPlayerIDFromCivID (NORWAY, true, true)
	local pNorway = Players[iNorway]

	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local pGermany = Players[iGermany]


	if not AreAtWar( iGermany, iNorway) then	
		Dprint ("   - but Germany has not declared war to Norway...", bDebug)
		return false
	end
	
	local friendInNorway = GetTeamLandForceInArea( pGermany, 37, 61, 60, 89 ) -- (37,61) -> (60,89) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pGermany, 37, 61, 60, 89 )
	
	if (friendInNorway > enemyInNorway)  or (friendInNorway > g_MaxForceInNorway) then	
		Dprint ("   - but Axis have enough forces in Norway, no need to reinforce them...", bDebug)
		return false
	end

	return true
end

function GermanyReinforcementToUK()

	local bDebug = false
	
	Dprint ("  - Germany is Checking to sent reinforcement troops to UK", bDebug)

	if not GermanyIsSafe() then
		Dprint ("   - but Germany is invaded, got priority...", bDebug)
		return false
	end
	
	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local pGermany = Players[iGermany]


	if not IsOperationLaunched(OPERATION_SEELOWE) then	
		Dprint ("   - but Germany has not launched operation Seelowe...", bDebug)
		return false
	end
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 19, 51, 30, 68 ) -- (19,51) -> (30,68) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK and need another operation Seelowe...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 19, 51, 30, 68 )	
	if friendInUK > enemyInUK then	
		Dprint ("   - but Axis ("..friendInUK..") have more force than Allies ("..enemyInUK..") in UK, no need to reinforce them...", bDebug)
		return false
	end

	return true 
end


function GermanyDisengagefromUK()

	local bDebug = false
	
	Dprint ("  - Germany is Checking to remove troops from UK", bDebug)

	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local pGermany = Players[iGermany]

	if not IsOperationLaunched(OPERATION_SEELOWE) then	
		Dprint ("   - but Germany has not launched operation Seelowe...", bDebug)
		return false
	end
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 19, 51, 30, 68 ) -- (19,51) -> (30,68) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 19, 51, 30, 68 )	
	if friendInUK < (2*enemyInUK) then	
		Dprint ("   - but Axis ("..friendInUK..") have not total domination over Allies ("..enemyInUK..") in UK...", bDebug)
		return false
	end

	return true 
end

function RussiaReinforcementToFront()

	local bDebug = false
	
	Dprint ("  - Russia is checking to sent reinforcement troops to the West", bDebug)

	if g_USSR_Land_Ratio >= 1 then
		Dprint ("   - but USSR is not invaded...", bDebug)
		return false
	end
	Dprint ("  - Russia is sending reinforcement troops to the West", bDebug)
	return true
end


-- troops route list
TROOPS_UK_FRANCE = 1
TROOPS_UK_NORWAY = 2
TROOPS_UK_AFRICA = 3
TROOPS_ITALY_AFRICA = 4
TROOPS_ITALY_ALBANIA = 5
TROOPS_FRANCE_AFRICA = 6
TROOPS_UK_DDAY = 7
TROOPS_GERMANY_NORWAY = 8
TROOPS_GERMANY_SEELOWE_KIEL = 9
TROOPS_GERMANY_SEELOWE_ST_NAZAIRE = 10
TROOPS_GERMANY_UK = 11
TROOPS_GERMANY_BACK_UK = 12
TROOPS_LIBERATE_CASABLANCA = 13
TROOPS_LIBERATE_ORAN = 14
TROOPS_LIBERATE_ALGIERS = 15
TROOPS_LIBERATE_ALGIERSBRITISH = 16
TROOPS_LIBERATE_SICILY = 17
TROOPS_LIBERATE_SICILYBRITISH = 18
TROOPS_RUSSIA_WEST_1 = 19
TROOPS_RUSSIA_WEST_2 = 20
TROOPS_LIBERATE_ITALY = 21
TROOPS_LIBERATE_ITALYBRITISH = 22
TROOPS_OVERLORD_1 = 23
TROOPS_OVERLORD_2 = 24
TROOPS_OVERLORD_3 = 25

-- troops route table

g_TroopsRoutes = { 
	[ENGLAND] = {	
			[TROOPS_UK_FRANCE] = {
				Name = "UK to France",
				CentralPlot = {X=25, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=26, Y=51}, {X=27, Y=51}, {X=27, Y=52},}, -- near London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=28, Y=49}, {X=28, Y=48}, {X=27, Y=48}, {X=30, Y=50},}, -- near Dunkerque
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = UKReinforcementToFrance, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_NORWAY] = {
				Name = "UK to Norway",
				CentralPlot = {X=26, Y=58},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=26, Y=61}, {X=27, Y=59}, {X=28, Y=58}, }, -- near Newcastle
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=34, Y=66}, {X=43, Y=83}, {X=36, Y=75}, }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=48, Y=80}, {X=48, Y=81}, {X=47, Y=79}, {X=51, Y=84}, {X=52, Y=86}, {X=50, Y=83}, }, -- Between Narvik and Trondheim
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_AFRICA] = {
				Name = "UK to Africa",
				CentralPlot = {X=25, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=21, Y=52}, {X=22, Y=52}, {X=23, Y=52}, }, -- near Plymouth
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=21, Y=50}, {X=10, Y=48}, {X=7, Y=23}, {X=11, Y=23}, {X=19, Y=23}, {X=24, Y=23},  {X=33, Y=20}, {X=39, Y=14}, {X=54, Y=9}, {X=67, Y=7},}, 
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=69, Y=4}, {X=70, Y=4}, {X=71, Y=4}, {X=72, Y=4}, {X=73, Y=4}, {X=74, Y=4}, {X=75, Y=4}, {X=76, Y=4}, {X=76, Y=5}, {X=77, Y=6}, }, -- Between Alexandria and Haifa
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_DDAY] = {
				Name = "UK goes D-Day !",
				CentralPlot = {X=25, Y=55},
				MaxDistanceFromCentral = 9,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=21, Y=52}, {X=22, Y=52}, {X=23, Y=52}, {X=26, Y=51}, {X=27, Y=51}, }, -- near Plymouth, London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=21, Y=47}, {X=22, Y=47}, {X=23, Y=47}, {X=24, Y=47}, {X=25, Y=47}, {X=26, Y=47}, }, -- Between Brest and Caen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 16,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_LIBERATE_CASABLANCA] = {
				Name = "America to Africa 1",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=2, Y=16}, {X=2, Y=17}, {X=5, Y=17},{X=6, Y=18}, {X=3, Y=17}, {X=1, Y=15},  },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ORAN] = {
				Name = "America to Africa 2",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=13, Y=19}, {X=14, Y=19}, {X=16, Y=20}, {X=17, Y=20},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ALGIERS] = {
				Name = "America to Africa 3",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=19, Y=20}, {X=20, Y=20}, {X=20, Y=21}, {X=18, Y=20}, {X=22, Y=20}, {X=23, Y=20},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ALGIERSBRITISH] = {
				Name = "England to Africa",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=24, Y=20}, {X=24, Y=19}, {X=25, Y=19},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_SICILY] = {
				Name = "America to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=39, Y=19}, {X=40, Y=18}, {X=41, Y=18},},
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_LIBERATE_SICILYBRITISH] = {
				Name = "England to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=42, Y=16}, {X=43, Y=18}, {X=41, Y=17},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ITALY] = {
				Name = "America to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=42, Y=25}, {X=43, Y=24}, {X=44, Y=24}, {X=44, Y=23},},
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_LIBERATE_ITALYBRITISH] = {
				Name = "England to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=45, Y=22}, {X=45, Y=23}, {X=46, Y=23}, {X=47, Y=23},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_OVERLORD_1] = {
				Name = "Overlord I",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=19, Y=47}, {X=20, Y=46}, {X=21, Y=46}, {X=21, Y=44}, {X=21, Y=43},},
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_OVERLORD_2] = {
				Name = "Overlord II",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=20, Y=48}, {X=20, Y=47}, {X=21, Y=47}, {X=22, Y=47}, {X=24, Y=47}, {X=25, Y=47}, },
				RandomLanding = true, -- false : sequential try in landing list
			},

	},
	[ITALY] = {	
			[TROOPS_ITALY_AFRICA] = {
				Name = "Italy to Africa",
				CentralPlot = {X=39, Y=28},
				MaxDistanceFromCentral = 7,
				ReserveUnits = 6, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=39, Y=28}, {X=39, Y=27}, {X=41, Y=26},  {X=41, Y=25}, }, -- near Rome, Naples
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=39, Y=22}, {X=37, Y=22},  }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=40, Y=7}, {X=41, Y=6}, {X=45, Y=3}, {X=46, Y=3}, {X=51, Y=4}, {X=52, Y=6}, }, -- near Triploli, Sirte, Benghazi
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 4,
				MaxUnits = 8, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = ItalyReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_ITALY_ALBANIA] = {
				Name = "Italy to Albania",
				CentralPlot = {X=41, Y=25},
				MaxDistanceFromCentral = 7,
				ReserveUnits = 6, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=45, Y=25}, {X=46, Y=24}, {X=47, Y=24}, {X=41, Y=29}, {X=41, Y=30},  }, -- near Bari, Pescara
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=47, Y=27}, {X=48, Y=26} }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=50, Y=24}, {X=50, Y=23}, {X=50, Y=25}, {X=50, Y=26}, {X=51, Y=22}, {X=51, Y=21}, }, -- near Tirana
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 3,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = ItalyReinforcementToAlbania, -- Must refer to a function, remove this line to use the default condition (true)
			},
	},
	[FRANCE] = {	
			[TROOPS_FRANCE_AFRICA] = {
				Name = "France to Africa",
				CentralPlot = {X=28, Y=35},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=39, Y=34}, {X=28, Y=34}, {X=29, Y=33}, }, -- near Marseille
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=22, Y=20}, {X=23, Y=20}, {X=24, Y=20}, {X=24, Y=19}, {X=25, Y=19}, {X=26, Y=19}, {X=27, Y=19}, {X=28, Y=19}, {X=29, Y=19}, {X=30, Y=18}, {X=31, Y=18}, {X=32, Y=18}, {X=33, Y=18}, }, -- Between Alger and Tunis
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 3,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = FranceReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_OVERLORD_3] = {
				Name = "Overlord III",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=26, Y=48}, {X=27, Y=48}, {X=28, Y=48}, {X=28, Y=49}, },
				RandomLanding = true, -- false : sequential try in landing list
			},

	},
	[GERMANY] = {	
			[TROOPS_GERMANY_NORWAY] = {
				Name = "Germany to Norway",
				CentralPlot = {X=40, Y=53},
				MaxDistanceFromCentral = 3,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=40, Y=54}, {X=40, Y=55}, {X=39, Y=53}, {X=38, Y=53},}, -- near Kiel (West of)
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=38, Y=55}, {X=37, Y=60}, },
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=39, Y=64}, {X=39, Y=63}, {X=40, Y=63}, {X=41, Y=64}, {X=42, Y=64}, }, -- Between Bergen and Oslo
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_GERMANY_SEELOWE_KIEL] = {
				Name = "Germany to UK (Seelowe from Kiel)",
				WaypointList = { {X=37, Y=56}, {X=31, Y=57}, },
				RandomWaypoint = false, 
				LandingList = { {X=27, Y=55}, {X=28, Y=54}, {X=28, Y=56}, {X=27, Y=57}, {X=27, Y=59},}, -- Between Norwich and Newcastle
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_SEELOWE_ST_NAZAIRE] = {
				Name = "Germany to UK (Seelowe from St Nazaire)",
				WaypointList = { {X=15, Y=47}, {X=18, Y=53}, },
				RandomWaypoint = false, 
				LandingList = { {X=20, Y=52}, {X=21, Y=52}, {X=21, Y=53}, {X=22, Y=53}, {X=23, Y=54},}, -- Between Plymouth and Liverpool
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_UK] = {
				Name = "Germany to UK",
				CentralPlot = {X=23, Y=47},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=23, Y=48}, {X=22, Y=47}, {X=23, Y=47}, }, -- near Cherbourg
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=23, Y=52}, {X=24, Y=52}, {X=25, Y=52}, {X=25, Y=51}, }, -- East of Plymouth
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToUK, -- Must refer to a function, remove this line to use the default condition (true)
			},
			
			[TROOPS_GERMANY_BACK_UK] = {
				Name = "Germany back to France from UK",
				CentralPlot = {X=25, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=26, Y=51}, {X=27, Y=51}, }, -- near London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=28, Y=49}, {X=28, Y=48}, {X=27, Y=48}, }, -- near Dunkerque
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 2, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyDisengagefromUK, -- Must refer to a function, remove this line to use the default condition (true)
			},
	},
	[USSR] = {	
			[TROOPS_RUSSIA_WEST_1] = {
				Name = "East to West1",
				CentralPlot = {X=102, Y=75}, --Berezovo
				MaxDistanceFromCentral = 10,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=102, Y=75},}, -- Berezovo
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=64, Y=64}, {X=66, Y=55}, {X=72, Y=58}, {X=61, Y=52}, {X=65, Y=85}, }, -- Cities in North USSR
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 10, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = RussiaReinforcementToFront, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_RUSSIA_WEST_2] = {
				Name = "East to West2",
				CentralPlot = {X=101, Y=55}, --Tscheljabinsk
				MaxDistanceFromCentral = 10,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=101, Y=55},}, -- Tscheljabinsk
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=67, Y=37}, {X=71, Y=33}, {X=66, Y=44}, {X=73, Y=43}, {X=78, Y=38}, }, -- Cities in South USSR
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 10, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = RussiaReinforcementToFront, -- Must refer to a function, remove this line to use the default condition (true)
			},

	},

}


----------------------------------------------------------------------------------------------------------------------------
-- Military Projects
----------------------------------------------------------------------------------------------------------------------------

-- add scenario specific restriction for projects
function PlayerEuro1940ProjectRestriction  (iPlayer, iProjectType)
	local bDebug = false
	local civID = GetCivIDFromPlayerID(iPlayer, false)	
		
	if civID == GERMANY and iProjectType == OPERATION_SEELOWE then
		if AreAtWar( iPlayer, GetPlayerIDFromCivID(USSR, false)) then
			Dprint("      - Operation Seelowe not available, Germany is at war with USSR...", bDebug)		
			return false 
		end
		local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Seelowe not available, Berlin is occupied...", bDebug)	
			return false 
		end
	end	
	
	if civID == GERMANY and iProjectType == OPERATION_WESERUBUNG then
		local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Weserübung not available, Berlin is occupied...", bDebug)	
			return false 
		end	
	end

	if civID == GERMANY and iProjectType == OPERATION_FALLGELB then
		if(PreGame.GetGameOption("MaginotLine") == nil) or (PreGame.GetGameOption("MaginotLine") ==  0) then
			Dprint("      - Operation Fall Gelb only available with Maginot Line...", bDebug)				
			return false 
		end
		local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Berlin is occupied...", bDebug)	
			return false -- Paratroopers launch from Berlin...
		end
		local Essen = GetPlot(36, 50):GetPlotCity()	-- Essen
		if Essen:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Essen is occupied...", bDebug)	
			return false -- 1st army launch from Essen...
		end
		local Cologne = GetPlot(36, 49):GetPlotCity()	-- Cologne
		if Cologne:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Cologne is occupied...", bDebug)	
			return false -- 2nd army launch from Cologne...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_SONNENBLUME then
		local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Sonnenblume not available, Berlin is occupied...", bDebug)	
			return false 			-- Paratroopers launch from Berlin...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_TWENTYFIVE then
		local Vienna = GetPlot(47, 40):GetPlotCity()	-- Vienna
		if Vienna:IsOccupied() then
			Dprint("      - Operation Twenty Five not available, Vienna is occupied...", bDebug)	
			return false 			-- Operation starts from Vienna...
		end
	end
	return true
end
-- GameEvents.PlayerCanCreate.Add(PlayerEuro1940ProjectRestriction) (called in RedEuro1940.lua)


function IsGermanyReadyForWeserubung()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(NORWAY, true)) then
		Dprint("      - Operation Weserübung not ready, Germany is not at war with Norway...", bDebug)
		return false
	end
	local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Weserübung not ready, Berlin is occupied...", bDebug)	
		return false -- Paratroopers launch from Berlin...
	end
	return true
end

function IsGermanyReadyForSonnenblume()
	local bDebug = false
	local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Berlin is occupied...", bDebug)				
		return false -- Paratroopers launch from Berlin...
	end
	local Rome = GetPlot(39, 28):GetPlotCity()	-- Rome
	if Rome:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Rome is occupied...", bDebug)		
		return false 
	end
	local city = GetPlot(56, 5):GetPlotCity()	-- Tobruk
	if IsAxis(city:GetOwner()) then
		Dprint("      - Operation Sonnenblume not ready, Tobruk is not occupied...", bDebug)
		return false 
	end

	return true
end

function IsGermanyReadyForTwentyFive()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(YUGOSLAVIA, true)) then
		Dprint("      - Operation TwentyFive not ready, Germany is not at war with Yugoslavia...", bDebug)
		return false
	end
	local Vienna = GetPlot(47, 40):GetPlotCity()	-- Vienna
		if Vienna:IsOccupied() then
			Dprint("      - Operation TwentyFive not ready, Vienna is occupied...", bDebug)
			return false 			-- Operation starts from Vienna...
		end
	return true
end

function IsUSSRLosingWar()

	local bDebug = false
	Dprint ("  - Checking if USSR is losing war...", bDebug)
	if g_Cities then
		Dprint("  - Looking for captured key cities...", bDebug)
		local numKeyCityLost = 0
		for i, data in ipairs(g_Cities) do
			if data.Key then
				local plot = GetPlot(data.X, data.Y)
				local city = plot:GetPlotCity()	
				if city then
					local firstOwnerID = GetPlotFirstOwner(GetPlotKey(plot))
					local firstCivID = GetCivIDFromPlayerID(firstOwnerID, false)
					Dprint("    - Check if " .. city:GetName() .. " was USSR and if capturing player is axis...", bDebug)
					if firstCivID == USSR and city:IsOccupied() and g_Axis[GetCivIDFromPlayerID(city:GetOwner(), false)] then -- check if a key city of newPlayerID opponent is free
						Dprint("       - Keycity occupied by Axis power", bDebug)
						numKeyCityLost = numKeyCityLost + 1
					end
				else
					Dprint("WARNING : plot at ("..tostring(data.X)..","..tostring(data.Y) ..") is not city, but is in g_Cities table !", bDebug)
				end
			end
		end
		if numKeyCityLost > 1 and g_USSR_Land_Ratio < 0.95 then 
			Dprint("  - At least 2 key cities captured, and g_USSR_Land_Ratio < 0.95 returning true...", bDebug)
			return true
		end
		Dprint("  - Less than 2 key cities captured or g_USSR_Land_Ratio >= 0.95...", bDebug)
	end

	if g_USSR_Land_Ratio >= 0.85 then
		Dprint ("   - Land ratio is high enough (".. tostring(g_USSR_Land_Ratio) .. " >= 0.85)", bDebug)
		return false
	end

	Dprint ("   - Land ratio is low (".. tostring(g_USSR_Land_Ratio) .. " < 0.85)", bDebug)

	local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
	local pUSSR = Players[iUSSR]

	local enemyForces = GetEnemyLandForceInArea( pUSSR, 59, 31, 107, 83 )
	local allyForces = GetSameSideLandForceInArea( pUSSR, 59, 31, 107, 83 )

	if (allyForces * 75/100) >= enemyForces then	-- if our ally doesn't have less than 75% of the ennemy forces, we are not losing	
		Dprint ("   - Ally Forces are high enough: ".. tostring(allyForces) .. " > 75% of enemy forces (" .. tostring(enemyForces) ..")", bDebug)
		return false
	end
	
	Dprint ("   - Ally Forces are low: ".. tostring(allyForces) .. " < 75% of enemy forces (" .. tostring(enemyForces) ..")", bDebug)

	return true
end

function IsGermanyReadyForFallGelb()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(BELGIUM, true)) then
		Dprint("      - Operation Fall Gelb not ready, Germany is not at war with Belgium...", bDebug)
		return false
	end
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(NETHERLANDS, true)) then
		Dprint("      - Operation Fall Gelb not ready, Germany is not at war with Netherlands...", bDebug)
		return false
	end
	local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Berlin is occupied...", bDebug)		
		return false -- Paratroopers launch from Berlin...
	end
	local Essen = GetPlot(36, 50):GetPlotCity()	-- Essen
	if Essen:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Essen is occupied...", bDebug)			
		return false -- 1st army launch from Essen...
	end
	local Cologne = GetPlot(36, 49):GetPlotCity()	-- Cologne
	if Cologne:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Cologne is occupied...", bDebug)			
		return false -- 2nd army launch from Cologne...
	end
	return true
end

function IsGermanyReadyForSeelowe()
	local bDebug = false
	if AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(USSR, false)) then
		Dprint("      - Operation Seelowe not ready, Germany is at war with USSR......", bDebug)
		return false
	end
	local Berlin = GetPlot(44, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Seelowe not ready, Berlin is occupied...", bDebug)
		return false -- Paratroopers launch from Berlin...
	end
	if not (NorthFranceInvaded()) then
		Dprint("      - Operation Seelowe not ready, North France is not invaded...", bDebug)
		return false
	end
	return true
end

g_Military_Project = {
	------------------------------------------------------------------------------------
	[GERMANY] = {
	------------------------------------------------------------------------------------
		[OPERATION_WESERUBUNG] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_WESERUBUNG",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 44, Y = 50, Domain = "City", CivID = GERMANY, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, GE_PARATROOPER,	},
					UnitsXP = {		9,				9,	              9,}, 
					InitialObjective = "51,85", -- Narvik
					LaunchType = "ParaDrop",
					LaunchX = 51, -- Destination plot
					LaunchY = 83, -- (51,83) = Near Narvik
					LaunchImprecision = 3, -- landing area
				},
				{	Name = "Para Group 2", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		9,				9,				}, 
					InitialObjective = "44,66", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 43, -- Destination plot
					LaunchY = 66, -- (43,66) = West of Oslo
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Para Group 3", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		9,				9,				}, 
					InitialObjective = "44,66", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 44, -- Destination plot
					LaunchY = 68, -- (44,68) = North of Oslo
					LaunchImprecision = 2, -- landing area
				},
			},			
			Condition = IsGermanyReadyForWeserubung, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		[OPERATION_SEELOWE] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SEELOWE",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, GE_PARATROOPER,	},
					UnitsXP = {		15,				15,				15,   }, 
					InitialObjective =  "25,54", -- Birmingham 
					LaunchType = "ParaDrop",
					LaunchX = 25, -- Destination plot
					LaunchY = 55, -- (25,55) = Near Birmingham
					LaunchImprecision = 2, -- landing area
				}, 
				{	Name = "Amphibious Army 1", X = 38, Y = 55, Domain = "Land", CivID = GERMANY, AI = true,-- spawn west of Kiel
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_III,	GE_PANZER_II},
					UnitsXP = {		15,				15,				 15,             15,             15,    }, 
					InitialObjective = "28,58", -- Newcastle  
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_KIEL, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Amphibious Army 2", X = 19, Y = 43, Domain = "Land", CivID = GERMANY, AI = true,-- spawn west of St Nazaire / La rochelle
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_IV,	GE_PANZER_II},
					UnitsXP = {		15,				15,				 15,          15,            15,     }, 
					InitialObjective = "22,52", -- Plymouth  
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_ST_NAZAIRE, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
			},			
			Condition = IsGermanyReadyForSeelowe, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		[OPERATION_FALLGELB] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_FALLGELB",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER	},
					UnitsXP = {		9,				9,}, 
					InitialObjective = "34,52", -- Amsterdam
					LaunchType = "ParaDrop",
					LaunchX = 33, -- Destination plot
					LaunchY = 51, -- (51,83) = Near Amsterdam
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Para Group 2", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		9,				9,				}, 
					InitialObjective = "32,49", -- Brussel
					LaunchType = "ParaDrop",
					LaunchX = 33, -- Destination plot
					LaunchY = 49, -- (44,74) = Near Brussel
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Army 1", X = 36, Y = 50, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Essen
					Group = {		GE_INFANTRY,	GE_INFANTRY,	GE_INFANTRY,	GE_PANZER_IV,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		9,				9,				9,				9,				9,				9,			9,	}, 
					InitialObjective = "34,52", -- Amsterdam 
				},
				{	Name = "Support 1", X = 36, Y = 50, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Essen
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "34,52", -- Amsterdam 
				},
				{	Name = "Army 2", X = 36, Y = 49, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		GE_INFANTRY,	GE_INFANTRY,	GE_INFANTRY,	GE_PANZER_III,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		9,				9,				9,				9,				9,				9,			9,	}, 
					InitialObjective = "32,49", -- Brussel 
				},
				{	Name = "Support 2", X = 36, Y = 49, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "32,49", -- Brussel  
				},

			},
			Condition = IsGermanyReadyForFallGelb, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		[OPERATION_SONNENBLUME] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SONNENBLUME",
			OrderOfBattle = {
				{	Name = "Afrika Korps I", X = 44, Y = 50, Domain = "City", CivID = GERMANY,
					Group = {		GE_INFANTRY, GE_INFANTRY,	GE_PANZER_III,	GE_INFANTRY,	GE_PANZER_III,	},
					UnitsXP = {		9,	         9,			9,		         9,	    	 9,	}, 
					InitialObjective = "56,5", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 53, -- Destination plot
					LaunchY = 5, -- (53,5) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Afrika Korps II", X = 44, Y = 50, Domain = "City", CivID = GERMANY, AI = true,
					Group = {		GE_PANZER_IV,	ARTILLERY,	AT_GUN,	},
					UnitsXP = {		9,	             9,		     9,		}, 
					InitialObjective = "56,5", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 53, -- Destination plot
					LaunchY = 5, -- (53,5) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
			},		
			Condition = IsGermanyReadyForSonnenblume, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		[OPERATION_TWENTYFIVE] =  { -- projectID as index !
			Name = "Operation 25",
			OrderOfBattle = {
				{	Name = "Belgrade Assault Force", X = 47, Y = 40, Domain = "City", CivID = GERMANY,  AI = true,
					Group = {		GE_INFANTRY,	GE_PANZER_III, GE_PANZER_III, GE_PANZER_IV,	},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "52,32", -- Belgrade
				},
				{	Name = "Zagreb Assault Force", X = 47, Y = 40, Domain = "City", CivID = GERMANY, AI = true,
					Group = {		GE_INFANTRY,	GE_INFANTRY, GE_PANZER_II,	},
					UnitsXP = {		9,				9,				9,	 }, 
					InitialObjective = "46,35", -- Zagreb
				},
			},			
			Condition = IsGermanyReadyForTwentyFive, -- Must refer to a function, remove this line to use the default condition (always true)
		},

	},
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	[USSR] = {
	------------------------------------------------------------------------------------
		[OPERATION_MOTHERLANDCALL] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_MOTHERLANDCALL",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 106, Y = 70, Domain = "Land", CivID = USSR, -- spawn near Berezovo
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		15,					15,	     15,     15,     15,          15,          15,}, 
					InitialObjective = "44,50", -- Berlin
				},
				{	Name = "Support Group 1", X = 106, Y = 70, Domain = "Land", CivID = USSR, -- spawn near Berezovo
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "44,50", -- Berlin
				},
				{	Name = "Army Group 2", X = 103, Y = 55, Domain = "Land", CivID = USSR, AI = true, -- spawn near Tscheljabinsk
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		15,					15,       15,    15,     15,           15,          15,	}, 
					InitialObjective = "44,50", -- Berlin
				},
				{	Name = "Support Group 2", X = 103, Y = 55, Domain = "Land", CivID = USSR, AI = true, -- spawn near Tscheljabinsk
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "44,50", -- Berlin
				},
			},			
			Condition = IsUSSRLosingWar, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_URANUS] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_URANUS",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 83, Y = 51, Domain = "Land", CivID = USSR, -- spawn north of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_KV1, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,       9,    9,     9,           9,          9,	}, 
					InitialObjective = "84,48", -- Stalingrad
				},
				{	Name = "Support Group 1", X = 83, Y = 51, Domain = "Land", CivID = USSR, AI = true,-- spawn north of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "84,48", -- Stalingrad
				},
				{	Name = "Army Group 2", X = 83, Y = 45, Domain = "Land", CivID = USSR,  -- spawn south of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_ISU122, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,       9,    9,     9,           9,          9,	}, 
					InitialObjective = "84,48", -- Stalingrad
				},
				{	Name = "Support Group 2", X = 83, Y = 45, Domain = "Land", CivID = USSR, AI = true, -- spawn south of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "84,48", -- Stalingrad
				},
			},			
			Condition = StalingradOccupied, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},
	
	[ENGLAND] = {
	------------------------------------------------------------------------------------
		[OPERATION_TORCH] =  { -- projectID as index !
			Name = "Operation Torch",
			OrderOfBattle = {
				{	Name = "Western Task Force", X = 3, Y = 20, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_INFANTRY, US_INFANTRY,	US_M24CHAFFEE},
					UnitsXP = {		9,				9,			9,             9}, 
					InitialObjective = "4,17", -- Casablanca 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group", X = 4, Y = 21, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective = "4,17", -- Casablanca 
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force", X = 13, Y = 21, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_MARINES, US_SHERMAN,	},
					UnitsXP = {		9,				9,        9}, 
					InitialObjective =  "15,20", -- Oran 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group", X = 12, Y = 22, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective =  "15,20", -- Oran 
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Eastern Task Force (American)", X = 19, Y = 23, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_MARINES, US_SHERMAN },
					UnitsXP = {		9,				9,        9}, 
					InitialObjective = "21,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERS, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force (British)", X = 25, Y = 22, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, },
					UnitsXP = {		9,	}, 
					InitialObjective = "21,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group", X = 26, Y = 22, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY,	},
					InitialObjective = "21,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},		
				{	Name = "Paradrop Force", X = 27, Y = 52, Domain = "City", CivID = ENGLAND,
					Group = {		US_PARATROOPER, },
					UnitsXP = {		9,	 }, 
					InitialObjective = "15,20", -- Oran
					LaunchType = "ParaDrop",
					LaunchX = 16, -- Destination plot
					LaunchY = 19,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "French Resistance", X = 16, Y = 18, Domain = "City", CivID = FRANCE,
					Group = {		FR_LEGION, },
					UnitsXP = {		9,	 }, 
					InitialObjective = "21,21", -- Algiers
					LaunchType = "ParaDrop",
					LaunchX = 21, -- Destination plot
					LaunchY = 19,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = NorthAfricaInvaded, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_HUSKY] =  { -- projectID as index !
			Name = "Operation Husky",
			OrderOfBattle = {
				{	Name = "Western Task Force (USA)", X = 37, Y = 20, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_MARINES, ARTILLERY},
					UnitsXP = {		9,				9,			9}, 
					InitialObjective = "40,19", -- Palermo
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force (British)", X = 43, Y = 14, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_INFANTRY, ARTILLERY},
					UnitsXP = {		9,	             9,          9}, 
					InitialObjective = "42,17", -- Catania
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILYBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},

			},			
			Condition = NorthAfricaLiberated,-- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_AVALANCHE] =  { -- projectID as index !
			Name = "Operation Avalanche",
			OrderOfBattle = {
				{	Name = "Northern Task Force (USA)", X = 41, Y = 22, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_MARINES, US_M7, US_M12},
					UnitsXP = {		9,				9,			9,       9}, 
					InitialObjective = "41,25", -- Napoli
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ITALY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Southern Task Force (British)", X = 47, Y = 20, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_MECH_INFANTRY, UK_MOBILE_BISHOP},
					UnitsXP = {		9,	             9,          9}, 
					InitialObjective = "46,24", -- Bari
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ITALYBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},

			},			
			Condition = IsSicilyOccupied,-- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_OVERLORD] =  { -- projectID as index !
			Name = "Operation Overlord",
			OrderOfBattle = {
				{	Name = "Western Task Force I", X = 17, Y = 45, Domain = "Land", CivID = ENGLAND,
					Group = {		US_INFANTRY, US_INFANTRY, US_INFANTRY,	US_INFANTRY, US_MARINES, US_MARINES, US_MARINES, },
					UnitsXP = {		9,				9,			9,             9,              9,        9,        9   }, 
					InitialObjective = "21,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group I", X = 16, Y = 48, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY, ARTILLERY, ARTILLERY, AT_GUN, AT_GUN, AT_GUN, US_M10	},
					UnitsXP = {		9,			9,			9,          9,    9,        9,      9   }, 
					InitialObjective = "21,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Western Task Force II", X = 14, Y = 45, Domain = "Land", CivID = ENGLAND,
					Group = {		US_SHERMAN_IIA, US_SHERMAN_IIA, US_SHERMAN_III,	US_SHERMAN_III, US_M24CHAFFEE, US_M24CHAFFEE, US_MECH_INFANTRY, },
					UnitsXP = {		      9,				9,			9,             9,              9,             9,               9   }, 
					InitialObjective = "21,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group II", X = 13, Y = 48, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		US_M18, US_M18, US_M12, US_M12, US_M16A1, US_M16A1, US_SEXTON	},
					UnitsXP = {		9,		9,		9,      9,      9,        9,        9   }, 
					InitialObjective = "21,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Western Paradrop Force", X = 27, Y = 52, Domain = "City", CivID = ENGLAND,
					Group = {US_PARATROOPER, US_PARATROOPER, US_PARATROOPER, US_SPECIAL_FORCES},
					UnitsXP = {		9,				9,			9,             29,            }, 
					InitialObjective = "21,45", -- Saint Nazaire 
					LaunchType = "ParaDrop",
					LaunchX = 23, -- Destination plot
					LaunchY = 44,
					LaunchImprecision = 3, -- landing area
				},
				{	Name = "Central Task Force I", X = 21, Y = 50, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_INFANTRY, UK_INFANTRY,	UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, },
					UnitsXP = {		9,				9,			9,             9,              9,        9,        9			}, 
					InitialObjective = "25,46", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group I", X = 18, Y = 50, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY, ARTILLERY, ARTILLERY, AT_GUN, AT_GUN, AT_GUN, UK_ACHILLES	},
					UnitsXP = {		9,			9,			9,          9,    9,        9,      9           }, 
					InitialObjective = "25,46", -- Caen
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force II", X = 18, Y = 53, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_M4_FIREFLY, UK_M4_FIREFLY, UK_CHURCHILL,	UK_CHURCHILL, UK_A24, UK_A24, UK_MECH_INFANTRY, },
					UnitsXP = {		      9,				9,			9,             9,              9,             9,               9   }, 
					InitialObjective = "25,46", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group II", X = 16, Y = 53, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		UK_MOBILE_BISHOP, UK_MOBILE_BISHOP, UK_MOBILE_AA_VICKERS, UK_MOBILE_AA_VICKERS, UK_MOBILE_BISHOP, UK_MOBILE_BISHOP, UK_MOBILE_AA_GUN	},
					UnitsXP = {		9,		             9,		        9,                        9,                 9,              9,                    9   }, 
					InitialObjective = "25,46", -- Caen
					LaunchType = "Amphibious", 
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Central Paradrop Force", X = 27, Y = 52, Domain = "City", CivID = ENGLAND,
					Group = {UK_PARATROOPER, UK_PARATROOPER, UK_SPECIAL_FORCES, UK_SPECIAL_FORCES},
					UnitsXP = {		9,				9,			29,             29,              }, 
					InitialObjective = "25,46", -- Caen 
					LaunchType = "ParaDrop",
					LaunchX = 25, -- Destination plot
					LaunchY = 44,
					LaunchImprecision = 2, -- landing area
				},				
				{	Name = "Eastern Task Force I", X = 27, Y = 50, Domain = "Land", CivID = FRANCE,
					Group = {		FR_INFANTRY, FR_INFANTRY, FR_INFANTRY, },
					UnitsXP = {		9,				9,			9,       }, 
					InitialObjective = "29,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group I", X = 25, Y = 50, Domain = "Land", CivID = FRANCE, AI = true, 
					Group = {		ARTILLERY, AT_GUN, FR_SAU40	},
					UnitsXP = {		9,			9,			9   }, 
					InitialObjective = "29,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force II", X = 29, Y = 52, Domain = "Land", CivID = FRANCE,
					Group = {		INFANTRY, INFANTRY, INFANTRY,	 },
					UnitsXP = {		    9,	   9,			9,		 }, 
					InitialObjective = "29,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "French Resistance", X = 30, Y = 46, Domain = "Land", CivID = FRANCE,  -- spawn near Reims
					Group = {		FR_PARTISAN,	FR_PARTISANY,	FR_PARTISAN,},
					InitialObjective = "31,46", -- Reims
				},
			},			
			Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},		
}


function InitializeEuro1940Projects()

	local bDebug = false

	Dprint("-------------------------------------", bDebug)
	Dprint("Initializing specific projects for Europe 1939-1945 scenario...", bDebug)

	if not g_ProjectsTable then
		return
	end

	local turn = Game.GetGameTurn()
	local date = g_Calendar[turn]
	if date.Number >= 19420101 and PROJECT_M3A1HT and not IsProjectDone(PROJECT_M3A1HT) then
		local projectInfo = GameInfo.Projects[PROJECT_M3A1HT]
		MarkProjectDone(PROJECT_M3A1HT, AMERICA)
		Events.GameplayAlertMessage(Locale.ConvertTextKey(projectInfo.Description) .." has been completed !")
	end
end

--------------------------------------------------------------
-- UI functions
--------------------------------------------------------------
include("InstanceManager")

-- Tooltip init
function DoInitEuro1940UI()
	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetToolTipCallback( ToolTipEuro1940Score )
	UpdateEuro1940ScoreString()
end

local tipControlTable = {};
TTManager:GetTypeControlTable( "TooltipTypeTopPanel", tipControlTable );

-- Score Tooltip for Europe 39-45
function ToolTipEuro1940Score( control )

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

function UpdateEuro1940ScoreString()

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

--------------------------------------------------------------
-- Other functions
--------------------------------------------------------------

function BalanceScenario()

	-- Place the Modlin Fortress in Poland
	SetCitadelAt(52, 49)
	
	-- Place the Shlisselburg Fortress in USSR
	SetCitadelAt(63, 65)

	-- Place the Mannerheim Line in Finland
	SetBunkerAt(61, 66)
	SetBunkerAt(62, 68)
	
	-- Place the fortifications for the Maginot Line
	if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
		SetCitadelAt(36, 45)
		SetBunkerAt(35, 42)
		SetBunkerAt(35, 43)
		SetFortAt(35, 45)
		SetFortAt(35, 46)
	end

	-- Place the fortifications for the Siegfried Line
	if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
		SetBunkerAt(37, 42)
		SetBunkerAt(38, 44)
		SetBunkerAt(37, 46)
		SetBunkerAt(35, 47)
		SetBunkerAt(35, 49)
		SetBunkerAt(35, 51)
		SetBunkerAt(36, 53)
	end
end

function SeasonScenario()
	if(PreGame.GetGameOption("PlayWithSeason") ~= nil) and (PreGame.GetGameOption("PlayWithSeason") > 0) then
		local month = TurnToMonth()
		local rand = math.random( 1, 4 )
		if rand == 4 and month == 10 and WINTERTIME == 0 then	--early winter
			WINTERTIME = 1
			Dprint ("Early Wintertime - Monat: "..month)
		elseif rand >= 2 and month == 11 and WINTERTIME == 0 then	-- winter
			WINTERTIME = 1
			Dprint ("Wintertime - Monat: "..month)
		elseif month == 12 and WINTERTIME == 0 then				-- late winter
			WINTERTIME = 1
			Dprint ("Late Wintertime - Monat: "..month)
		end 
		if rand == 4 and month == 2 and WINTERTIME == 2 then	--early spring
			WINTERTIME = 0
			Dprint ("Early Springtime - Monat: "..month)
		elseif rand >= 2 and month == 3 and WINTERTIME == 2 then	-- spring
			WINTERTIME = 0
			Dprint ("Springtime - Monat: "..month)
		elseif month == 4 and WINTERTIME == 2 then				-- late spring
			WINTERTIME = 0
			Dprint ("Late Springtime - Monat: "..month)
		end 
		if WINTERTIME == 0 then
			for x = 0, 107, 1 do
				for y = 31, 90, 1 do	--Wintertime region
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local map = LoadTerritoryMap()
					for i, data in pairs ( map ) do
						if (i == plotKey) then
							local ter = data.TerrainType
							plot:SetTerrainType(ter, false, true)
						end
					end
					local feat = plot:GetFeatureType();
					if feat == 0 then
						plot:SetFeatureType(-1)
					end
				end
			end
		elseif WINTERTIME == 1 then
			for x = 0, 67, 1 do				-- west of Murmansk
				for y = 81, 90, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 95 and ter == 0 then  -- Grassland to Snow 95%
						plot:SetTerrainType(4, false, true)
					elseif rand > 95 and ter == 0 then  -- Grassland to Tundra 5%
						plot:SetTerrainType(3, false, true)
					elseif ter == 3 then -- Tundra to Snow 100%
						plot:SetTerrainType(4, false, true)
					elseif rand <= 95 and ter == 1 then  -- Plains to Snow 95%
						plot:SetTerrainType(4, false, true)
					elseif rand > 95 and ter == 1 then  -- Plains to Tundra 5%
						plot:SetTerrainType(3, false, true)
					elseif rand <= 95 and ter == 6 and feat == -1 then -- Sea to Ice
						plot:SetFeatureType(0, false, true)
					end
				end
			end	
			for x = 68, 107, 1 do				-- east of Murmansk
				for y = 81, 90, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if ter == 0 then  -- Grassland to Snow 100%
						plot:SetTerrainType(4)
					elseif ter == 3 then -- Tundra to Snow 100%
						plot:SetTerrainType(4)
					elseif ter == 1 then  -- Plains to Snow 100%
						plot:SetTerrainType(4)
					elseif rand <= 95 and ter == 5 and feat == -1 then -- Coastal to Ice 50%
						plot:SetFeatureType(0)
					elseif rand <= 95 and ter == 6 and feat == -1 then -- Sea to Ice
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 0, 49, 1 do				-- west of Stockholm
				for y = 71, 80, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 95 and ter == 0 then  -- Grassland to Snow 95%
						plot:SetTerrainType(4)
					elseif rand > 95 and ter == 0 then  -- Grassland to Tundra 5%
						plot:SetTerrainType(3)
					elseif ter == 3 then -- Tundra to Snow 100%
						plot:SetTerrainType(4)
					elseif rand <= 95 and ter == 1 then  -- Plains to Snow 95%
						plot:SetTerrainType(4)
					elseif rand > 95 and ter == 1 then  -- Plains to Tundra 5%
						plot:SetTerrainType(3)
					elseif rand <= 95 and ter == 6 and feat == -1 then -- Sea to Ice 95%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 50, 107, 1 do				-- east of Stockholm
				for y = 71, 80, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if ter == 0 then  -- Grassland to Snow 100%
						plot:SetTerrainType(4)
					elseif ter == 3 then -- Tundra to Snow 100%
						plot:SetTerrainType(4)
					elseif ter == 1 then  -- Plains to Snow 100%
						plot:SetTerrainType(4)
					elseif rand <= 90 and ter == 5 and feat == -1 then -- Coastal to Ice 90%
						plot:SetFeatureType(0)
					elseif rand <= 90 and ter == 6 and feat == -1 then -- Sea to Ice 90%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 0, 49, 1 do				-- west of Stockholm
				for y = 61, 70, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 85 and ter == 0 then  -- Grassland to Snow 85%
						plot:SetTerrainType(4)
					elseif rand > 85 and ter == 0 then  -- Grassland to Tundra 15%
						plot:SetTerrainType(3)
					elseif rand <= 90 and ter == 3 then -- Tundra to Snow 90%
						plot:SetTerrainType(4)
					elseif rand <= 85 and ter == 1 then  -- Plains to Snow 85%
						plot:SetTerrainType(4)
					elseif rand > 85 and ter == 1 then  -- Plains to Tundra 15%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 6 and feat == -1 then -- Sea to Ice 50%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 50, 107, 1 do				-- east of Stockholm
				for y = 61, 70, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 90 and ter == 0 then  -- Grassland to Snow 90%
						plot:SetTerrainType(4)
					elseif rand > 90 and ter == 0 then  -- Grassland to Tundra 10%
						plot:SetTerrainType(3)
					elseif rand <= 95 and ter == 3 then -- Tundra to Snow 95%
						plot:SetTerrainType(4)
					elseif rand <= 90 and ter == 1 then  -- Plains to Snow 90%
						plot:SetTerrainType(4)
					elseif rand > 90 and ter == 1 then  -- Plains to Tundra 10%
						plot:SetTerrainType(3)
					elseif rand <= 95 and ter == 5 and feat == -1 then -- Coastal to Ice 95%
						plot:SetFeatureType(0)
					elseif rand <= 95 and ter == 6 and feat == -1 then -- Sea to Ice 95%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 0, 49, 1 do				-- west of Stockholm
				for y = 51, 60, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 50 and ter == 0 then  -- Grassland to Snow 50%
						plot:SetTerrainType(4)
					elseif rand > 50 and ter == 0 then  -- Grassland to Tundra 50%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 3 then -- Tundra to Snow 50%
						plot:SetTerrainType(4)
					elseif rand <= 50 and ter == 1 then  -- Plains to Snow 50%
						plot:SetTerrainType(4)
					elseif rand > 50 and ter == 1 then  -- Plains to Tundra 50%
						plot:SetTerrainType(3)
					elseif rand <= 10 and ter == 6 and feat == -1 then -- Sea to Ice 10%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 50, 107, 1 do				-- east of Stockholm
				for y = 51, 60, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 80 and ter == 0 then  -- Grassland to Snow 80%
						plot:SetTerrainType(4)
					elseif rand > 80 and ter == 0 then  -- Grassland to Tundra 20%
						plot:SetTerrainType(3)
					elseif rand <= 85 and ter == 3 then -- Tundra to Snow 85%
						plot:SetTerrainType(4)
					elseif rand <= 80 and ter == 1 then  -- Plains to Snow 80%
						plot:SetTerrainType(4)
					elseif rand > 80 and ter == 1 then  -- Plains to Tundra 20%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 5 and feat == -1 then -- Coastal to Ice 50%
						plot:SetFeatureType(0)
					elseif rand <= 50 and ter == 6 and feat == -1 then -- Sea to Ice 50%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 0, 40, 1 do				-- west of Kiel
				for y = 41, 50, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 30 and ter == 0 then  -- Grassland to Snow 30%
						plot:SetTerrainType(4)
					elseif rand > 30 and ter == 0 then  -- Grassland to Tundra 70%
						plot:SetTerrainType(3)
					elseif rand <= 30 and ter == 3 then -- Tundra to Snow 30%
						plot:SetTerrainType(4)
					elseif rand <= 30 and ter == 1 then  -- Plains to Snow 30%
						plot:SetTerrainType(4)
					elseif rand > 30 and ter == 1 then  -- Plains to Tundra 70%
						plot:SetTerrainType(3)
					end
				end
			end	
			for x = 41, 107, 1 do				-- east of Kiel
				for y = 41, 50, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 50 and ter == 0 then  -- Grassland to Snow 50%
						plot:SetTerrainType(4)
					elseif rand > 50 and ter == 0 then  -- Grassland to Tundra 50%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 3 then -- Tundra to Snow 50%
						plot:SetTerrainType(4)
					elseif rand <= 50 and ter == 1 then  -- Plains to Snow 50%
						plot:SetTerrainType(4)
					elseif rand > 50 and ter == 1 then  -- Plains to Tundra 50%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 5 and feat == -1 then -- Coastal to Ice 50%
						plot:SetFeatureType(0)
					elseif rand <= 50 and ter == 6 and feat == -1 then -- Sea to Ice 50%
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 0, 40, 1 do				-- west of Kiel
				for y = 37, 40, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 10 and ter == 0 then  -- Grassland to Snow 10%
						plot:SetTerrainType(4)
					elseif rand > 10 and ter == 0 then  -- Grassland to Tundra 90%
						plot:SetTerrainType(3)
					elseif rand <= 30 and ter == 3 then -- Tundra to Snow 30%
						plot:SetTerrainType(4)
					elseif rand <= 10 and ter == 1 then  -- Plains to Snow 10%
						plot:SetTerrainType(4)
					elseif rand > 10 and ter == 1 then  -- Plains to Tundra 90%
						plot:SetTerrainType(3)
					end
				end
			end	
			for x = 41, 107, 1 do				-- east of Kiel
				for y = 37, 40, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 25 and ter == 0 then  -- Grassland to Snow 25%
						plot:SetTerrainType(4)
					elseif rand > 25 and ter == 0 then  -- Grassland to Tundra 75%
						plot:SetTerrainType(3)
					elseif rand <= 50 and ter == 3 then -- Tundra to Snow 50%
						plot:SetTerrainType(4)
					elseif rand <= 25 and ter == 1 then  -- Plains to Snow 25%
						plot:SetTerrainType(4)
					elseif rand > 25 and ter == 1 then  -- Plains to Tundra 75%
						plot:SetTerrainType(3)
					elseif rand <= 25 and ter == 5 and feat == -1 then -- Coastal to Ice 25%
						plot:SetFeatureType(0)
					elseif rand <= 25 and ter == 6 and feat == -1 then -- Sea to Ice 25%
						plot:SetFeatureType(0)
					end
				end
			end
			for x = 46, 107, 1 do				-- east of Zagreb
				for y = 31, 36, 1 do
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local ter = plot:GetTerrainType();
					local feat = plot:GetFeatureType();
					local rand = math.random( 1, 100 )
					if rand <= 20 and ter == 0 then  -- Grassland to Snow 20%
						plot:SetTerrainType(4)
					elseif rand > 20 and ter == 0 then  -- Grassland to Tundra 80%
						plot:SetTerrainType(3)
					elseif rand <= 30 and ter == 3 then -- Tundra to Snow 30%
						plot:SetTerrainType(4)
					elseif rand <= 20 and ter == 1 then  -- Plains to Snow 20%
						plot:SetTerrainType(4)
					elseif rand > 20 and ter == 1 then  -- Plains to Tundra 80%
						plot:SetTerrainType(3)
					end
				end
			end
			WINTERTIME = 2
		end
	end
end

-- Partisan table
g_Partisan = { 
		[1] = {
		Group = {FR_PARTISAN},
		SpawnList = { {X=21, Y=44}, {X=22, Y=44}, {X=22, Y=40}, {X=23, Y=47}, {X=27, Y=45}, {X=27, Y=47}, {X=24, Y=45}, {X=26, Y=48}, {X=28, Y=43},  {X=28, Y=44}, {X=29, Y=38}, {X=31, Y=48},  {X=29, Y=43}, {X=29, Y=46}, {X=29, Y=44},  {X=30, Y=48}, {X=31, Y=48}, {X=33, Y=43}, {X=33, Y=46}, {X=34, Y=45}, },
		RandomSpawn = true, -- true : random choice in spawn list
		CivID = FRANCE,
		Frequency = 10, -- probability (in percent) of partisan spawning at each turn
		Condition = NorthFranceInvaded, -- Must refer to a function, remove this line to use the default condition (true)
		},
	}