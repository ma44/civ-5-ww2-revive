-- ScriptAmericaEuro1936
-- Author: Gedemon
-- DateCreated: 8/23/2011 10:36:46 PM
--------------------------------------------------------------

print("Loading America/Europe 1936 Scripts...")
print("-------------------------------------")


-----------------------------------------
-- Planned Events
-----------------------------------------

-- End of Vichy France

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
g_Albania_Land_Ratio = 1
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


	local initialNorway, initialEgypt, initialAlbania = 0, 0, 0
	local actualNorway, actualEgypt, actualAlbania = 0, 0, 0

	local iNorway = GetPlayerIDFromCivID (NORWAY, true, true)
	local iAlbania = GetPlayerIDFromCivID (ALBANIA, true, true)

	
	local initialFrance = 0
	local actualFrance = 0
	local initialUSSR = 0
	local actualUSSR = 0

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	
	local territoryMap = LoadTerritoryMap()

	for i, data in pairs (territoryMap) do
		local originalOwner = data.PlayerID
		if originalOwner == iNorway then
			initialNorway = initialNorway + 1

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

		elseif owner == iAlbania then
			actualAlbania = actualAlbania + 1	

		elseif owner == iFrance then
			actualFrance = actualFrance + 1
			
		elseif owner == iUSSR then
			actualUSSR = actualUSSR + 1
		end
	end
	g_Norway_Land_Ratio = actualNorway / initialNorway
	Dprint ("Norway land ratio:	"..g_Norway_Land_Ratio, bDebug)
	g_Albania_Land_Ratio = actualAlbania / initialAlbania
	Dprint ("Albania land ratio: "..g_Albania_Land_Ratio, bDebug)
	g_France_Land_Ratio = actualFrance / initialFrance
	Dprint ("France land ratio:	"..g_France_Land_Ratio, bDebug)
	g_USSR_Land_Ratio = actualUSSR / initialUSSR
	Dprint ("USSR land ratio: "..g_USSR_Land_Ratio, bDebug)

	for x = 103, 127, 1 do
		for y = 0, 7, 1 do				--Territory of British Egypt
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iUK then 
				initialEgypt = initialEgypt + 1			
			end
			if GetPlotFirstOwner(plotKey) == iUK and plot:GetOwner() == iUK then 
				actualEgypt = actualEgypt + 1
			end

		end
	end 

	g_Egypt_Land_Ratio = actualEgypt / initialEgypt
	Dprint ("Egypt land ratio: "..g_Egypt_Land_Ratio, bDebug)

	local t_end = os.clock()
	Dprint("  - Total time :		" .. t_end - t_start .. " s")
end

-----------------------------------------
-- Annexation of Austria
-----------------------------------------
function AustriaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19380302 <= turnDate and 19380302 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Austria Annexed !")

		local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
		local pGermany = Players[iGermany]
			
		local team = Teams[ pGermany:GetTeam() ]
		Dprint("- Germany Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("AustriaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Austria script ...")

			local iAustria = GetPlayerIDFromCivID (AUSTRIA, true, true)
			local pAustria = Players[iAustria]

			for unit in pAustria:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Austria cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iAustria and originalOwner ~= iAustria then -- liberate cities captured by Austria
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iAustria then
						if (x > 1 and x < 115)  then -- Germany
							Dprint(" - " .. city:GetName() .. " is in Germany sphere...")	
							if city:GetOwner() ~= iGermany then 
								pGermany:AcquireCity(city, false, true)
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
					if originalOwner ~= iAustria and ownerID == iAustria then -- liberate plot captured by Austria
						plot:SetOwner(originalOwner, -1 ) 								 
					elseif originalOwner == iAustria and (x > 1 and x < 115)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 
					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "Austria has fallen subject to German Anschluss.", "Germany is now united with Austria!",-1, -1)

			savedData.SetValue("AustriaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of Czechoslovakia
-----------------------------------------

function CzechAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19380316 <= turnDate and 19380316 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Czechoslovakia Annexed !")

		local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
		local pGermany = Players[iGermany]
			
		local team = Teams[ pGermany:GetTeam() ]
		Dprint("- Germany Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("CzechoslovakiaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Czechoslovakia script ...")

			local iCzechoslovakia = GetPlayerIDFromCivID (CZECHOSLOVAKIA, true, true)
			local pCzechoslovakia = Players[iCzechoslovakia]

			local iSlovakia = GetPlayerIDFromCivID (SLOVAKIA, true, true)
			local pSlovakia = Players[iSlovakia]

			local iHungary = GetPlayerIDFromCivID (HUNGARY, true, true)
			local pHungary = Players[iHungary]

			for unit in pCzechoslovakia:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Czech cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iCzechoslovakia and originalOwner ~= iCzechoslovakia then -- liberate cities captured by Czechoslovakia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iCzechoslovakia then
						if (x > 1 and x < 93)  then -- Germany
							Dprint(" - " .. city:GetName() .. " is in Germany sphere...")	
							if city:GetOwner() ~= iGermany then 
								pGermany:AcquireCity(city, false, true)
								city:SetPuppet(false)
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							else -- just remove resistance if city was already occupied
								city:ChangeResistanceTurns(-city:GetResistanceTurns())
							end
						elseif (x > 93 and x < 98)  then -- Slovakia
								Dprint(" - " .. city:GetName() .. " is in Slovakia sphere...")	
								if city:GetOwner() ~= iSlovakia then 
									pSlovakia:AcquireCity(city, false, true)
									city:SetPuppet(false)
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								else -- just remove resistance if city was already occupied
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								end
						elseif (x > 98 and x < 110)  then -- Hungary
								Dprint(" - " .. city:GetName() .. " is in Hungary sphere...")	
								if city:GetOwner() ~= iHungary then 
									pHungary:AcquireCity(city, false, true)
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
					if originalOwner ~= iCzechoslovakia and ownerID == iCzechoslovakia then -- liberate plot captured by Czechoslovakia
						plot:SetOwner(originalOwner, -1 ) 								 
					elseif originalOwner == iCzechoslovakia and (x > 1 and x < 93)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 

					elseif originalOwner == iCzechoslovakia and (x > 93 and x < 98)  then -- Slovakia territory
						plot:SetOwner(iSlovakia, -1 ) 

					elseif originalOwner == iCzechoslovakia and (x > 98 and x < 110)  then -- Hungary territory
						plot:SetOwner(iHungary, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "Germany has now united with Czechia and created the Puppet Regime Slovakia.", "Annexation of Czechoslovakia!", -1, -1)
			savedData.SetValue("CzechoslovakiaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of Albania
-----------------------------------------
function AlbaniaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19390407 <= turnDate and 19390407 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Albania Annexed !")

		local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
		local pItaly = Players[iItaly]
			
		local team = Teams[ pItaly:GetTeam() ]
		Dprint("- Italy Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("AlbaniaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Albania script ...")

			local iAlbania = GetPlayerIDFromCivID (ALBANIA, true, true)
			local pAlbania = Players[iAlbania]

			for unit in pAlbania:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Albania cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iAlbania and originalOwner ~= iAlbania then -- liberate cities captured by Albania
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iAlbania then
						if (x > 1 and x < 115)  then -- Italy
							Dprint(" - " .. city:GetName() .. " is in Italian sphere...")	
							if city:GetOwner() ~= iItaly then 
								pItaly:AcquireCity(city, false, true)
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
					if originalOwner ~= iAlbania and ownerID == iAlbania then -- liberate plot captured by Albania
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iAlbania and (x > 1 and x < 115)  then -- Italy territory
						plot:SetOwner(iItaly, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "Italy has now united with Albania.", "Annexation of Albania!", -1, -1)

			savedData.SetValue("AlbaniaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of Lithuania
-----------------------------------------
function LithuaniaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19400615 <= turnDate and 19400615 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Lithuania Annexed !")

		local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
		local pUSSR = Players[iUSSR]
			
		local team = Teams[ pUSSR:GetTeam() ]
		Dprint("- USSR Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("LithuaniaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Lithuania script ...")

			local iLithuania = GetPlayerIDFromCivID (LITHUANIA, true, true)
			local pLithuania = Players[iLithuania]

			for unit in pLithuania:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Lithuania cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iLithuania and originalOwner ~= iLithuania then -- liberate cities captured by Lithuania
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iLithuania then
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
					if originalOwner ~= iLithuania and ownerID == iLithuania then -- liberate plot captured by Lithuania
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iLithuania and (x > 1 and x < 115)  then -- USSR territory
						plot:SetOwner(iUSSR, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pLithuania:GetName() .. " has fallen to USSR, USSR has annexed Lithuania.", pLithuania:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("LithuaniaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of Latvia
-----------------------------------------
function LatviaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19400616 <= turnDate and 19400616 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Latvia Annexed !")

		local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
		local pUSSR = Players[iUSSR]
			
		local team = Teams[ pUSSR:GetTeam() ]
		Dprint("- USSR Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("LatviaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Latvia script ...")

			local iLatvia = GetPlayerIDFromCivID (LATVIA, true, true)
			local pLatvia = Players[iLatvia]

			for unit in pLatvia:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Latvia cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iLatvia and originalOwner ~= iLatvia then -- liberate cities captured by Latvia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iLatvia then
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
					if originalOwner ~= iLatvia and ownerID == iLatvia then -- liberate plot captured by Latvia
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iLatvia and (x > 1 and x < 115)  then -- USSR territory
						plot:SetOwner(iUSSR, -1 ) 
					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pLatvia:GetName() .. " has fallen to USSR, USSR has annexed Latvia.", pLatvia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("LatviaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of Estonia
-----------------------------------------
function EstoniaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19400616 <= turnDate and 19400616 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Estonia Annexed !")

		local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
		local pUSSR = Players[iUSSR]
			
		local team = Teams[ pUSSR:GetTeam() ]
		Dprint("- USSR Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("EstoniaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Estonia script ...")

			local iEstonia = GetPlayerIDFromCivID (ESTONIA, true, true)
			local pEstonia = Players[iEstonia]

			for unit in pEstonia:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Estonia cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iEstonia and originalOwner ~= iEstonia then -- liberate cities captured by Estonia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iEstonia then
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
					if originalOwner ~= iEstonia and ownerID == iEstonia then -- liberate plot captured by Estonia
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iEstonia and (x > 1 and x < 115)  then -- USSR territory
						plot:SetOwner(iUSSR, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pEstonia:GetName() .. " has fallen to USSR, USSR has annexed Estonia.", pEstonia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("EstoniaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Fall of France
-----------------------------------------
function NorthFranceInvaded()
	local bDebug = false
	local Dunkerque = GetPlot(74, 50):GetPlotCity()	-- Dunkerque
	local Metz = GetPlot(79, 46):GetPlotCity()		-- Metz
	local Mulhouse = GetPlot(78, 42):GetPlotCity()	-- Mulhouse
	local Reims = GetPlot(76, 46):GetPlotCity()		-- Reims
	local Paris = GetPlot(73, 45):GetPlotCity()		-- Paris
	local Caen = GetPlot(69, 47):GetPlotCity()		-- Caen
	if (Dunkerque:IsOccupied() and Metz:IsOccupied() and Mulhouse:IsOccupied() and Reims:IsOccupied() and Paris:IsOccupied() and Caen:IsOccupied()) then
		Dprint ("North France is occupied", bDebug)
		return true
	else
		Dprint ("North France is not occupied", bDebug)
		return false
	end
end

function NorthAfricaInvaded()
	local bDebug = false
	local Algier = GetPlot(66, 21):GetPlotCity()		-- Algier
	local Oran = GetPlot(60, 20):GetPlotCity()			-- Oran
	local Casablanca = GetPlot(49, 17):GetPlotCity()	-- Casablanca
	local Rabat= GetPlot(52, 18):GetPlotCity()			-- Rabat
	if (Algier:IsOccupied() and Oran:IsOccupied() and Casablanca:IsOccupied() and Rabat:IsOccupied()) then
		Dprint ("French Africa is occupied", bDebug)
		return true
	else
		Dprint ("French Africa is still free", bDebug)
		return false
	end
end

function NorthAfricaLiberated()
	local bDebug = false
	local Tobruk		= GetPlot(101, 5):GetPlotCity()		-- Tobruk
	local Tripolis		= GetPlot(84, 7):GetPlotCity()		-- Tripolis
	local Benghazi		= GetPlot(96, 5):GetPlotCity()		-- Benghazi
	local Sirte			= GetPlot(89, 3):GetPlotCity()		-- Sirte
	local Algier		= GetPlot(66, 21):GetPlotCity()		-- Algier
	local Oran			= GetPlot(60, 20):GetPlotCity()		-- Oran
	local Casablanca	= GetPlot(49, 17):GetPlotCity()		-- Casablanca
	local Rabat			= GetPlot(52, 18):GetPlotCity()		-- Rabat
	local Tunis			= GetPlot(78, 17):GetPlotCity()		-- Tunis
	local Marrakech		= GetPlot(49, 14):GetPlotCity()		-- Marrakech
	local Gabes			= GetPlot(78, 10):GetPlotCity()		-- Gabes

	
	if (Tobruk:IsOccupied() and Tripolis:IsOccupied() and Benghazi:IsOccupied()and Sirte:IsOccupied()) then
		if (Algier:IsOccupied() or Oran:IsOccupied() or Casablanca:IsOccupied() or Rabat:IsOccupied()or Tunis:IsOccupied()or Marrakech:IsOccupied()or Gabes:IsOccupied()) then
			Dprint ("French Africa is still occupied", bDebug)
			return false
		else
			Dprint ("French Africa is liberated", bDebug)
			return true
		end
	else
		Dprint ("Libya is still occupied", bDebug)
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
	if x == 73 and y == 45 then -- city of Paris
	
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
	local cityPlot = GetPlot (73,45)
	local pParis = cityPlot:GetPlotCity()
	local pAxis = g_CapturingPlayer
	local iAxis = pAxis:GetID()
	g_CapturingPlayer = nil
	--

	savedData.SetValue("FranceHasFallen", 1) 

	local iVichy = GetPlayerIDFromCivID (VICHY, true, true)
	local pVichy = Players[iVichy]

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
	local DamascusPlot = GetPlot (125,9)
	local Damascus = DamascusPlot:GetPlotCity()
	if Damascus:GetOwner() ~= iFrance then -- give back Damascus to France
		EscapeUnitsFromPlot(DamascusPlot)
		Players[iFrance]:AcquireCity(Damascus, false, true)
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, Damascus:GetName() .. " has revolted and is joigning Free France.", Damascus:GetName() .. " has revolted !", -1, -1)
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

		else  -- transfer to Damascus
			data.Unit:SetXY(125,9) -- Damascus
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

		else  -- transfer to Damascus
			data.Unit:SetXY(125,9) -- Damascus
		
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
			if rand <= 50 then -- 50% chance to follow governement in Vichy
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

			-- liberate plot captured by France
			if originalOwner ~= iFrance and ownerID == iFrance then
				plot:SetOwner(originalOwner, -1 ) 

			-- occupied territory
			elseif ownerID ~= iVichy and originalOwner == iFrance and ((x < 69 and y > 32) or (y > 42 and x < 78)) then 
				Dprint("(".. x ..",".. y ..") = Plot in occupied territory")
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
			elseif originalOwner == iFrance and ((y > 32 and x < 77))  then 
				Dprint("(".. x ..",".. y ..") = Plot in Vichy territory")
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
			elseif originalOwner == iFrance and (y > 26 and x > 76 and y < 38 and x < 81) then
				Dprint("(".. x ..",".. y ..") = Plot in Italy occupied territory")
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
			elseif originalOwner == iFrance and (y > 39 and x > 76 and y < 47 and x < 82) then 
				Dprint("(".. x ..",".. y ..") = Plot in Germany occupied territory")
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
				
	coroutine.yield()
				
	Dprint("Updating war/peace ...", bDebug)		
	
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
	if x == 98 and y == 48 then -- city of Warsaw 
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

							elseif originalOwner == iPoland and (x > 91 and x < 95)  then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end

							elseif originalOwner == iPoland and (x > 94 and x < 100) then -- Central territory
								if plot:IsCity() and ownerID ~= newPlayerID then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pAxis:AcquireCity(city, false, true)
								else
									plot:SetOwner(newPlayerID, -1 ) 
								end 

							elseif originalOwner == iPoland and (x > 99 and x < 106) then -- USSR Territory
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

	if x == 88 and y == 57 or x == 85 and y == 59 then -- Copenhagen, Aalborg 
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

						elseif originalOwner == iDenmark and (x > 82)  then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end 

						elseif originalOwner == iDenmark and (x < 82) and ownerID == iDenmark then -- Denmark to UK
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
	local bDebug = false
	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local safe = true
	for x = 64, 76, 1 do
		for y = 51, 70, 1 do
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iUK and plot:GetOwner() ~= iUK then -- one of UK plot has been conquered
				safe = false 
				Dprint("- U.K. is not safe!", bDebug)
			end
		end
	end 
	return safe
end

function IsSuezAlly()
	local suezPlot = GetPlot(118,2) -- Suez
	if suezPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
	end
end

function IsSuezOccupied()
	local suezPlot = GetPlot(118,2) -- Suez
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
	local bDebug = false
	local CataniaPlot = GetPlot(87,17) -- Catania
	local PalermoPlot = GetPlot(85,19) -- Palermo

	if CataniaPlot:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) and PalermoPlot:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) then
		Dprint ("Sicily is not occupied", bDebug)
		return false
	else
		Dprint ("Sicily is occupied", bDebug)
		return true
	end
end

function ReadyForOverlord()
	local bDebug = false

	if not UKIsSafe() then
		Dprint ("UK is not safe!", bDebug)
		return false
	end
	if not NorthFranceInvaded() then
		Dprint ("North France is not occupied", bDebug)
		return false
	end
	if turnDate < 19411210 then
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
	for x = 77, 93, 1 do
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
	local Benghazi = GetPlot(96,5):GetPlotCity()		-- Benghazi
	local Tripoli = GetPlot(84,7):GetPlotCity()			-- Tripoli
	if (Benghazi:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) and (Tripoli:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) )) then
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
	for x = 80, 98, 1 do
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

function IsGermanyAtWarWithYugoslavia()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(YUGOSLAVIA, true)) then
		Dprint("      - Germany is not at war with Yugoslavia...", bDebug)
		return false
	end
	return true
end

function IsGermanyAtWarWithGreece()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(GREECE, false)) then
		Dprint("      - Germany is not at war with Greece...", bDebug)
		return false
	end
	return true
end

-----------------------------------------
-- USSR
-----------------------------------------

function StalingradOccupied()
	local Stalingrad = GetPlot(127, 47):GetPlotCity()		-- Stalingrad
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
				
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, " America has passed the Lend Lease Act, France, the United Kingdom and the USSR will recieve extra convoys.", "Lend Lease Act Passed!")
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- Convoy routes
----------------------------------------------------------------------------------------------------------------------------

-- first define the condition and transport functions that will be stocked in the g_Convoy table... 
function IsRouteOpenUStoFrance()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to France", bDebug)
	local turn = Game.GetGameTurn()
	if g_Calendar[turn] then 
		turnDate = g_Calendar[turn].Number
	 else 
		turnDate = 0
	end
--	if turnDate < 194000101 then
	if turnDate < 0 then -- testing
		return false
	end
	local open = false
	local destinationList = g_Convoy[US_TO_FRANCE].DestinationList
	for i, destination in ipairs(destinationList) do -- the convoy spawning function do almost the same test, may be removed ?
		local plot = GetPlot (destination.X, destination.Y )
		Dprint("      - Testing plot at : " .. destination.X .. "," .. destination.Y , bDebug)
		if plot:IsCity() then
			local city = plot:GetPlotCity()
			Dprint("      - Plot is city...", bDebug)
			if city:GetOwner() == GetPlayerIDFromCivID( FRANCE, false ) and not city:IsBlockaded() then
				Dprint("      - " .. city:GetName() .. " is owned by france and not blockaded !", bDebug)
				open = true
			end
		end
	end
	return open
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
	local plotMurmansk = GetPlot(110,85)
	local plotMoscow = GetPlot(117,58)
	local ussr = Players[GetPlayerIDFromCivID(USSR, false)]

	return isPlotConnected( ussr , plotMurmansk, plotMoscow, "Road", false, nil , PathBlocked)
	
end

function IsRailOpenSueztoStalingrad()
	local plotSuez = GetPlot(118,2)
	local plotStalingrad = GetPlot(127,47)
	local ussr = Players[GetPlayerIDFromCivID(USSR, false)]
	
	return isPlotConnected( ussr , plotSuez, plotStalingrad, "Road", false, nil , PathBlocked)
	
end

function IsRouteOpenLendLease()
	local bDebug = false
	Dprint("   - Checking possible maritime route from US to France", bDebug)
	local turn = Game.GetGameTurn()
	if g_Calendar[turn] then 
		turnDate = g_Calendar[turn].Number
	 else 
		turnDate = 0
	end
	if turnDate < 19410320 then
		return false
	else
		return true
	end
end

function IsRouteOpenFinlandtoGermany()

	local bDebug = false

	local month = TurnToMonth()
	if month > 10 or month < 4 then
		return false -- assume North of Baltic Sea is frozen from November to Mars
	end
	Dprint("     - Baltic Sea is not frozen...", bDebug)
	
	local plotOulu = GetPlot(103,77)
	local plotInari = GetPlot(104,83)
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

	local plotKiruna = GetPlot(98,81)
	local plotNarvik = GetPlot(96,85)
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

	local plotKiruna = GetPlot(98,81)
	local plotLulea = GetPlot(100,78)
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
	local rand = math.random( 1, 4 )
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
		transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	elseif rand > 4 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	
	return transport
end

function GetSueztoUSTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300}
	elseif rand > 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end	
	
	return transport
end

function GetPanamatoUSTransport()
	local rand = math.random( 1, 3 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 150} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 250}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 350}	
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
		transport = {Type = TRANSPORT_MATERIEL, Reference = 200 * factor} 
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 200 * factor} 
	elseif rand == 5 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200 * factor} 	
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
		transport = {Type = TRANSPORT_GOLD, Reference = 300 * factor} 
	elseif rand == 5 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300 * factor} 	
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
US_TO_FRANCE = 1
US_TO_FRANCE_2 = 2
US_TO_UK = 3
US_TO_UK_2 = 4
US_TO_UK_3 = 5
FINLAND_TO_GERMANY = 6
SUEZ_TO_UK = 7
SUEZ_TO_UK_2 = 8
SUEZ_TO_FRANCE = 9
SUEZ_TO_ITALY = 10
US_TO_USSR = 11
US_TO_USSR_2 = 12
NORWAY_TO_GERMANY = 13
SWEDEN_TO_GERMANY = 14
SUEZ_TO_US = 15
SUEZ_TO_USSR		= 16
AFRICA_TO_FRANCE	= 17
AFRICA_TO_ITALY		= 18
CARAIB_TO_FRANCE	= 19
CARAIB_TO_UK		= 20
US_TO_UK_USAF1		= 21
US_TO_UK_USAF_RES	= 22
US_TO_FR_ARMY1		= 23
US_TO_FR_ARMY_RES	= 24
US_TO_UK_ARMY1		= 25

-- Convoy table
g_Convoy = { 
	[US_TO_FRANCE] = {
		Name = "US to France",
		SpawnList = { {X=3, Y=36}, {X=4, Y=38}, {X=3, Y=37}, {X=4, Y=37}, }, -- Adjacent Philadelphia
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=42}, {X=66, Y=45}, {X=74, Y=50}, {X=74, Y=34}, {X=49, Y=17}, {X=52, Y=18}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille, Casablanca, Rabbat
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFrance, -- Must refer to a function, remove this line to use the default condition (true)
		UnloadCondition = function() return true; end, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_FRANCE_2] = {
		Name = "US to France",
		SpawnList = { {X=3, Y=36}, {X=4, Y=38}, {X=3, Y=37}, {X=4, Y=37}, }, -- Adjacent Philadelphia
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=42}, {X=66, Y=45}, {X=74, Y=50}, {X=74, Y=34}, {X=49, Y=17}, {X=52, Y=18}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille, Casablanca, Rabbat
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, -- Must refer to a function, remove this line to use the default condition (true)
		--UnloadCondition = function() return true; end, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_UK] = {
		Name = "US to UK",
		SpawnList = { {X=4, Y=41}, {X=5, Y=44}, {X=4, Y=39}, {X=7, Y=44}, }, -- Adjacent to New York, Boston,
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, {X=55, Y=24},}, -- Plymouth, Liverpool, London, Aberdeen, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		-- Condition = IsRouteOpenUStoUK, -- no special condition here, let the spawning function do the job...
		Transport = GetUStoUKTransport,
	},
	[US_TO_UK_2] = {
		Name = "US to UK",
		SpawnList = { {X=4, Y=41}, {X=5, Y=44}, {X=4, Y=39}, {X=7, Y=44}, }, -- Adjacent to New York, Boston,
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, {X=55, Y=24},}, -- Plymouth, Liverpool, London, Aberdeen, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetUStoUKTransport,
	},
	[US_TO_UK_3] = {
		Name = "US to UK",
		SpawnList = { {X=4, Y=41}, {X=5, Y=44}, {X=4, Y=39}, {X=7, Y=44}, }, -- Adjacent to New York, Boston,
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, {X=55, Y=24},}, -- Plymouth, Liverpool, London, Aberdeen, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetUStoUKTransport,
	},
	[FINLAND_TO_GERMANY] = {
		Name = "Finland to Germany",
		SpawnList = { {X=101, Y=77}, }, -- adjacent to Oulu
		RandomSpawn = false,
		DestinationList = { {X=97, Y=53}, {X=91, Y=52}, {X=86, Y=54}, }, -- Konigsberg, Stettin, Kiel
		RandomDestination = false,
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsRouteOpenFinlandtoGermany,
		Transport = GetFinlandtoGermanyTransport,
	},
	[SUEZ_TO_UK] = {
		Name = "Suez to UK",
		SpawnList = { {X=118, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=66, Y=62},}, -- Plymouth, Liverpool, London, Belfast
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoUKTransport,
	},
	[SUEZ_TO_UK_2] = {
		Name = "Suez to UK",
		SpawnList = { {X=118, Y=7}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=66, Y=62},}, -- Plymouth, Liverpool, London, Belfast
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoUKTransport,
	},
	[SUEZ_TO_FRANCE] = {
		Name = "Suez to France",
		SpawnList = { {X=119, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=74, Y=34}, {X=78, Y=34}, {X=78, Y=27}, }, -- Marseille, Nizza, Ajaccio
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoFranceTransport,
	},
	[SUEZ_TO_ITALY] = {
		Name = "Suez to Italy",
		SpawnList = { {X=117, Y=5}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=89, Y=19}, {X=86, Y=25}, {X=84, Y=28}, {X=80, Y=34},}, -- Reggio Calabria, Naples, Rome, Genova
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ITALY,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezOccupied,
		Transport = GetSueztoItalyTransport,
	},
	[US_TO_USSR] = {
		Name = "US to USSR",
		SpawnList = { {X=4, Y=39}, {X=5, Y=44}, {X=3, Y=37}, {X=9, Y=3}, }, -- Adjacent to New York, Boston, Philadelphia, Miami
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=110, Y=85}, {X=115, Y=78},}, -- Murmansk, Archangelsk
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenMurmansktoMoscow,
		Transport = GetSueztoUSSRTransport,
	},
	[US_TO_USSR_2] = {
		Name = "US to USSR",
		SpawnList = { {X=1, Y=33}, {X=5, Y=45}, {X=3, Y=28}, {X=3, Y=27}, }, -- Adjacent to Baltimore, Boston, Virginia Beach
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=110, Y=85}, {X=115, Y=78},}, -- Murmansk, Archangelsk
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetSueztoUSSRTransport,
	},
	[NORWAY_TO_GERMANY] = {
		Name = "Norway to Germany",
		SpawnList = { {X=95, Y=85}, }, -- adjacent to Narvik
		RandomSpawn = false,
		DestinationList = { {X=85, Y=55}, {X=84, Y=53}, {X=91, Y=52},}, -- Kiel, Stettin, Hamburg
		RandomDestination = false, -- false : sequential try in destination list
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsRouteOpenNorwaytoGermany,
		Transport = GetNorwaytoGermanyTransport,
	},
	[SWEDEN_TO_GERMANY] = {
		Name = "Sweden to Germany",
		SpawnList = { {X=100, Y=77}, }, -- adjacent to Lulea
		RandomSpawn = false,
		DestinationList = { {X=97, Y=53}, {X=91, Y=52}, {X=85, Y=55}, }, -- Konigsberg, Stettin, Kiel
		RandomDestination = false,
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsRouteOpenSwedentoGermany, 
		Transport = GetFinlandtoGermanyTransport, -- re-use Finland values...
	},
	[SUEZ_TO_US] = {
		Name = "Suez to America",
		SpawnList = { {X=118, Y=6}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=3, Y=40}, }, -- New York
		RandomDestination = false, -- false : sequential try in destination list
		CivID = AMERICA,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoUSTransport,
	},
	[SUEZ_TO_USSR] = {
		Name = "Suez to USSR",
		SpawnList = { {X=118, Y=6}, }, -- Suez
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=123, Y=38}, }, -- Rostow
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_SUEZ_TO_USSR"},
		MaxFleet = 5,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenRostowtoStalingrad,
		Transport = GetSueztoUSSRTransport,
	},
	[AFRICA_TO_FRANCE] = {
		Name = "Africa to France",
		SpawnList = { {X=49, Y=18}, {X=67, Y=22}, {X=79, Y=18}, }, -- adjacent to Casablanca, Alger, Tunis
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=74, Y=34}, {X=78, Y=34}, {X=78, Y=27}, }, -- Marseille, Nizza, Ajaccio
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},
	[AFRICA_TO_ITALY] = {
		Name = "Africa to Italy",
		SpawnList = { {X=85, Y=8}, {X=96, Y=6}, }, -- adjacent to Tripoli, Benghazi
		RandomSpawn = true,
		DestinationList = { {X=89, Y=19}, {X=86, Y=25}, {X=84, Y=28}, {X=91, Y=24}, {X=80, Y=34},}, -- Reggio Calabria, Naples, Rome, Bari, Genova
		RandomDestination = false,
		CivID = ITALY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_ITALY"},
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsLibyaAlly, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoItalyTransport, -- Must refer to a function, remove this line to use the default function
	},
	[CARAIB_TO_FRANCE] = {
		Name = "Caraib to France",
		SpawnList = { {X=0, Y=0}, {X=1, Y=0}, {X=2, Y=0}, {X=3, Y=0}, {X=4, Y=0}, {X=5, Y=0}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=42}, {X=66, Y=45}, {X=74, Y=50}, {X=74, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 20, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetCaraibOilTransport, -- Must refer to a function, remove this line to use the default function
	},
	[CARAIB_TO_UK] = {
		Name = "Caraib to UK",
		SpawnList = { {X=0, Y=0}, {X=1, Y=0}, {X=2, Y=0}, {X=3, Y=0}, {X=4, Y=0}, {X=5, Y=0}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_UK"},
		MaxFleet = 1,
		Frequency = 20, -- probability (in percent) of convoy spawning at each turn
		Transport = GetCaraibOilTransport,
	},
	[US_TO_UK_USAF1] = {
		Name = "US to UK - USAF 1",
		SpawnList = { {X=5, Y=40}, {X=5, Y=38}, {X=5, Y=36}, {X=5, Y=34}, {X=5, Y=32}, {X=5, Y=30}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_1"},
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUSAFtoUKTransport1,
	},
	[US_TO_UK_USAF_RES] = {
		Name = "US to UK - USAF Oil",
		SpawnList = { {X=5, Y=40}, {X=5, Y=38}, {X=5, Y=36}, {X=5, Y=34}, {X=5, Y=32}, {X=5, Y=30}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_Oil"},
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUStoEuropeArmyResources,
	},
	[US_TO_FR_ARMY1] = {
		Name = "US to France -> Army",
		SpawnList = { {X=5, Y=40}, {X=5, Y=38}, {X=5, Y=36}, {X=5, Y=34}, {X=5, Y=32}, {X=5, Y=30}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=42}, {X=66, Y=45}, {X=74, Y=50}, {X=74, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_MIL"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeTroops1, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_FR_ARMY_RES] = {
		Name = "US to France -> resources for Army",
		SpawnList = { {X=5, Y=40}, {X=5, Y=38}, {X=5, Y=36}, {X=5, Y=34}, {X=5, Y=32}, {X=5, Y=30}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=66, Y=42}, {X=66, Y=45}, {X=74, Y=50}, {X=74, Y=34}, }, -- La Rochelle, St Nazaire, Dunkerque, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_RES"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeArmyResources, -- Must refer to a function, remove this line to use the default function
	},
	[US_TO_UK_ARMY1] = {
		Name = "US to UK - Army 1",
		SpawnList = { {X=5, Y=40}, {X=5, Y=38}, {X=5, Y=36}, {X=5, Y=34}, {X=5, Y=32}, {X=5, Y=30}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=67, Y=52}, {X=69, Y=57}, {X=72, Y=52}, {X=73, Y=65}, }, -- Plymouth, Liverpool, London, Aberdeen
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_MIL"},
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
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

	if g_Norway_Land_Ratio < 0.5 then
		Dprint ("   - but Norway is nearly invaded, got priority...", bDebug)
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
	Dprint ("  - UK is sending reinforcement troops to France", bDebug)
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
	
	local allyInNorway = GetTeamLandForceInArea( pUK, 83, 63, 105, 88 ) -- (83, 63) -> (105, 88) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pUK, 83, 63, 105, 88 )
	
	if (allyInNorway > enemyInNorway) or (allyInNorway > g_MaxForceInNorway) then	
		Dprint ("   - but allied have enough force in Norway, no need to reinforce them...", bDebug)
		return false
	end
	Dprint ("  - UK is sending reinforcement troops to Norway", bDebug)
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
	Dprint ("  - UK is sending reinforcement troops to Africa", bDebug)
	return true
end


function ItalyReinforcementToAfrica()

	local bDebug = false
	
	Dprint ("  - Italy is Checking to sent reinforcement troops to Africa", bDebug)
	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local pItaly = Players[iItaly]


	local allyInLibya = GetTeamLandForceInArea( pItaly, 83, 0, 103, 8 )
	local enemyInLibya = GetEnemyLandForceInArea( pItaly, 77, 0, 118, 10 )  --Gabes to Suez

	if (allyInLibya > enemyInLibya) or (allyInLibya > g_MaxForceInAfrica) then	
		Dprint ("   - but Axis have enough force in Libya, no need to reinforce them...", bDebug)
		return false
	end

	if not ItalyIsSafe() then
		Dprint ("   - but Italy is invaded, got priority...", bDebug)
		return false
	end
	Dprint ("  - Italy is sending reinforcement troops to Africa", bDebug)
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
	Dprint ("  - Italy is sending reinforcement troops to Albania", bDebug)
	return true
end

function FranceReinforcementToAfrica()

	local bDebug = false
	
	Dprint ("  - France is Checking to sent reinforcement troops to Africa", bDebug)

	if FranceHasFallen() then
		Dprint ("   - but France has fallen, nothing to send...", bDebug)
		return false
	end

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local pFrance = Players[iFrance]


	local allyInAfrica = GetTeamLandForceInArea( pFrance, 45, 0, 79, 21 )
	local enemyInAfrica = GetEnemyLandForceInArea( pFrance, 45, 0, 79, 21 )  --French N-Africa

	if (allyInAfrica > enemyInAfrica) or (allyInAfrica > g_MaxForceInAfrica) then	
		Dprint ("   - but Allies have enough force in N-Africa, no need to reinforce them...", bDebug)
		return false
	end

	if g_France_Land_Ratio < 0.8 then
		Dprint ("   - but France is invaded...", bDebug)
		return false
	end
	Dprint ("  - France is sending reinforcement troops to Africa", bDebug)
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
	
	local friendInNorway = GetTeamLandForceInArea( pGermany, 83, 63, 105, 88 ) -- (83, 63) -> (105, 88) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pGermany, 83, 63, 105, 88 )
	
	if (friendInNorway > enemyInNorway)  or (friendInNorway > g_MaxForceInNorway) then	
		Dprint ("   - but Axis have enough forces in Norway, no need to reinforce them...", bDebug)
		return false
	end
	Dprint ("  - Germany is sending reinforcement troops to Norway", bDebug)
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
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 64, 51, 74, 68 ) -- (64, 51) -> (74, 68) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK and need another operation Seelowe...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 64, 51, 74, 68 )	
	if friendInUK > enemyInUK then	
		Dprint ("   - but Axis ("..friendInUK..") have more force than Allies ("..enemyInUK..") in UK, no need to reinforce them...", bDebug)
		return false
	end
	Dprint ("  - Germany is sending reinforcement troops to UK", bDebug)
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
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 64, 51, 74, 68 ) -- (64, 51) -> (74, 68) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 64, 51, 74, 68  )	
	if friendInUK < (2*enemyInUK) then	
		Dprint ("   - but Axis ("..friendInUK..") have not total domination over Allies ("..enemyInUK..") in UK...", bDebug)
		return false
	end
	Dprint ("  - Germany is removing troops from UK", bDebug)
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
TROOPS_US_UK_DDAY_1 = 26
TROOPS_US_UK_DDAY_2 = 27

-- troops route table
g_TroopsRoutes = { 
	[ENGLAND] = {	
			[TROOPS_UK_FRANCE] = {
				Name = "UK to France",
				CentralPlot = {X=70, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=72, Y=52}, {X=71, Y=51}, {X=72, Y=51},}, -- near London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=73, Y=49}, {X=75, Y=50}, {X=71, Y=48}, {X=72, Y=48},}, -- near Dunkerque
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = UKReinforcementToFrance, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_NORWAY] = {
				Name = "UK to Norway",
				CentralPlot = {X=71, Y=58},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=71, Y=62}, {X=72, Y=60}, {X=71, Y=61}, }, -- near Newcastle
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=78, Y=80}, {X=79, Y=65}, {X=91, Y=83}, }, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=83, Y=69}, {X=83, Y=67}, {X=47, Y=79}, {X=95, Y=83}, {X=96, Y=84}, {X=93, Y=81}, }, -- Between Narvik and Trondheim
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_AFRICA] = {
				Name = "UK to Africa",
				CentralPlot = {X=70, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=66, Y=52}, {X=67, Y=52}, {X=68, Y=52},}, -- near Plymouth
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=56, Y=47}, {X=45, Y=39}, {X=44, Y=27}, {X=52, Y=23}, {X=60, Y=22}, {X=72, Y=22},  {X=81, Y=22}, {X=88, Y=11}, {X=100, Y=9}, {X=115, Y=6},}, 
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=114, Y=4}, {X=115, Y=4}, {X=116, Y=4}, {X=117, Y=4}, {X=118, Y=4}, {X=119, Y=4}, {X=120, Y=4}, {X=121, Y=4}, }, -- Between Alexandria and Haifa
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_DDAY] = {
				Name = "UK goes D-Day !",
				CentralPlot = {X=70, Y=55},
				MaxDistanceFromCentral = 9,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=66, Y=52}, {X=67, Y=52}, {X=68, Y=52}, {X=71, Y=51}, {X=72, Y=51}, {X=72, Y=52},}, -- near Plymouth, London
				RandomEmbark = true, -- true : random choice in spawn list
				WaypointList = nil, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=65, Y=48}, {X=65, Y=47}, {X=66, Y=47}, {X=67, Y=47}, {X=68, Y=48}, {X=68, Y=47}, }, -- Between Brest and Caen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 16,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_LIBERATE_ALGIERSBRITISH] = {
				Name = "England to Africa",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=67, Y=20}, {X=68, Y=20}, {X=69, Y=20},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_SICILYBRITISH] = {
				Name = "England to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=88, Y=18}, {X=87, Y=16}, {X=86, Y=17},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ITALYBRITISH] = {
				Name = "England to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=90, Y=22}, {X=90, Y=23}, {X=91, Y=23}, {X=92, Y=23},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_OVERLORD_2] = {
				Name = "Overlord II",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=65, Y=48}, {X=65, Y=47}, {X=66, Y=47}, {X=67, Y=47}, {X=68, Y=48}, {X=68, Y=47}, },
				RandomLanding = true, -- false : sequential try in landing list
			},

	},

	[ITALY] = {	
			[TROOPS_ITALY_AFRICA] = {
				Name = "Italy to Africa",
				CentralPlot = {X=84, Y=28},
				MaxDistanceFromCentral = 9,
				ReserveUnits = 6, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=83, Y=29}, {X=84, Y=28}, {X=84, Y=27},  {X=86, Y=26}, {X=86, Y=25},  {X=87, Y=25},}, -- near Rome, Naples
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=90, Y=16}, {X=90, Y=9},  }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=85, Y=7}, {X=86, Y=6}, {X=88, Y=3}, {X=90, Y=3}, {X=96, Y=4}, {X=97, Y=6}, }, -- near Triploli, Sirte, Benghazi
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 4,
				MaxUnits = 8, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = ItalyReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_ITALY_ALBANIA] = {
				Name = "Italy to Albania",
				CentralPlot = {X=84, Y=28},
				MaxDistanceFromCentral = 9,
				ReserveUnits = 6, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=90, Y=25}, {X=91, Y=24}, {X=92, Y=24}, {X=86, Y=29}, }, -- near Bari, Pescara
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=93, Y=25}, {X=94, Y=21} }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=95, Y=26}, {X=95, Y=25}, {X=95, Y=24}, {X=95, Y=23}, {X=96, Y=22}, {X=96, Y=21}, }, -- near Tirana
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
				CentralPlot = {X=74, Y=35},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 8, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=73, Y=34}, {X=74, Y=34}, {X=74, Y=33}, }, -- near Marseille
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=67, Y=20}, {X=68, Y=20}, {X=69, Y=20}, {X=69, Y=19}, {X=70, Y=19}, {X=71, Y=19}, {X=72, Y=19}, {X=73, Y=19}, {X=74, Y=19}, {X=75, Y=18}, {X=76, Y=18}, {X=77, Y=18}, {X=78, Y=18}, }, -- Between Alger and Tunis
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
				LandingList = { {X=70, Y=47}, {X=71, Y=48}, {X=72, Y=48}, {X=73, Y=48}, {X=73, Y=49}, },
				RandomLanding = true, -- false : sequential try in landing list
			},

	},

	[GERMANY] = {	
			[TROOPS_GERMANY_NORWAY] = {
				Name = "Germany to Norway",
				CentralPlot = {X=85, Y=53},
				MaxDistanceFromCentral = 3,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=83, Y=53}, {X=84, Y=53}, {X=85, Y=54}, {X=85, Y=55},}, -- near Kiel
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=84, Y=61}, {X=87, Y=62}, },
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=86, Y=64}, {X=87, Y=64}, {X=87, Y=65}, {X=88, Y=66}, {X=85, Y=63}, }, -- Between Bergen and Oslo
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_GERMANY_SEELOWE_KIEL] = {
				Name = "Germany to UK (Seelowe from Kiel)",
				WaypointList = { {X=80, Y=57}, {X=75, Y=57}, },
				RandomWaypoint = false, 
				LandingList = { {X=73, Y=54}, {X=72, Y=55}, {X=73, Y=56}, {X=72, Y=57}, {X=72, Y=58}, {X=72, Y=59},}, -- Between Norwich and Newcastle
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_SEELOWE_ST_NAZAIRE] = {
				Name = "Germany to UK (Seelowe from St Nazaire)",
				WaypointList = { {X=61, Y=46}, {X=62, Y=53}, },
				RandomWaypoint = false, 
				LandingList = { {X=66, Y=52}, {X=66, Y=53}, {X=67, Y=54}, {X=68, Y=56}, {X=68, Y=57},}, -- Between Plymouth and Liverpool
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_UK] = {
				Name = "Germany to UK",
				CentralPlot = {X=74, Y=46},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=73, Y=49}, {X=74, Y=50}, {X=75, Y=50}, }, -- near Dunkerque
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=68, Y=52}, {X=69, Y=52}, {X=70, Y=52}, {X=71, Y=51}, {X=72, Y=51}, }, -- East of Plymouth
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToUK, -- Must refer to a function, remove this line to use the default condition (true)
			},		
			[TROOPS_GERMANY_BACK_UK] = {
				Name = "Germany back to France from UK",
				CentralPlot = {X=70, Y=55},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=72, Y=52}, {X=72, Y=51}, {X=71, Y=51},}, -- near London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=75, Y=50}, {X=73, Y=49}, {X=73, Y=48}, }, -- near Dunkerque
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 2, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyDisengagefromUK, -- Must refer to a function, remove this line to use the default condition (true)
			},
		},

	[AMERICA] = {
			[TROOPS_LIBERATE_CASABLANCA] = {
				Name = "America to Africa 1",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=47, Y=17}, {X=48, Y=17}, {X=50, Y=17},{X=51, Y=18}, {X=47, Y=16}, {X=52, Y=19},  },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ORAN] = {
				Name = "America to Africa 2",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=58, Y=19}, {X=59, Y=19}, {X=61, Y=20}, {X=62, Y=20},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ALGIERS] = {
				Name = "America to Africa 3",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=64, Y=20}, {X=65, Y=20}, {X=65, Y=21}, },
				RandomLanding = true, -- false : sequential try in landing list
			},	
			[TROOPS_LIBERATE_SICILY] = {
				Name = "America to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=84, Y=19}, {X=85, Y=18}, {X=86, Y=18},},
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_LIBERATE_ITALY] = {
				Name = "America to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=87, Y=25}, {X=88, Y=24}, {X=89, Y=24}, {X=89, Y=23},},
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_OVERLORD_1] = {
				Name = "Overlord I",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=64, Y=47}, {X=65, Y=46}, {X=66, Y=46}, {X=66, Y=44}, {X=66, Y=43},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_OVERLORD_3] = {
				Name = "Overlord III",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=70, Y=47}, {X=71, Y=48}, {X=72, Y=48}, {X=73, Y=48}, {X=73, Y=49}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_US_UK_DDAY_1] = {
				Name = "USA goes D-Day USA to UK",
				CentralPlot = {X=2, Y=27},
				MaxDistanceFromCentral = 25,
				ReserveUnits = 10, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=7, Y=3}, {X=7, Y=4}, {X=4, Y=11}, {X=4, Y=12}, {X=3, Y=13}, {X=3, Y=14},{X=2, Y=16}, {X=1, Y=20}, {X=1, Y=21}, {X=2, Y=22}, {X=2, Y=26}, {X=2, Y=27},{X=2, Y=28}, {X=2, Y=36}, {X=2, Y=37}, {X=3, Y=40}, {X=4, Y=40}, {X=6, Y=48},}, -- West coast
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList =  { {X=23, Y=50}, {X=33, Y=50}, {X=44, Y=50}, {X=54, Y=50}, {X=58, Y=53}, {X=63, Y=55},}, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=66, Y=53}, {X=67, Y=57}, {X=66, Y=55}, {X=67, Y=55}, {X=68, Y=56}, {X=67, Y=57},  {X=68, Y=57}, {X=69, Y=57}, {X=70, Y=58}, {X=70, Y=59}, {X=70, Y=60}, {X=69, Y=61},}, -- Between Plymouth and Edinburgh
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 15,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_US_UK_DDAY_2] = {
				Name = "UK goes D-Day UK to France",
				CentralPlot = {X=70, Y=55},
				MaxDistanceFromCentral = 9,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=66, Y=52}, {X=67, Y=52}, {X=68, Y=52}, {X=71, Y=51}, {X=72, Y=51}, {X=72, Y=52},}, -- near Plymouth, London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=65, Y=48}, {X=65, Y=47}, {X=66, Y=47}, {X=67, Y=47}, {X=68, Y=48}, {X=68, Y=47}, }, -- Between Brest and Caen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 16,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},


	},

	[USSR] = {	
			[TROOPS_RUSSIA_WEST_1] = {
				Name = "East to West1",
				CentralPlot = {X=125, Y=60}, --Gorki
				MaxDistanceFromCentral = 10,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=125, Y=60},}, -- Gorki
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=109, Y=64}, {X=111, Y=55}, {X=117, Y=58}, {X=106, Y=52}, {X=110, Y=85}, }, -- Cities in North USSR
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 10, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = RussiaReinforcementToFront, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_RUSSIA_WEST_2] = {
				Name = "East to West2",
				CentralPlot = {X=118, Y=43}, --Kharkov
				MaxDistanceFromCentral = 10,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=118, Y=43},}, -- Kharkov
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=111, Y=44}, {X=112, Y=37}, {X=110, Y=34}, {X=105, Y=45}, {X=105, Y=48}, }, -- Cities in South USSR
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
function PlayerAmericaEuro1936ProjectRestriction  (iPlayer, iProjectType)
	local bDebug = false
	local civID = GetCivIDFromPlayerID(iPlayer, false)	
		
	if civID == GERMANY and iProjectType == OPERATION_SEELOWE then
		if AreAtWar( iPlayer, GetPlayerIDFromCivID(USSR, false)) then
			Dprint("      - Operation Seelowe not available, Germany is at war with USSR...", bDebug)		
			return false 
		end
		local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Seelowe not available, Berlin is occupied...", bDebug)	
			return false 
		end
	end	
	
	if civID == GERMANY and iProjectType == OPERATION_WESERUBUNG then
		local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
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
		local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Berlin is occupied...", bDebug)	
			return false -- Paratroopers launch from Berlin...
		end
		local Essen = GetPlot(81, 50):GetPlotCity()	-- Essen
		if Essen:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Essen is occupied...", bDebug)	
			return false -- 1st army launch from Essen...
		end
		local Cologne = GetPlot(81, 49):GetPlotCity()	-- Cologne
		if Cologne:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Cologne is occupied...", bDebug)	
			return false -- 2nd army launch from Cologne...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_SONNENBLUME then
		local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Sonnenblume not available, Berlin is occupied...", bDebug)	
			return false 			-- Paratroopers launch from Berlin...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_TWENTYFIVE then
		local Vienna = GetPlot(92, 40):GetPlotCity()	-- Vienna
		if Vienna:IsOccupied() then
			Dprint("      - Operation Twenty Five not available, Vienna is occupied...", bDebug)	
			return false 			-- Operation starts from Vienna...
		end
	end
	return true
end
--GameEvents.PlayerCanCreate.Add(PlayerAmericaEuro1936ProjectRestriction)

function IsGermanyReadyForWeserubung()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(NORWAY, true)) then
		Dprint("      - Operation Weserübung not ready, Germany is not at war with Norway...", bDebug)
		return false
	end
	local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Weserübung not ready, Berlin is occupied...", bDebug)	
		return false -- Paratroopers launch from Berlin...
	end
	return true
end

function IsGermanyReadyForSonnenblume()
	local bDebug = false
	local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Berlin is occupied...", bDebug)				
		return false -- Paratroopers launch from Berlin...
	end
	local Rome = GetPlot(84, 28):GetPlotCity()	-- Rome
	if Rome:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Rome is occupied...", bDebug)		
		return false 
	end
	local city = GetPlot(101, 5):GetPlotCity()	-- Tobruk
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
	local Vienna = GetPlot(92, 40):GetPlotCity()	-- Vienna
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

	local enemyForces = GetEnemyLandForceInArea( pUSSR, 104, 32, 127, 88 )
	local allyForces = GetSameSideLandForceInArea( pUSSR, 104, 32, 127, 88 )

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
	local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Berlin is occupied...", bDebug)		
		return false -- Paratroopers launch from Berlin...
	end
	local Essen = GetPlot(81, 50):GetPlotCity()	-- Essen
	if Essen:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Essen is occupied...", bDebug)			
		return false -- 1st army launch from Essen...
	end
	local Cologne = GetPlot(81, 49):GetPlotCity()	-- Cologne
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
	local Berlin = GetPlot(89, 50):GetPlotCity()	-- Berlin
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
				{	Name = "Para Group 1", X = 89, Y = 50, Domain = "City", CivID = GERMANY, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, GE_PARATROOPER,	},
					UnitsXP = {		45,				45,	              45,}, 
					InitialObjective = "96,85", -- Narvik
					LaunchType = "ParaDrop",
					LaunchX = 97, -- Destination plot
					LaunchY = 85, -- (97,85) = Near Narvik
					LaunchImprecision = 3, -- landing area
				},
				{	Name = "Para Group 2", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		45,				45,				}, 
					InitialObjective = "89,66", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 88, -- Destination plot
					LaunchY = 66, -- (88,66) = West of Oslo
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Para Group 3", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		45,				45,				}, 
					InitialObjective = "89,66", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 89, -- Destination plot
					LaunchY = 68, -- (89,68) = North of Oslo
					LaunchImprecision = 2, -- landing area
				},
			},			
			Condition = IsGermanyReadyForWeserubung, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_SEELOWE] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SEELOWE",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, GE_PARATROOPER,	},
					UnitsXP = {		45,				45,				45,   }, 
					InitialObjective =  "70,54", -- Birmingham 
					LaunchType = "ParaDrop",
					LaunchX = 70, -- Destination plot
					LaunchY = 55, -- (70,55) = Near Birmingham
					LaunchImprecision = 2, -- landing area
				}, 
				{	Name = "Amphibious Army 1", X = 83, Y = 55, Domain = "Land", CivID = GERMANY, AI = false,-- spawn west of Kiel
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_III,	GE_PANZER_II},
					UnitsXP = {		45,				45,				 45,             45,             45,    }, 
					InitialObjective = "72,60", -- Newcastle  
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_KIEL, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Amphibious Army 2", X = 64, Y = 44, Domain = "Land", CivID = GERMANY, AI = false,-- spawn west of St Nazaire / La rochelle
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_IV,	GE_PANZER_II},
					UnitsXP = {		45,				45,				 45,          45,            45,     }, 
					InitialObjective = "67,52", -- Plymouth  
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_ST_NAZAIRE, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
			},			
			Condition = IsGermanyReadyForSeelowe, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_FALLGELB] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_FALLGELB",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER	},
					UnitsXP = {		45,				45,}, 
					InitialObjective = "79,52", -- Amsterdam
					LaunchType = "ParaDrop",
					LaunchX = 78, -- Destination plot
					LaunchY = 51, -- (78,51) = Near Amsterdam
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Para Group 2", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		45,				45,				}, 
					InitialObjective = "77,49", -- Brussel
					LaunchType = "ParaDrop",
					LaunchX = 78, -- Destination plot
					LaunchY = 48, -- (78,48) = Near Brussel
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Army 1", X = 81, Y = 50, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Essen
					Group = {		GE_INFANTRY,	GE_INFANTRY,	GE_INFANTRY,	GE_PANZER_IV,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		45,				45,				45,				45,				45,				45,			45,	}, 
					InitialObjective = "79,52", -- Amsterdam 
				},
				{	Name = "Support 1", X = 81, Y = 50, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Essen
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		45,				45,				45,				45, }, 
					InitialObjective = "79,52", -- Amsterdam 
				},
				{	Name = "Army 2", X = 81, Y = 49, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Cologne
					Group = {		GE_INFANTRY,	GE_INFANTRY,	GE_INFANTRY,	GE_PANZER_III,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		45,				45,				45,				45,				45,				45,			45,	}, 
					InitialObjective = "77,49", -- Brussel 
				},
				{	Name = "Support 2", X = 81, Y = 49, Domain = "City", CivID = GERMANY, AI = false, -- spawn at Cologne
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		45,				45,				45,				45, }, 
					InitialObjective = "77,49", -- Brussel  
				},
			},
			Condition = IsGermanyReadyForFallGelb, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_SONNENBLUME] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SONNENBLUME",
			OrderOfBattle = {
				{	Name = "Afrika Korps I", X = 89, Y = 50, Domain = "City", CivID = GERMANY,
					Group = {		GE_INFANTRY, GE_INFANTRY,	GE_PANZER_III,	GE_INFANTRY,	GE_PANZER_III,	},
					UnitsXP = {		45,	         45,			45,		         45,	    	 9,	}, 
					InitialObjective = "101,5", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 99, -- Destination plot
					LaunchY = 5, -- (99,5) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Afrika Korps II", X = 89, Y = 50, Domain = "City", CivID = GERMANY, AI = false,
					Group = {		GE_PANZER_IV,	ARTILLERY,	AT_GUN,	},
					UnitsXP = {		45,	             45,		     45,		}, 
					InitialObjective = "101,5", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 99, -- Destination plot
					LaunchY = 5, -- (99,5) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
			},		
			Condition = IsGermanyReadyForSonnenblume, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_TWENTYFIVE] =  { -- projectID as index !
			Name = "Operation 25",
			OrderOfBattle = {
				{	Name = "Belgrade Assault Force", X = 92, Y = 40, Domain = "City", CivID = GERMANY,  AI = false,
					Group = {		GE_INFANTRY,	GE_PANZER_III, GE_PANZER_III, GE_PANZER_IV,	},
					UnitsXP = {		45,				45,				45,				45, }, 
					InitialObjective = "97,32", -- Belgrade
				},
				{	Name = "Zagreb Assault Force", X = 92, Y = 40, Domain = "City", CivID = GERMANY, AI = false,
					Group = {		GE_INFANTRY,	GE_INFANTRY, GE_PANZER_II,	},
					UnitsXP = {		45,				45,				45,	 }, 
					InitialObjective = "91,35", -- Zagreb
				},
			},			
			Condition = IsGermanyReadyForTwentyFive, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_MARITA] =  { -- projectID as index !
			Name = "Operation Marita",
			OrderOfBattle = {
				{	Name = "Thessaloniki Assault Force", X = 89, Y = 50, Domain = "Land", CivID = GERMANY,  AI = false,
					Group = {		GE_INFANTRY,	GE_SS_INFANTRY, GE_PANZER_III,	},
					UnitsXP = {		45,				45,				45,  }, 
					InitialObjective = "101,22", -- Thessaloniki
					LaunchType = "ParaDrop",
					LaunchX = 101, -- Destination plot
					LaunchY = 23,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Athens Assault Force", X = 89, Y = 50, Domain = "Land", CivID = GERMANY, AI = false,
					Group = {		GE_INFANTRY,	GE_SS_INFANTRY, GE_PANZER_III, GE_PANZER_IV,	},
					UnitsXP = {		45,				45,				45,				45, }, 
					InitialObjective = "101,17", -- Athens
					LaunchType = "ParaDrop",
					LaunchX = 100, -- Destination plot
					LaunchY = 15,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Crete Assault Force", X = 89, Y = 50, Domain = "Land", CivID = GERMANY, AI = false,
					Group = {		GE_PARATROOPER,	},
					UnitsXP = {		45,				}, 
					InitialObjective = "103,11", -- Iraklion
					LaunchType = "ParaDrop",
					LaunchX = 101, -- Destination plot
					LaunchY = 11,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = IsGermanyAtWarWithGreece, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	[USSR] = {
	------------------------------------------------------------------------------------
		[OPERATION_MOTHERLANDCALL] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_MOTHERLANDCALL",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 119, Y = 67, Domain = "Land", CivID = USSR, -- spawn near Gorki
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		45,					45,	     45,     45,     45,          45,          45,}, 
					InitialObjective = "89,50", -- Berlin
				},
				{	Name = "Support Group 1", X = 119, Y = 67, Domain = "Land", CivID = USSR, -- spawn near Gorki
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "89,50", -- Berlin
				},
				{	Name = "Army Group 2", X = 126, Y = 53, Domain = "Land", CivID = USSR, AI = false, -- spawn near Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		45,					45,       45,    45,     45,           45,          45,	}, 
					InitialObjective = "89,50", -- Berlin
				},
				{	Name = "Support Group 2", X = 126, Y = 53, Domain = "Land", CivID = USSR, AI = false, -- spawn near Stalingrad
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "89,50", -- Berlin
				},
			},			
			Condition = IsUSSRLosingWar, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_URANUS] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_URANUS",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 126, Y = 50, Domain = "Land", CivID = USSR, -- spawn north of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_KV1, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		45,					45,       45,    45,     45,           45,          45,	}, 
					InitialObjective = "127,47", -- Stalingrad
				},
				{	Name = "Support Group 1", X = 126, Y = 50, Domain = "Land", CivID = USSR, AI = false,-- spawn north of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "127,47", -- Stalingrad
				},
				{	Name = "Army Group 2", X = 126, Y = 44, Domain = "Land", CivID = USSR,  -- spawn south of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_ISU122, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		45,					45,       45,    45,     45,           45,          45,	}, 
					InitialObjective = "127,47", -- Stalingrad
				},
				{	Name = "Support Group 2", X = 126, Y = 44, Domain = "Land", CivID = USSR, AI = false, -- spawn south of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "127,47", -- Stalingrad
				},
			},			
			Condition = StalingradOccupied, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_MOSKWA] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_MOSKWA",
			OrderOfBattle = {			
			},			
			--Condition = StalingradOccupied, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},

	[ENGLAND] = {
	------------------------------------------------------------------------------------
		
		[OPERATION_HUSKY] =  { -- projectID as index !
			Name = "Operation Husky",
			OrderOfBattle = {
				{	Name = "Western Task Force (USA)", X = 82, Y = 20, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_MARINES, ARTILLERY},
					UnitsXP = {		45,				45,			45}, 
					InitialObjective = "85,19", -- Palermo
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Paradrop Force (USA)", X = 0, Y = 32, Domain = "City", CivID = AMERICA,
					Group = {		US_PARATROOPER, },
					UnitsXP = {		45,	 }, 
					InitialObjective = "85,19", -- Palermo
					LaunchType = "ParaDrop",
					LaunchX = 86, -- Destination plot
					LaunchY = 18,
					LaunchImprecision = 1, -- landing area
				},			
				{	Name = "Eastern Task Force (British)", X = 88, Y = 14, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_INFANTRY, ARTILLERY},
					UnitsXP = {		45,	             45,          45}, 
					InitialObjective = "87,17", -- Catania
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILYBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Paradrop Force (UK)", X = 72, Y = 52, Domain = "City", CivID = ENGLAND,
					Group = {		UK_PARATROOPER, },
					UnitsXP = {		45,	 }, 
					InitialObjective = "87,17", -- Catania
					LaunchType = "ParaDrop",
					LaunchX = 87, -- Destination plot
					LaunchY = 18,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = NorthAfricaLiberated,-- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_AVALANCHE] =  { -- projectID as index !
			Name = "Operation Avalanche",
			OrderOfBattle = {
				{	Name = "Northern Task Force (USA)", X = 86, Y = 22, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_MARINES, US_M7, US_M12},
					UnitsXP = {		45,				45,			45,       45}, 
					InitialObjective = "86,25", -- Napoli
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ITALY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Southern Task Force (British)", X = 92, Y = 18, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_MECH_INFANTRY, UK_MOBILE_BISHOP},
					UnitsXP = {		45,	             45,          45}, 
					InitialObjective = "91,24", -- Bari
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ITALYBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},

			},			
			Condition = IsSicilyOccupied,-- Must refer to a function, remove this line to use the default condition (always true)
		},	
	},		
	
	
	[AMERICA] = {
	------------------------------------------------------------------------------------
		[OPERATION_TORCH] =  { -- projectID as index !
			Name = "Operation Torch",
			OrderOfBattle = {
				{	Name = "Western Task Force", X = 48, Y = 20, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_INFANTRY, US_INFANTRY,	US_M24CHAFFEE},
					UnitsXP = {		45,				45,			45,             45}, 
					InitialObjective = "49,17", -- Casablanca 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group", X = 47, Y = 22, Domain = "Land", CivID = AMERICA, AI = false,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective = "49,17", -- Casablanca 
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force", X = 58, Y = 21, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_MARINES, US_SHERMAN,	},
					UnitsXP = {		45,				45,        45}, 
					InitialObjective =  "60,20", -- Oran 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group", X = 57, Y = 22, Domain = "Land", CivID = AMERICA, AI = false,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective =  "60,20", -- Oran 
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Eastern Task Force (American)", X = 67, Y = 23, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_MARINES, US_SHERMAN },
					UnitsXP = {		45,				45,        45}, 
					InitialObjective = "66,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERS, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force (British)", X = 70, Y = 22, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, },
					UnitsXP = {		45,	}, 
					InitialObjective = "66,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group", X = 71, Y = 22, Domain = "Land", CivID = ENGLAND, AI = false,
					Group = {		ARTILLERY,	},
					InitialObjective = "66,21", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},		
				{	Name = "Paradrop Force", X = 3, Y = 40, Domain = "City", CivID = AMERICA,
					Group = {US_PARATROOPER,},
					UnitsXP = {		45,	 }, 
					InitialObjective = "60,20", -- Oran
					LaunchType = "ParaDrop",
					LaunchX = 60, -- Destination plot
					LaunchY = 19,
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "French Resistance", X = 64, Y = 18, Domain = "City", CivID = FRANCE,
					Group = {		FR_LEGION, },
					UnitsXP = {		45,	 }, 
					InitialObjective = "66,21", -- Algiers
					LaunchType = "ParaDrop",
					LaunchX = 66, -- Destination plot
					LaunchY = 18,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = NorthAfricaInvaded, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		
		[OPERATION_OVERLORD] =  { -- projectID as index !
			Name = "Operation Overlord",
			OrderOfBattle = {
				{	Name = "Western Task Force I", X = 62, Y = 45, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_INFANTRY, US_INFANTRY,	US_INFANTRY, US_MARINES, US_MARINES, US_MARINES, },
					UnitsXP = {		45,				45,			45,             45,              45,        45,        45   }, 
					InitialObjective = "66,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group I", X = 61, Y = 48, Domain = "Land", CivID = AMERICA, AI = false, 
					Group = {		ARTILLERY, ARTILLERY, ARTILLERY, AT_GUN, AT_GUN, AT_GUN, US_M10	},
					UnitsXP = {		45,			45,			45,          45,    45,        45,      45   }, 
					InitialObjective = "66,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Western Task Force II", X = 59, Y = 45, Domain = "Land", CivID = AMERICA,
					Group = {		US_SHERMAN_IIA, US_SHERMAN_IIA, US_SHERMAN_III,	US_SHERMAN_III, US_M24CHAFFEE, US_M24CHAFFEE, US_MECH_INFANTRY, },
					UnitsXP = {		      45,				45,			45,             45,              45,             45,               45   }, 
					InitialObjective = "66,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group II", X = 58, Y = 48, Domain = "Land", CivID = AMERICA, AI = false, 
					Group = {		US_M18, US_M18, US_M12, US_M12, US_M16A1, US_M16A1, US_SEXTON	},
					UnitsXP = {		45,		45,		45,      45,      45,        45,        45   }, 
					InitialObjective = "66,45", -- Saint Nazaire 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Western Paradrop Force", X = 3, Y = 40, Domain = "City", CivID = AMERICA,
					Group = {US_PARATROOPER, US_PARATROOPER, US_PARATROOPER, US_SPECIAL_FORCES},
					UnitsXP = {		45,				45,			45,             29,            }, 
					InitialObjective = "66,45", -- Saint Nazaire 
					LaunchType = "ParaDrop",
					LaunchX = 68, -- Destination plot
					LaunchY = 44,
					LaunchImprecision = 3, -- landing area
				},
				{	Name = "Central Task Force I", X = 66, Y = 50, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_INFANTRY, UK_INFANTRY,	UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, },
					UnitsXP = {		45,				45,			45,             45,              45,        45,        45			}, 
					InitialObjective = "69,47", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group I", X = 63, Y = 50, Domain = "Land", CivID = ENGLAND, AI = false,
					Group = {		ARTILLERY, ARTILLERY, ARTILLERY, AT_GUN, AT_GUN, AT_GUN, UK_ACHILLES	},
					UnitsXP = {		45,			45,			45,          45,    45,        45,      45           }, 
					InitialObjective = "69,47", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force II", X = 63, Y = 53, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_M4_FIREFLY, UK_M4_FIREFLY, UK_CHURCHILL,	UK_CHURCHILL, UK_A24, UK_A24, UK_MECH_INFANTRY, },
					UnitsXP = {		      45,				45,			45,             45,              45,             45,               45   }, 
					InitialObjective = "69,47", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group II", X = 60, Y = 53, Domain = "Land", CivID = ENGLAND, AI = false,
					Group = {		UK_MOBILE_BISHOP, UK_MOBILE_BISHOP, UK_MOBILE_AA_VICKERS, UK_MOBILE_AA_VICKERS, UK_MOBILE_BISHOP, UK_MOBILE_BISHOP, UK_MOBILE_AA_GUN	},
					UnitsXP = {		45,		             45,		        45,                        45,                 45,              45,                    45   }, 
					InitialObjective = "69,47", -- Caen
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Central Paradrop Force", X = 72, Y = 52, Domain = "City", CivID = ENGLAND,
					Group = {UK_PARATROOPER, UK_PARATROOPER, UK_SPECIAL_FORCES, UK_SPECIAL_FORCES},
					UnitsXP = {		45,				45,			29,             29,              }, 
					InitialObjective = "69,47", -- Caen 
					LaunchType = "ParaDrop",
					LaunchX = 70, -- Destination plot
					LaunchY = 46,
					LaunchImprecision = 2, -- landing area
				},				
				{	Name = "Eastern Task Force I", X = 72, Y = 50, Domain = "Land", CivID = FRANCE,
					Group = {		FR_INFANTRY, FR_INFANTRY, FR_INFANTRY, },
					UnitsXP = {		45,				45,			45,       }, 
					InitialObjective = "74,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group I", X = 70, Y = 50, Domain = "Land", CivID = FRANCE, AI = false,
					Group = {		ARTILLERY, AT_GUN, FR_SAU40	},
					UnitsXP = {		45,			45,			45   }, 
					InitialObjective = "74,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force II", X = 74, Y = 52, Domain = "Land", CivID = AMERICA,
					Group = {		CA_INFANTRY, CA_INFANTRY, CA_INFANTRY,	 },
					UnitsXP = {		    45,	   45,			45,		 }, 
					InitialObjective = "74,50", -- Dunkerque
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "French Resistance", X = 77, Y = 47, Domain = "Land", CivID = FRANCE,  -- spawn near Reims
					Group = {		FR_PARTISAN,	FR_PARTISANY,	FR_PARTISAN,},
					InitialObjective = "76,46", -- Reims
				},

			},			
			Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},		
		
}


function InitializeAmericaEuro1936Projects()

	local bDebug = false

	Dprint("-------------------------------------", bDebug)
	Dprint("Initializing specific projects for Europe 1936-1945 scenario...",bDebug)

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
function DoInitAmericaEuro1936UI()
	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetToolTipCallback( ToolTipAmericaEuro1936Score )
	UpdateAmericaEuro1936ScoreString()
end

local tipControlTable = {};
TTManager:GetTypeControlTable( "TooltipTypeTopPanel", tipControlTable );

-- Score Tooltip for AmericaEuro1936
function ToolTipAmericaEuro1936Score( control )

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

function UpdateAmericaEuro1936ScoreString()

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
	SetCitadelAt(97, 49)
	
	-- Place the Shlisselburg Fortress in USSR
	SetCitadelAt(108, 65)

	-- Place the Mannerheim Line in Finland
	SetBunkerAt(106, 66)
	SetBunkerAt(107, 67)
	
	-- Place the fortifications for the Maginot Line
	if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
		SetCitadelAt(81, 45)
		SetBunkerAt(80, 42)
		SetBunkerAt(80, 43)
		SetFortAt(80, 45)
		SetFortAt(80, 46)
	end

	-- Place the fortifications for the Siegfried Line
	if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
		SetBunkerAt(82, 42)
		SetBunkerAt(83, 44)
		SetBunkerAt(82, 46)
		SetBunkerAt(80, 47)
		SetBunkerAt(80, 49)
		SetBunkerAt(80, 51)
		SetBunkerAt(81, 53)
	end
end

-- Partisan table
g_Partisan = { 
		[1] = {
		Group = {FR_PARTISAN},
		SpawnList = { {X=72, Y=48}, {X=73, Y=48}, {X=75, Y=48}, {X=68, Y=46}, {X=71, Y=46}, {X=67, Y=45}, {X=68, Y=45}, {X=71, Y=45}, {X=72, Y=45},  {X=77, Y=45}, {X=67, Y=44}, {X=73, Y=44},  {X=73, Y=43}, {X=75, Y=43}, {X=77, Y=43},  {X=66, Y=39}, {X=67, Y=40}, {X=72, Y=42}, {X=73, Y=42}, {X=79, Y=45}, },
		RandomSpawn = true, -- true : random choice in spawn list
		CivID = FRANCE,
		Frequency = 50, -- probability (in percent) of partisan spawning at each turn
		Condition = NorthFranceInvaded, -- Must refer to a function, remove this line to use the default condition (true)
		},
	}





