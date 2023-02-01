-- ScriptEarth1936
-- Author: Gedemon (Edited by CommanderBly)
-- DateCreated: 8/18/2012
--------------------------------------------------------------

print("Loading Earth 1936 Scripts...")
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
				local turn = Game.GetGameTurn()
				local turnDate = 0
				if g_Calendar[turn] then 
					turnDate = g_Calendar[turn].Number 
				else 
					turnDate = 19470105 
				end
				if turnDate >= 19390830 then
					return true
				end
			end
		end
		if ( civ1ID ==  USSR and civ2ID == GERMANY) then
			if not team:IsAtWar( player2:GetTeam() ) then
				local turn = Game.GetGameTurn()
				local turnDate = 0
				if g_Calendar[turn] then 
					turnDate = g_Calendar[turn].Number 
				else 
					turnDate = 19470105 
				end
				if turnDate >= 19390830 then
					return true
				end
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
g_France_Land_Ratio = 1
g_USSR_Land_Ratio = 1
g_USA_Land_Ratio = 1

-- limit troops route on specific fronts
g_MaxForceInNorway = 100000
g_MaxForceInAfrica = 200000

function SetAIStrategicValues()

	local bDebug = false
	
	Dprint ("-------------------------------------", bDebug)
	Dprint ("Cache scenario AI Strategic values...", bDebug)
	local t_start = os.clock()


	local initialNorway, initialEgypt  = 0, 0
	local actualNorway, actualEgypt = 0, 0

	local iNorway = GetPlayerIDFromCivID (NORWAY, true, true)
	
	local initialFrance = 0
	local actualFrance = 0
	local initialUSSR = 0
	local actualUSSR = 0
	local initialUSA = 0
	local actualUSA = 0

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
	local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
	local iAMERICA = GetPlayerIDFromCivID (AMERICA, false, true)
	
	local territoryMap = LoadTerritoryMap()

	for i, data in pairs (territoryMap) do
		local originalOwner = data.PlayerID
		if originalOwner == iNorway then
			initialNorway = initialNorway + 1
	
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

		elseif owner == iFrance then
			actualFrance = actualFrance + 1
			
		elseif owner == iUSSR then
			actualUSSR = actualUSSR + 1
		end
	end
	g_Norway_Land_Ratio = actualNorway / initialNorway
	Dprint ("Norway land ratio:	"..g_Norway_Land_Ratio, bDebug)
	g_France_Land_Ratio = actualFrance / initialFrance
	Dprint ("France land ratio:	"..g_France_Land_Ratio, bDebug)
	g_USSR_Land_Ratio = actualUSSR / initialUSSR
	Dprint ("USSR land ratio: "..g_USSR_Land_Ratio, bDebug)

		for x = 31, 39, 1 do
		for y = 40, 46, 1 do				--Territory of British Egypt
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



	for x = 130, 160, 1 do
		for y = 51, 69, 1 do				--Territory of USA
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iAMERICA then 
				initialUSA = initialUSA + 1			
			end
			if GetPlotFirstOwner(plotKey) == iAMERICA and plot:GetOwner() == iAMERICA then 
				actualUSA = actualUSA + 1
			end

		end
	end 

	g_USA_Land_Ratio = actualUSA / initialUSA
	Dprint ("USA land ratio: "..g_USA_Land_Ratio, bDebug)




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
						if (x > 1 and x < 26)  then -- Germany
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
								 
					elseif originalOwner == iAustria and (x > 1 and x < 26)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pAustria:GetName() .. " has fallen subject to German Anschluss, Germany has now united with Austria.", pAustria:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("AustriaHasFalled", 1)
		end
	end
--		end
--	end
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
						if (x > 1 and x < 100)  then -- Germany
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
					if originalOwner ~= iCzechoslovakia and ownerID == iCzechoslovakia then -- liberate plot captured by Czechoslovakia
							plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iCzechoslovakia and (x > 1 and x < 100)  then -- German territory
							plot:SetOwner(iGermany, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pCzechoslovakia:GetName() .. " has beeen annexed by Germany, Germany has now united with Czechoslovakia and created the Puppet Regime Slovakia.", pCzechoslovakia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("CzechoslovakiaHasFalled", 1)
		end
	end
end

function RomaniaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19380910 <= turnDate and 19380910 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Romania Annexed !")

		local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
		local pGermany = Players[iGermany]
			
		local team = Teams[ pGermany:GetTeam() ]
		Dprint("- Germany Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("RomaniaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Romania script ...")

			local iRomania = GetPlayerIDFromCivID (ROMANIA, true, true)
			local pRomania = Players[iRomania]

			for unit in pRomania:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Romania cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iRomania and originalOwner ~= iRomania then -- liberate cities captured by Czechoslovakia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iRomania then
						if (x > 1 and x < 100)  then -- Germany
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
					if originalOwner ~= iRomania and ownerID == iRomania then -- liberate plot captured by Hungary
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iRomania and (x > 1 and x < 100)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pCzechoslovakia:GetName() .. " has beeen annexed by Germany, Germany has now united with Czechoslovakia and created the Puppet Regime Slovakia.", pCzechoslovakia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("RomaniaHasFalled", 1)
		end
	end
end

function HungaryAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19380910 <= turnDate and 19380910 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Hungary Annexed !")

		local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
		local pGermany = Players[iGermany]
			
		local team = Teams[ pGermany:GetTeam() ]
		Dprint("- Germany Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("HungaryHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Hungary script ...")

			local iHungary = GetPlayerIDFromCivID (HUNGARY, true, true)
			local pHungary = Players[iHungary]

			for unit in pHungary:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Hungary cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iHungary and originalOwner ~= iHungary then -- liberate cities captured by Czechoslovakia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iHungary then
						if (x > 1 and x < 100)  then -- Germany
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
					if originalOwner ~= iHungary and ownerID == iHungary then -- liberate plot captured by Hungary
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iHungary and (x > 1 and x < 100)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pCzechoslovakia:GetName() .. " has beeen annexed by Germany, Germany has now united with Czechoslovakia and created the Puppet Regime Slovakia.", pCzechoslovakia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("HungaryHasFalled", 1)
		end
	end
end

function BulgariaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19380910 <= turnDate and 19380910 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Bulgaria Annexed !")

		local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
		local pGermany = Players[iGermany]
			
		local team = Teams[ pGermany:GetTeam() ]
		Dprint("- Germany Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("BulgariaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Bulgaria script ...")

			local iBulgaria = GetPlayerIDFromCivID (BULGARIA, true, true)
			local pBulgaria = Players[iBulgaria]

			for unit in pBulgaria:Units() do 
				unit:Kill()
			end						

			Dprint("- Change Bulgaria cities ownership ...")	
			for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
				local plot = Map.GetPlotByIndex(iPlotLoop)
				local x = plot:GetX()
				local y = plot:GetY()
				local plotKey = GetPlotKey ( plot )
				if plot:IsCity() then
					city = plot:GetPlotCity()
					local originalOwner = GetPlotFirstOwner(plotKey)
					if city:GetOwner() == iBulgaria and originalOwner ~= iBulgaria then -- liberate cities captured by Czechoslovakia
						Dprint(" - " .. city:GetName() .. " was captured, liberate...")	
						local originalPlayer = Players[originalOwner]
						originalPlayer:AcquireCity(city, false, true)
						--city:SetOccupied(false) -- needed in this case ?
					elseif originalOwner == iBulgaria then
						if (x > 1 and x < 100)  then -- Germany
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
					if originalOwner ~= iBulgaria and ownerID == iBulgaria then -- liberate plot captured by Hungary
						plot:SetOwner(originalOwner, -1 ) 
								 
					elseif originalOwner == iBulgaria and (x > 1 and x < 100)  then -- German territory
						plot:SetOwner(iGermany, -1 ) 

					end
				end
			end			
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pCzechoslovakia:GetName() .. " has beeen annexed by Germany, Germany has now united with Czechoslovakia and created the Puppet Regime Slovakia.", pCzechoslovakia:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("BulgariaHasFalled", 1)
		end
	end
end

-----------------------------------------
-- Annexation of the Baltic States
-----------------------------------------
function LithuaniaAnnexation()
	
	local turn = Game.GetGameTurn()
	local turnDate, prevDate = 0, 0
	if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
	if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end

	if 19400615 <= turnDate and 19400615 > prevDate then
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Baltic Annexed !")

		local iUSSR = GetPlayerIDFromCivID (USSR, false, true)
		local pUSSR = Players[iUSSR]
			
		local team = Teams[ pUSSR:GetTeam() ]
		Dprint("- USSR Selected ...")
		local savedData = Modding.OpenSaveData()
		local iValue = savedData.GetValue("LithuaniaHasFalled")
		if (iValue ~= 1) then
			Dprint("- First occurence, launching Fall of Lithuania script ...")

			local iLithuania = GetPlayerIDFromCivID (BALTIC, true, true)
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
					if city:GetOwner() == iLithuania and originalOwner ~= iLithuania then -- liberate cities captured by Baltics
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
				
			Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pLithuania:GetName() .. " has fallen to USSR, USSR has annexed the Baltic States.", pLithuania:GetName() .. " has been annexed !", -1, -1)

			savedData.SetValue("LithuaniaHasFalled", 1)
		end
	end
end


-----------------------------------------
-- Fall of France
-----------------------------------------
function NorthFranceInvaded()
	local bDebug = false
	local Metz = GetPlot(15,67):GetPlotCity()		-- Metz
	local Paris = GetPlot(13,65):GetPlotCity()		-- Paris
	local Caen = GetPlot(10,67):GetPlotCity()		-- Caen
	local Brest = GetPlot(7,67):GetPlotCity()		-- Caen
	
	if (Metz:IsOccupied() and Paris:IsOccupied() and Brest:IsOccupied() and Caen:IsOccupied()) then
		Dprint ("North France is occupied", bDebug)
		return true
	else
		Dprint ("North France is not occupied", bDebug)
		return false
	end
end

function NorthAfricaInvaded()
	local bDebug = false
	local Algier = GetPlot(12, 49):GetPlotCity()		-- Algier
	local Oran = GetPlot(10, 47):GetPlotCity()			-- Oran
	local Casablanca = GetPlot(4, 46):GetPlotCity()		-- Casablanca
	local Tunis= GetPlot(17, 49):GetPlotCity()			-- Tunis
	
	if (Algier:IsOccupied() and Oran:IsOccupied() and Casablanca:IsOccupied() and Tunis:IsOccupied()) then
		Dprint ("French Africa is occupied", bDebug)
		return true
	else
		Dprint ("French Africa is still free", bDebug)
		return false
	end
end

function NorthAfricaLiberated()
	local bDebug = false
	local Tobruk		= GetPlot(29, 47):GetPlotCity()		-- Tobruk
	local Tripolis		= GetPlot(20, 45):GetPlotCity()		-- Tripolis
	local Benghazi		= GetPlot(26, 47):GetPlotCity()		-- Benghazi
	local Algier		= GetPlot(12, 49):GetPlotCity()		-- Algier
	local Oran			= GetPlot(10, 47):GetPlotCity()		-- Oran
	local Casablanca	= GetPlot(4, 46):GetPlotCity()		-- Casablanca
	local Tunis			= GetPlot(17, 49):GetPlotCity()		-- Tunis
	
	if (Tobruk:IsOccupied() and Tripolis:IsOccupied() and Benghazi:IsOccupied()) then
		if (Algier:IsOccupied() or Oran:IsOccupied() or Casablanca:IsOccupied() or Tunis:IsOccupied()) then
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
	if x == 13 and y == 65 then -- city of Paris
	
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
	local cityPlot = GetPlot (13,65)
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
	local DamascusPlot = GetPlot (41,50)
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
			data.Unit:SetXY(41,50) -- Damascus
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
			data.Unit:SetXY(41,50) -- Damascus
		
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
			elseif ownerID ~= iVichy and originalOwner == iFrance and ((x < 12 and y > 58) or (y > 62 and x < 19)) then 
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
			elseif originalOwner == iFrance and ((y > 57 and x < 17))  then 
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
			elseif originalOwner == iFrance and (y > 53 and x > 16 and y < 58 and x < 19) then
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
			elseif originalOwner == iFrance and (y > 62 and x > 6 and y < 70 and x < 19) then 
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


function ConvertToFreeFrance (iAttackingPlayer, iAttackingUnit, iAttackingUnitDamage, iAttackingUnitFinalDamage, iAttackingUnitMaxHitPoints, iDefendingPlayer, iDefendingUnit, iDefendingUnitDamage, iDefendingUnitFinalDamage, iDefendingUnitMaxHitPoints)

	local savedData = Modding.OpenSaveData()
	local iValue = savedData.GetValue("FranceHasFallen")
	if (iValue == 1 and iAttackingPlayer == GetPlayerIDFromCivID (FRANCE, false, true) ) then -- Free France is attacking

		if iAttackingUnit > 0 and iDefendingUnit > 0 then
			local attPlayer = Players[iAttackingPlayer]
			local defPlayer = Players[iDefendingPlayer]
			local attUnit = attPlayer:GetUnitByID( iAttackingUnit )
			local defUnit = defPlayer:GetUnitByID( iDefendingUnit )
			local defUnitKey =  GetUnitKey(defUnit)
			local defUnitData = MapModData.RED.UnitData[defUnitKey]

			if (attUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and defUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and defUnitData) then
				if defUnitData.BuilderID == iAttackingPlayer then -- old french unit, try to convert
					Dprint ("Free France unit is attacking a Vichy France unit")
					local rand = math.random( 1, 100 )

					local diffDamage = iAttackingUnitDamage - iDefendingUnitDamage
					local defenderHealth = iDefendingUnitMaxHitPoints - iDefendingUnitFinalDamage
					local defenderHealthRatio =  defenderHealth / iDefendingUnitMaxHitPoints * rand -- 0 to 100
					local damageRatio = diffDamage * rand  -- (- diffDamage * 100) to (diffDamage * 100)

					if defenderHealth > 0 and (defenderHealthRatio < 10 or damageRatio < - 100) then
						-- chance are relative to lower health of old unit or damage received on defeat of free France attacking unit
						ChangeUnitOwner (defUnit, iAttackingPlayer)
						Events.GameplayAlertMessage(defUnit:GetNameNoDesc() .. " has joined Free France Army after a fight against " .. attUnit:GetNameNoDesc() )
					end
				end
			end
		end
	end
end
Events.EndCombatSim.Add( ConvertToFreeFrance )

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
	if x == 27 and y == 69 then -- city of Warsaw 
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

							elseif originalOwner == iPoland and (x > 24 and x < 30)  then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end

							elseif originalOwner == iPoland and (x > 29 and x < 33) then -- USSR Territory
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

	if x == 19 and y == 75 or x == 24 and y == 74 then -- Copenhagen, Aalborg 
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Denmark attacked !")		

		if (civID == GERMANY or civID == ITALY) then -- attacked by Germany or Italy...
			Dprint("- Attacked by Germany or Italy ...")

			local iUK = GetPlayerIDFromCivID (ENGLAND, false, true)
			local pUK = Players[iUK]

			local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
			local pGermany = Players[iGermany]

			local iAmerica = GetPlayerIDFromCivID (AMERICA, false, true)
			local pAmerica = Players[iAmerica]

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

						elseif originalOwner == iDenmark and (x > 18) and (x < 26) then -- German territory
								if plot:IsCity() and ownerID ~= iGermany then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pGermany:AcquireCity(city, false, true)
								else
									plot:SetOwner(iGermany, -1 ) 
								end 

						elseif originalOwner == iDenmark and (x < 19) and ownerID == iDenmark then -- Denmark to UK
								if plot:IsCity() and ownerID ~= newPlayerID then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pUK:AcquireCity(city, false, true)
								else
									plot:SetOwner(iUK, -1 ) 
								end 
						
						elseif originalOwner == iDenmark and (x > 154) and ownerID == iDenmark then -- Denmark to USA
								if plot:IsCity() and ownerID ~= newPlayerID then 
									local city = plot:GetPlotCity()
									EscapeUnitsFromPlot(plot)
									pAmerica:AcquireCity(city, false, true)
								else
									plot:SetOwner(iAmerica, -1 ) 
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
				
				for city in pAmerica:Cities() do
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

				Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, "To prevent civilian losses " .. pDenmark:GetName() .. " has surrender to Germany, Denmark has fallen under German control. Remaining Denmark territory is now under U.K. and U.S. protection", pDenmark:GetName() .. " has fallen !", cityPlot:GetX(), cityPlot:GetY())

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
	for x = 4, 13, 1 do
		for y = 70, 81, 1 do
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
	local suezPlot = GetPlot(38,46) -- Suez
	if suezPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
	end
end

function IsSuezOccupied()
	local suezPlot = GetPlot(38,46) -- Suez
	if suezPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return false
	else
		return true
	end
end

function IsBombayAlly()
	local bombayPlot = GetPlot(58,42) -- Bombay
	if bombayPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
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
	local CataniaPlot = GetPlot(20,49) -- Catania

	if CataniaPlot:GetOwner() == GetPlayerIDFromCivID (ITALY, false, true) then
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
	for x = 17, 24, 1 do
		for y = 49, 62, 1 do
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
	local Benghazi = GetPlot(26,47):GetPlotCity()		-- Benghazi
	local Tripoli = GetPlot(20,45):GetPlotCity()		-- Tripoli
	
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
	for x = 17, 28, 1 do
		for y = 62, 73, 1 do
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
	local Stalingrad = GetPlot(41, 67):GetPlotCity()		-- Stalingrad
	if (Stalingrad:IsOccupied()) then
		return true
	else
		return false
	end
end

-----------------------------------------
-- Japan
-----------------------------------------

function JapanIsSafe()
	local iJapan = GetPlayerIDFromCivID (JAPAN, false, true)
	local safe = true
	for x = 89, 99, 1 do
		for y = 53, 73, 1 do
			local plotKey = x..","..y
			local plot = GetPlot(x,y)
			if GetPlotFirstOwner(plotKey) == iJapan and plot:GetOwner() ~= iJapan then -- one of Japans plot has been conquered
				safe = false 
			end
		end
	end 
	return safe
end

function ShanghaiOccupied()
	local Shanghai = GetPlot(88, 56):GetPlotCity()		-- Shanghai
	if (Shanghai:IsOccupied()) then
		return true
	else
		return false
	end
end


-----------------------------------------
-- Liberation of Africa
-----------------------------------------
function FallOfVichy(hexPos, playerID, cityID, newPlayerID)

	if not ALLOW_SCRIPTED_EVENTS then
		return
	end

	local cityPlot = Map.GetPlot( ToGridFromHex( hexPos.x, hexPos.y ) )

	local x, y = ToGridFromHex( hexPos.x, hexPos.y )
	local civID = GetCivIDFromPlayerID(newPlayerID, false)
	local pAxis = Players[newPlayerID]
	if x == 4 and y == 46 then -- city of Casablanca
		Dprint ("-------------------------------------")
		Dprint ("Scripted Event : Casablanca has been captured !")		

		if (civID == AMERICA or civID == ENGLAND or civID == FRANCE) then -- captured by the Allies...
			Dprint("- Captured by the Allies ...")


			local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
			local pGermany = Players[iGermany]

			local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
			local pFrance = Players[iFrance]

			local team = Teams[ pGermany:GetTeam() ]
			Dprint("- Germany Selected ...")
			local pCasablanca = cityPlot:GetPlotCity()
			local savedData = Modding.OpenSaveData()
			local iValue = savedData.GetValue("VichyHasFalled")
			if (iValue ~= 1) then
				Dprint("- First occurence, launching Fall of Norway script ...")

				local iVichy = GetPlayerIDFromCivID (VICHY, true, true)
				local pVichy = Players[iVichy]



				for unit in pVichy:Units() do 
					unit:Kill()
				end						

				Dprint("- Change Vichy cities ownership ...")	
				for iPlotLoop = 0, Map.GetNumPlots()-1, 1 do
					local plot = Map.GetPlotByIndex(iPlotLoop)
					local x = plot:GetX()
					local y = plot:GetY()
					local plotKey = GetPlotKey ( plot )
					if plot:IsCity() then	
						city = plot:GetPlotCity()
						local originalOwner = GetPlotFirstOwner(plotKey)
						if originalOwner == iFrance then
							local x, y = city:GetX(), city:GetY()
							if ((x > 0 and y > 0) and (y < 52 and x < 16)) then -- France
								Dprint(" - " .. city:GetName() .. " is in France sphere...")	
								if city:GetOwner() ~= iFrance then 
									pFrance:AcquireCity(city, false, true)
									city:SetPuppet(false)
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								else -- just remove resistance if city was already occupied
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								end
							elseif ((x > 3 and y > 53) and (y < 70 and x < 23)) or ((x > 16 and y > 44) and (y < 51 and x < 22)) then -- Germany
								Dprint(" - " .. city:GetName() .. " is in Germany sphere...")
								if city:GetOwner() ~= iGermany then 
									pGermany:AcquireCity(city, false, true)
									city:SetPuppet(true)
									city:SetNumRealBuilding(COURTHOUSE, 1) -- above won't work, try workaround...
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								else -- just remove resistance if city was already occupied
									city:ChangeResistanceTurns(-city:GetResistanceTurns())
								end
							end					
						end
					end
				end
				
				-- remove resistance from Conquered Territories
				pCasablanca:ChangeResistanceTurns(-pCasablanca:GetResistanceTurns())
				
				Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, pVichy:GetName() .. " has been defeated by the Allies and Germany has taken control of it's remains.", pVichy:GetName() .. " has fallen, North Africa is liberated !", -1, -1)

				savedData.SetValue("VichyHasFalled", 1)
	
			end
		end
	end
end
Events.SerialEventCityCaptured.Add( FallOfVichy )

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
				
		Players[Game.GetActivePlayer()]:AddNotification(NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION, " America has passed the Lend Lease Act, France, the United Kingdom and the USSR will recieve extra convoys from America.", "Lend Lease Act Passed!")
	end
end

----------------------------------------------------------------------------------------------------------------------------
-- Remove Buildings when at War
----------------------------------------------------------------------------------------------------------------------------

function RemovebuildingsGermany()
	local iGermany = GetPlayerIDFromCivID (GERMANY, false, true)
	local pGermany = Players[iGermany]
	if not IsNeutral(iGermany) then
		Dprint("- Attempting to Run Remove Buildings Script for Germany ...")
		for city in pGermany:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsFrance()
	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local pFrance = Players[iFrance]
	if not IsNeutral(iFrance) then
		Dprint("- Attempting to Run Remove Buildings Script for France ...")
		for city in pFrance:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
			if city:IsHasBuilding(COLONY) then city:SetNumRealBuilding(COLONY, 0) end
		end
	end
end

function RemovebuildingsUK()
	local iEngland = GetPlayerIDFromCivID (ENGLAND, false, true)
	local pEngland = Players[iEngland]
	if not IsNeutral(iEngland) then
		Dprint("- Attempting to Run Remove Buildings Script for England ...")
		for city in pEngland:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsUSSR()
	local iUssr = GetPlayerIDFromCivID (USSR, false, true)
	local pUssr = Players[iUssr]
	if not IsNeutral(iUssr) then
		Dprint("- Attempting to Run Remove Buildings Script for USSR ...")
		for city in pUssr:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsChina()
	local iChina = GetPlayerIDFromCivID (CHINA, false, true)
	local pChina = Players[iChina]
	if not IsNeutral(iChina) then
		Dprint("- Attempting to Run Remove Buildings Script for China ...")
		for city in pChina:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsAmerica()
	local iAmerica = GetPlayerIDFromCivID (AMERICA, false, true)
	local pAmerica = Players[iAmerica]
	if not IsNeutral(iAmerica) then
		Dprint("- Attempting to Run Remove Buildings Script for America ...")
		for city in pAmerica:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsItaly()
	local iItaly = GetPlayerIDFromCivID (ITALY, false, true)
	local pItaly = Players[iItaly]
	if not IsNeutral(iItaly) then
		Dprint("- Attempting to Run Remove Buildings Script for Italy ...")
		for city in pItaly:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
	end
end

function RemovebuildingsJapan()
	local iJapan = GetPlayerIDFromCivID (JAPAN, false, true)
	local pJapan = Players[iJapan]
	if not IsNeutral(iJapan) then
		Dprint("- Attempting to Run Remove Buildings Script for Italy ...")
		for city in pJapan:Cities() do
			if city:IsHasBuilding(ALLIEDCITY) then city:SetNumRealBuilding(ALLIEDCITY, 0) end
			if city:IsHasBuilding(AXISCITY) then city:SetNumRealBuilding(AXISCITY, 0) end
			if city:IsHasBuilding(COMINTERNCITY) then city:SetNumRealBuilding(COMINTERNCITY, 0) end
			if city:IsHasBuilding(NODRAFT) then city:SetNumRealBuilding(NODRAFT, 0) end
			if city:IsHasBuilding(LIMITEDDRAFT) then city:SetNumRealBuilding(LIMITEDDRAFT, 0) end
		end
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
	local bDebug = false
	Dprint("   - Checking possible maritime route from USA to Murmansk", bDebug)
	local turn = Game.GetGameTurn()
	if g_Calendar[turn] then 
		turnDate = g_Calendar[turn].Number
	 else 
		turnDate = 0
	end
	if turnDate < 19410701 then
		return false
	end
	local plotMurmansk = GetPlot(39,89)
	local plotMoscow = GetPlot(40,72)
	local ussr = Players[GetPlayerIDFromCivID(USSR, false)]

	return isPlotConnected( ussr , plotMurmansk, plotMoscow, "Road", false, nil , PathBlocked)
	
end

function IsRailOpenRostowtoStalingrad()
	local bDebug = false
	Dprint("   - Checking possible maritime route from Suez to Stalingrad", bDebug)
	local turn = Game.GetGameTurn()
	if g_Calendar[turn] then 
		turnDate = g_Calendar[turn].Number
	 else 
		turnDate = 0
	end
	if turnDate < 19410701 then
		return false
	end
	local plotSuez = GetPlot(38,46)
	local plotStalingrad = GetPlot(41,67)
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
	
	local plotOulu = GetPlot(31,85)
	local plotInari = GetPlot(32,89)
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
	local plotLulea = GetPlot(28,87)
	local plotNarvik = GetPlot(26,90)
	local germany = Players[GetPlayerIDFromCivID(GERMANY, false)]

	-- No rail on CS cities, so check rail first, then road.
	local bRail = isPlotConnected( germany , plotLulea, plotNarvik, "Railroad", false, nil , PathBlocked) 	
	if bRail then
		Dprint("     - Railroad from Lulea to Narvik is open for Germany...", bDebug)
	else
		Dprint("     - Railroad from Lulea to Narvik is closed for Germany...", bDebug)
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
	return true	
	
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

function IsHongKongAlly()
	local hkPlot = GetPlot(83,45) -- Hong Kong
	if hkPlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
	end
end

function IsHongKongAxis()
	local HongKongPlot = GetPlot(83,45) -- HongKong
	if HongKongPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) then
		return true
	else
		return false
	end
end

function IsShanghaiAlly()
	local shanghaiPlot = GetPlot(88,56) -- Shanghai
	if shanghaiPlot:GetOwner() == GetPlayerIDFromCivID (CHINA, false, true) then
		return true
	else
		return false
	end
end

function IsJakartaAxis()
	local jakartaPlot = GetPlot(81,26) -- Jakarta
	if jakartaPlot:GetOwner() == GetPlayerIDFromCivID (JAPAN, false, true) then
		return true
	else
		return false
	end
end

function IsPanamaAlly()
	local panamaPlot = GetPlot(151,40) -- Panama
	if panamaPlot:GetOwner() == GetPlayerIDFromCivID (AMERICA, false, true) then
		return true
	else
		return false
	end
end

function IsSaigonAlly()
	local saigonPlot = GetPlot(79,39) -- Saigon
	if saigonPlot:GetOwner() == GetPlayerIDFromCivID (FRANCE, false, true) then
		return true
	else
		return false
	end
end

function IsSingaporeAlly()
	local singaporePlot = GetPlot(78,32) -- Singapore
	if singaporePlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return true
	else
		return false
	end
end

function IsSingaporeOccupied()
	local singaporePlot = GetPlot(78,32) -- Singapore
	if singaporePlot:GetOwner() == GetPlayerIDFromCivID (ENGLAND, false, true) then
		return false
	else
		return true
	end
end

function isGdanskOccupied()
local gdanskPlot = GetPlot(26,72) -- Gdansk
	if gdanskPlot:GetOwner() == GetPlayerIDFromCivID (GERMANY, false, true) then
		return false
	else
		return true
	end
end

-----------------------------------------
-- French Convoys
-----------------------------------------
function GetUStoFranceTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} -- Reference is quantity of materiel, personnel or gold. For TRANSPORT_UNIT, Reference is the unit type ID
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then
		if turnDate < 19400101 then
			transport = {Type = TRANSPORT_GOLD, Reference = 200}
		elseif turnDate < 19420601 or turnDate >= 19400101 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B17}
		elseif turnDate < 19430601 or turnDate >= 19420601 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B24}
		elseif turnDate >= 19431001 then
			transport = {Type = TRANSPORT_UNIT, Reference = US_B29}
		end
	else 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
	end
	return transport
end

function GetSaigontoFranceTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = FR_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
	end
	
	return transport
end

function GetSueztoFranceTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 500}
	end
	return transport
end

function GetAfricatoFranceTransport()
	local rand = math.random( 1, 3 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} -- Reference is quantity of materiel, personnel or gold. For TRANSPORT_UNIT, Reference is the unit type ID
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then  
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
	end
	return transport
end

-----------------------------------------
-- British Convoys
-----------------------------------------
function GetUStoUKTransport()
	local rand = math.random( 1, 3 )
	local rand1 = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
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
		transport = {Type = TRANSPORT_GOLD, Reference = 100}
	end
	return transport
end

function GetBombaytoUKTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 100}
	end
	
	return transport
end

function GetHongKongtoUKTransport()
	local transport = {Type = TRANSPORT_GOLD, Reference = 100}
	return transport
end

function GetSingaporetoUKTransport()
	local transport = {Type = TRANSPORT_GOLD, Reference = 100}
	return transport
end

function GetAustraliatoUKTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
	end
	
	return transport
end

function GetCanadatoUKTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_UNIT, Reference = CA_INFANTRY}
	end
	
	return transport
end

function GetSueztoUKTransport()
	local rand = math.random( 1, 6 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 100}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = UK_INFANTRY}
	elseif rand == 4 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 100}
	elseif rand > 4 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300}
	end
	
	return transport
end

-----------------------------------------
-- American Convoys
-----------------------------------------
function GetBraziltoUSTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 150} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 200}
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

function GetSueztoUSTransport()
	local rand = math.random( 1, 4 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 100} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 100}
	elseif rand > 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 200}
	end	
	
	return transport
end

function GetCaraibOilTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_OIL, Reference = 200} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300}
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

-----------------------------------------
-- German Convoys
-----------------------------------------
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
	if rand < 3 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300 * factor} 
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_PERSONNEL, Reference = 300 * factor} 
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300 * factor} 	
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
	if rand < 3 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 300 * factor} 
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_OIL, Reference = 300 * factor} 
	elseif rand > 3 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 300 * factor} 	
	end
	return transport
end

-----------------------------------------
-- Italian Convoys
-----------------------------------------
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

function GetTripolitoItalyTransport()
	local transport
	transport = {Type = TRANSPORT_GOLD, Reference = 300}	 
	return transport
end

-----------------------------------------
-- Soviet Convoys
-----------------------------------------
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

-----------------------------------------
-- Japan Convoys
-----------------------------------------

function GetJakartatoJapanTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 500}
	end	
	return transport
end

function GetSingaporetoJapanTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 500}
	end	
	return transport
end

function GetHongKongtoJapanTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 1000} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 500}
	end	
	return transport
end

-----------------------------------------
-- Chinese Convoys
-----------------------------------------

function GetUStoChinaTransport()
	local rand = math.random( 1, 2 )
	local transport
	if rand == 1 then
		transport = {Type = TRANSPORT_MATERIEL, Reference = 550} 
	elseif rand == 2 then 
		transport = {Type = TRANSPORT_GOLD, Reference = 325}
	elseif rand == 3 then 
		transport = {Type = TRANSPORT_UNIT, Reference = CH_P40N}
	end	
	return transport
end
-- ... then define the convoys table
-- don't move those define from this files, they must be set AFTER the functions definition...

-- Route list

US_TO_FRANCE	= 1
US_TO_FRANCE_2	= 2
US_TO_UK		= 3
US_TO_UK_2		= 4
US_TO_UK_3		= 5
SUEZ_TO_UK		= 6
BOMBAY_TO_UK	= 7
HONGKONG_TO_UK	= 8
AUSTRALIA_TO_UK = 9
CANADA_TO_UK	= 10
SINGAPORE_TO_UK = 11
CARAIB_TO_UK	= 12
SAIGON_TO_FRANCE = 13
SUEZ_TO_FRANCE	 = 14
AFRICA_TO_FRANCE = 15
CARAIB_TO_FRANCE = 16
NORWAY_TO_GERMANY  = 17
SWEDEN_TO_GERMANY  = 18
FINLAND_TO_GERMANY = 19
AFRICA_TO_ITALY	   = 2
SUEZ_TO_ITALY	   = 21
US_TO_USSR		= 22
US_TO_USSR_2	= 23
SUEZ_TO_USSR	= 24
JAKARTA_TO_JAPAN	= 25
SINGAPORE_TO_JAPAN	= 26
HONGKONG_TO_JAPAN	= 27
PANAMA_TO_US		= 28
BRAZIL_TO_US		= 29
US_TO_CHINA			= 30
US_TO_UK_USAF1		= 31
US_TO_UK_USAF_RES	= 32
US_TO_FR_ARMY1		= 33
US_TO_FR_ARMY_RES	= 34
US_TO_UK_ARMY1		= 35
TRIPOLI_TO_ITALY	= 36

-- Convoy table
g_Convoy = { 
	[US_TO_FRANCE] = {
		Name = "US to France",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=7, Y=67}, {X=15, Y=59}, }, -- Brest, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFrance, -- Must refer to a function, remove this line to use the default condition (true)
		UnloadCondition = function() return true; end, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},

	[US_TO_FRANCE_2] = {
		Name = "US to France",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=7, Y=67}, {X=15, Y=59}, }, -- Brest, Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 10, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, -- Must refer to a function, remove this line to use the default condition (true)
		--UnloadCondition = function() return true; end, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},

	[US_TO_UK] = {
		Name = "US to UK",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		-- Condition = IsRouteOpenUStoUK, -- no special condition here, let the spawning function do the job...
		Transport = GetUStoUKTransport,
	},

	[US_TO_UK_2] = {
		Name = "US to UK 2",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 20, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetUStoUKTransport,
	},

	[US_TO_UK_3] = {
		Name = "US to UK 3",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetUStoUKTransport,
	},

	[SUEZ_TO_UK] = {
		Name = "Suez to UK",
		SpawnList = { {X=37, Y=47}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoUKTransport,
	},

	[BOMBAY_TO_UK] = {
		Name = "Bombay to UK",
		SpawnList = { {X=57, Y=42}, {X=57, Y=41}, }, -- Adjacent to Bombay
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsBombayAlly,
		Transport = GetBombaytoUKTransport,
	},

	[HONGKONG_TO_UK] = {
		Name = "Hong Kong to UK",
		SpawnList = { {X=83, Y=44}, {X=84, Y=44}, {X=84, Y=45}, }, -- Adjacent to Hong Kong
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsHongKongAlly,
		Transport = GetHongKongtoUKTransport,
	},

	[AUSTRALIA_TO_UK] = {
		Name = "Australia to UK",
		SpawnList = { {X=83, Y=11}, }, -- Adjacent to Perth
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 10, -- probability (in percent) of convoy spawning at each turn
		-- Condition = IsRouteOpenUStoUK, -- no special condition here, let the spawning function do the job...
		Transport = GetAustraliatoUKTransport,
	},

	[CANADA_TO_UK] = {
		Name = "Canada to UK",
		SpawnList = { {X=157, Y=70}, }, -- Adjacent to Quebec City
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 12, -- probability (in percent) of convoy spawning at each turn
		-- Condition = IsRouteOpenUStoUK, -- no special condition here, let the spawning function do the job...
		Transport = GetCanadatoUKTransport,
	},

	[SINGAPORE_TO_UK] = {
		Name = "Singapore to UK",
		SpawnList = { {X=77, Y=31}, }, -- Adjacent to Singapore
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSingaporeAlly,
		Transport = GetSingaporetoUKTransport,
	},

	[CARAIB_TO_UK] = {
		Name = "Caraib to UK",
		SpawnList = { {X=153, Y=45}, }, -- Adjacent to Kingston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_UK"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Transport = GetCaraibOilTransport,
	},

	[SAIGON_TO_FRANCE] = {
		Name = "Saigon to France",
		SpawnList = { {X=80, Y=38}, {X=80, Y=39}, }, -- Adjacent to Saigon
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=15, Y=59}, }, -- Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSaigonAlly,
		Transport = GetSaigontoFranceTransport,
	},

	[SUEZ_TO_FRANCE] = {
		Name = "Suez to France",
		SpawnList = { {X=37, Y=47}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=15, Y=59}, }, -- Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezAlly,
		Transport = GetSueztoFranceTransport,
	},

	[AFRICA_TO_FRANCE] = {
		Name = "Africa to France",
		SpawnList = { {X=12, Y=50}, {X=13, Y=50}, }, -- adjacent to Alger
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=15, Y=59}, }, -- Marseille
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoFranceTransport, -- Must refer to a function, remove this line to use the default function
	},

	[CARAIB_TO_FRANCE] = {
		Name = "Caraib to France",
		SpawnList = { {X=165, Y=38}, }, -- Adjacent to Cayenne
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=7, Y=67}, {X=10, Y=67}, {X=15, Y=59}, {X=4, Y=46}, }, -- Brest, Caen, Marseille, Casablanca
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_CARAIB_TO_FRANCE"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsFranceStanding, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetCaraibOilTransport, -- Must refer to a function, remove this line to use the default function
	},

	[NORWAY_TO_GERMANY] = {
		Name = "Norway to Germany",
		SpawnList = { {X=25, Y=90}, }, -- adjacent to Narvik
		RandomSpawn = false,
		DestinationList = { {X=20, Y=73}, }, -- Hamburg
		RandomDestination = false,
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 50,
		Condition = IsRouteOpenNorwaytoGermany,
		Transport = GetNorwaytoGermanyTransport,
	},

	[SWEDEN_TO_GERMANY] = {
		Name = "Sweden to Germany",
		SpawnList = { {X=29, Y=86}, }, -- adjacent to Lulea
		RandomSpawn = false,
		DestinationList = { {X=20, Y=73}, }, -- Hamburg
		RandomDestination = false,
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 50,
		Condition = IsRouteOpenSwedentoGermany, 
		Transport = GetFinlandtoGermanyTransport, -- re-use Finland values...
	},

	[FINLAND_TO_GERMANY] = {
		Name = "Finland to Germany",
		SpawnList = { {X=30, Y=85}, }, -- adjacent to Oulu
		RandomSpawn = false,
		DestinationList = { {X=20, Y=73}, }, -- Hamburg
		RandomDestination = false,
		CivID = GERMANY,
		MaxFleet = 1, 
		Frequency = 50,
		Condition = IsRouteOpenFinlandtoGermany,
		Transport = GetFinlandtoGermanyTransport,
	},

	[AFRICA_TO_ITALY] = {
		Name = "Africa to Italy",
		SpawnList = { {X=21, Y=46}, {X=25, Y=47}, }, -- adjacent to Tripoli, Benghazi
		RandomSpawn = true,
		DestinationList = { {X=21, Y=54}, {X=19, Y=57}, }, -- Napoli, Roma
		RandomDestination = false,
		CivID = ITALY,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_AFRICA_TO_ITALY"},
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsLibyaAlly, -- Must refer to a function, remove this line to use the default function
		Transport = GetAfricatoItalyTransport, -- Must refer to a function, remove this line to use the default function
	},

	[SUEZ_TO_ITALY] = {
		Name = "Suez to Italy",
		SpawnList = { {X=37, Y=47}, },
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=20, Y=49}, {X=21, Y=54}, {X=19, Y=57}, }, -- Catania, Napoli, Roma
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ITALY,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSuezOccupied,
		Transport = GetSueztoItalyTransport,
	},

	[US_TO_USSR] = {
		Name = "US to USSR",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=39, Y=89}, {X=38, Y=83},}, -- Murmansk, Archangelsk
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenMurmansktoMoscow,
		Transport = GetSueztoUSSRTransport,
	},

	[US_TO_USSR_2] = {
		Name = "US to USSR",
		SpawnList = { {X=131, Y=62}, {X=131, Y=59}, }, -- Adjacent to San Francisco, Los Angeles
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=92, Y=66}, {X=102, Y=76},}, -- Wladivostok, Petropavlosk
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenLendLease, 
		Transport = GetSueztoUSSRTransport,
	},

	[SUEZ_TO_USSR] = {
		Name = "Suez to USSR",
		SpawnList = { {X=37, Y=47}, },
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=39, Y=62}, }, -- Rostow
		RandomDestination = false, -- false : sequential try in destination list
		CivID = USSR,
		UnitsName = {'TXT_KEY_UNIT_CONVOY_SUEZ_TO_USSR'},
		MaxFleet = 5,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRailOpenRostowtoStalingrad,
		Transport = GetSueztoUSSRTransport,
	},

	[JAKARTA_TO_JAPAN] = {
		Name = "Jakarta to Japan",
		SpawnList = { {X=82, Y=26}, {X=81, Y=27}, {X=80, Y=27}, }, -- Adjacent to Jakarta
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=90, Y=55}, {X=94, Y=57}, {X=97, Y=58}, }, -- Nagasaki, Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsJakartaAxis,
		Transport = GetJakartatoJapanTransport,
	},

	[SINGAPORE_TO_JAPAN] = {
		Name = "Singapore to Japan",
		SpawnList = { {X=78, Y=33}, {X=79, Y=32}, }, -- Adjacent to Singapore
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=90, Y=55}, {X=94, Y=57}, {X=97, Y=58}, }, -- Nagasaki, Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsSingaporeOccupied,
		Transport = GetSingaporetoJapanTransport,
	},

	[HONGKONG_TO_JAPAN] = {
		Name = "Hong Kong to Japan",
		SpawnList = { {X=83, Y=44}, {X=84, Y=44}, }, -- Adjacent to Hong Kong
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=90, Y=55}, {X=94, Y=57}, {X=97, Y=58}, }, -- Nagasaki, Osaka, Tokyo
		RandomDestination = false, -- false : sequential try in destination list
		CivID = JAPAN,
		MaxFleet = 1,
		Frequency = 33, -- probability (in percent) of convoy spawning at each turn
		Condition = IsHongKongAxis,
		Transport = GetSingaporetoJapanTransport,
	},

	[PANAMA_TO_US] = {
		Name = "Panama to America",
		SpawnList = { {X=151, Y=41}, }, -- Adjacent to Panama
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=157, Y=65}, }, -- New York
		RandomDestination = false, -- false : sequential try in destination list
		CivID = AMERICA,
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsPanamaAlly,
		Transport = GetPanamatoUSTransport,
	},

	[BRAZIL_TO_US] = {
		Name = "Brazil to America",
		SpawnList = { {X=166, Y=21}, }, --Adjacent to Sao Paulo
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=157, Y=65}, }, -- New York
		RandomDestination = false, -- false : sequential try in destination list
		CivID = AMERICA,
		MaxFleet = 1,
		Frequency = 10, -- probability (in percent) of convoy spawning at each turn
		--Condition = IsFortalezaAlly,
		Transport = GetBraziltoUSTransport,
	},

	[US_TO_CHINA] = {
		Name = "America to China",
		SpawnList = { {X=131, Y=59}, {X=131, Y=58}, }, --Adjacent to Los Angeles
		RandomSpawn = false, -- true : random choice in spawn list
		DestinationList = { {X=88, Y=56}, }, -- Shanghai
		RandomDestination = false, -- false : sequential try in destination list
		CivID = CHINA,
		MaxFleet = 1,
		Frequency = 20, -- probability (in percent) of convoy spawning at each turn
		Condition = IsShanghaiAlly,
		Transport = GetUStoChinaTransport,
	},

	[US_TO_UK_USAF1] = {
		Name = "US to UK - USAF 1",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_1"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUSAFtoUKTransport1,
	},

	[US_TO_UK_USAF_RES] = {
		Name = "US to UK - USAF Oil",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71}, {X=7, Y=51},}, -- Liverpool, Edinburgh, London, Gibraltar
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_USAF_Oil"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUSAFtoUK1,
		Transport = GetUStoEuropeArmyResources,
	},

	[US_TO_FR_ARMY1] = {
		Name = "US to France -> Army",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=7, Y=67}, {X=10, Y=67}, {X=15, Y=59}, {X=4, Y=46}, }, -- Brest, Caen, Marseille, Casablanca
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_MIL"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeTroops1, -- Must refer to a function, remove this line to use the default function
	},

	[US_TO_FR_ARMY_RES] = {
		Name = "US to France -> resources for Army",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=7, Y=67}, {X=10, Y=67}, {X=15, Y=59}, {X=4, Y=46}, }, -- Brest, Caen, Marseille, Casablanca
		RandomDestination = false, -- false : sequential try in destination list
		CivID = FRANCE,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_FRANCE_RES"},
		MaxFleet = 1, -- how many convoy can use that route at the same time (not implemented)
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoFranceTroops1, -- Must refer to a function, remove this line to use the default condition (true)
		Transport = GetUStoEuropeArmyResources, -- Must refer to a function, remove this line to use the default function
	},

	[US_TO_UK_ARMY1] = {
		Name = "US to UK - Army 1",
		SpawnList = { {X=158, Y=64}, {X=157, Y=62}, {X=159, Y=65}, {X=160, Y=66}, }, -- Adjacent New York, Washington and Boston
		RandomSpawn = true, -- true : random choice in spawn list
		DestinationList = { {X=9, Y=74}, {X=10, Y=77}, {X=11, Y=71},}, -- Liverpool, Edinburgh, London
		RandomDestination = false, -- false : sequential try in destination list
		CivID = ENGLAND,
		UnitsName = {"TXT_KEY_UNIT_CONVOY_US_TO_UK_MIL"},
		MaxFleet = 1,
		Frequency = 15, -- probability (in percent) of convoy spawning at each turn
		Condition = IsRouteOpenUStoUKTroops1,
		Transport = GetUStoEuropeTroops1,
	},

	[AFRICA_TO_ITALY] = {
		Name = "Tripoli to Italy",
		SpawnList = { {X=21, Y=46}, {X=25, Y=47}, }, -- adjacent to Tripoli, Benghazi
		RandomSpawn = true,
		DestinationList = { {X=21, Y=54}, {X=19, Y=57}, }, -- Napoli, Roma
		RandomDestination = false,
		CivID = ITALY,
		UnitsName = {"Tripoli to Italy Convoy"},
		MaxFleet = 1, 
		Frequency = 33,
		Condition = IsLibyaAlly, -- Must refer to a function, remove this line to use the default function
		Transport = GetTripolitoItalyTransport, -- Must refer to a function, remove this line to use the default function
	},

}



----------------------------------------------------------------------------------------------------------------------------
-- Troops Naval routes
----------------------------------------------------------------------------------------------------------------------------
function JapanReinforcementToNorthChina()

	local bDebug = false
	
	Dprint ("  - Japan is Checking to sent reinforcement troops to NorthChina", bDebug)

	if not JapanIsSafe() then
		Dprint ("   - but Japan is invaded, got priority...", bDebug)
		return false
	end

	local iChina = GetPlayerIDFromCivID (CHINA, false, true)
	local pChina = Players[iChina]

	local iJapan = GetPlayerIDFromCivID (JAPAN, false, true)
	local pJapan = Players[iJapan]


	if not AreAtWar( iJapan, iChina) then	
		Dprint ("   - but Japan has not declared war to China...", bDebug)
		return false
	end

	return true
end

function JapanReinforcementToMiddleChina()

	local bDebug = false
	
	Dprint ("  - Japan is Checking to sent reinforcement troops to Middle China", bDebug)

	if not JapanIsSafe() then
		Dprint ("   - but Japan is invaded, got priority...", bDebug)
		return false
	end

	if not ShanghaiOccupied() then
		Dprint ("   - but Shanghai is not occupied, reinforce the north...", bDebug)
		return false
	end
	
	local iChina = GetPlayerIDFromCivID (CHINA, false, true)
	local pChina = Players[iChina]

	local iJapan = GetPlayerIDFromCivID (JAPAN, false, true)
	local pJapan = Players[iJapan]


	if not AreAtWar( iJapan, iChina) then	
		Dprint ("   - but Japan has not declared war to China...", bDebug)
		return false
	end

	return true
end


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
	
	local allyInNorway = GetTeamLandForceInArea( pUK, 17, 78, 34, 92 ) -- (17, 78) -> (34, 92) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pUK, 17, 78, 34, 92 )
	
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


	local allyInLibya = GetTeamLandForceInArea( pItaly, 16, 39, 30, 47 )
	local enemyInLibya = GetEnemyLandForceInArea( pItaly, 11, 41, 37, 47)  --Tunis to Suez

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

function FranceReinforcementToAfrica()

	local bDebug = false
	Dprint ("  - France is Checking to sent reinforcement troops to Africa", bDebug)

	if FranceHasFallen() then
		Dprint ("   - but France has fallen, nothing to send...", bDebug)
		return false
	end

	local iFrance = GetPlayerIDFromCivID (FRANCE, false, true)
	local pFrance = Players[iFrance]


	local allyInAfrica = GetTeamLandForceInArea( pFrance, 3, 44, 18, 49 )
	local enemyInAfrica = GetEnemyLandForceInArea( pFrance, 3, 44, 18, 49 )  --French N-Africa

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
	
	local friendInNorway = GetTeamLandForceInArea( pGermany, 17, 78, 34, 92 ) -- (17, 78) -> (34, 92) ~= norway rectangular area
	local enemyInNorway = GetEnemyLandForceInArea( pGermany, 17, 78, 34, 92 )
	
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
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 6, 70, 13, 80 ) -- (6, 70) -> (13, 80) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK and need another operation Seelowe...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 6, 70, 13, 80 )	
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
	
	local friendInUK = GetTeamLandForceInArea( pGermany, 6, 70, 13, 80 ) -- (6, 70) -> (13, 80) ~= UK rectangular area
	if friendInUK == 0 then	
		Dprint ("   - but Axis ("..friendInUK..") have no force left in UK...", bDebug)
		return false
	end

	local enemyInUK = GetEnemyLandForceInArea( pGermany, 6, 70, 13, 80  )	
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
TROOPS_JAPAN_CHINA1 = 1
TROOPS_JAPAN_CHINA2 = 2
TROOPS_JAPAN_CHINA3 = 3
TROOPS_INVADE_CHINA_1 = 4
TROOPS_INVADE_CHINA_2 = 5
TROOPS_INVADE_GUAM = 6
TROOPS_INVADE_WAKE = 7
TROOPS_INVADE_TARAWA = 8
TROOPS_INVADE_GUADALCANAL = 9
TROOPS_INVADE_RABAUL = 10
TROOPS_INVADE_PHILIPPINES = 11
TROOPS_INVADE_JAYAPARA = 12
TROOPS_INVADE_MEDAN = 13
TROOPS_INVADE_SINGAPORE = 14
TROOPS_INVADE_BORNEO = 15
TROOPS_INVADE_MAKASSAR = 16
TROOPS_INVADE_MANADO = 17
TROOPS_INVADE_JAKARTA = 18
TROOPS_GERMANY_NORWAY = 19
TROOPS_GERMANY_SEELOWE_KIEL = 20
TROOPS_GERMANY_SEELOWE_ST_NAZAIRE = 21
TROOPS_GERMANY_UK = 22
TROOPS_GERMANY_BACK_UK = 23
TROOPS_ITALY_AFRICA = 24
TROOPS_UK_FRANCE = 25
TROOPS_UK_NORWAY = 26
TROOPS_UK_AFRICA = 27
TROOPS_UK_DDAY = 28
TROOPS_LIBERATE_ALGIERSBRITISH = 29
TROOPS_LIBERATE_SICILYBRITISH = 30
TROOPS_LIBERATE_ITALYBRITISH = 31
TROOPS_FRANCE_AFRICA = 32
TROOPS_RUSSIA_WEST_1 = 33
TROOPS_RUSSIA_WEST_2 = 34
TROOPS_LIBERATE_CASABLANCA = 35
TROOPS_LIBERATE_ORAN = 36
TROOPS_LIBERATE_ALGIERS = 37
TROOPS_LIBERATE_SICILY = 38
TROOPS_LIBERATE_ITALY = 39
TROOPS_OVERLORD_1 = 40
TROOPS_OVERLORD_2 = 41
TROOPS_OVERLORD_3 = 42
TROOPS_US_UK_DDAY_1 = 43
TROOPS_US_UK_DDAY_2 = 44
-- troops route table

g_TroopsRoutes = { 
	[JAPAN] = {	
			[TROOPS_JAPAN_CHINA1] = {
				Name = "Japan to Middle China",
				CentralPlot = {X=95, Y=57},
				MaxDistanceFromCentral = 7,
				ReserveUnits = 2, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=90, Y=55}, {X=91, Y=56}, {X=91, Y=54}, {X=89, Y=57},}, -- near Nagasaki or island
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=87, Y=55}, {X=87, Y=54}, {X=87, Y=53}, {X=87, Y=52}, }, -- near Shanghai, Fuzhou
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 3, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = JapanReinforcementToMiddleChina, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_JAPAN_CHINA2] = {
				Name = "Japan to North China",
				CentralPlot = {X=95, Y=57},
				MaxDistanceFromCentral = 7,
				ReserveUnits = 2, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=97, Y=63}, {X=97, Y=62}, {X=97, Y=64},}, -- near Akita
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=90, Y=64}, {X=90, Y=65}, {X=91, Y=65}, {X=90, Y=63}, }, -- near Pjöngyang
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 3, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = JapanReinforcementToNorthChina, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_JAPAN_CHINA3] = {
				Name = "Taiwan to China",
				CentralPlot = {X=89, Y=48},
				MaxDistanceFromCentral = 2,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=88, Y=49}, }, -- Taipeh
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=86, Y=51}, {X=85, Y=49}, {X=87, Y=52}, {X=85, Y=48}, }, -- near Fuzhou
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 3, -- Maximum number of units on the route at the same time
				Priority = 50, 
			},
			[TROOPS_INVADE_CHINA_1] = {
				Name = "Japan to China 1",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=85, Y=59}, {X=86, Y=58}, {X=86, Y=57}, {X=87, Y=56}, },
				RandomLanding = false, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_CHINA_2] = {
				Name = "Japan to China 2",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=84, Y=46}, {X=84, Y=47}, {X=87, Y=52}, {X=85, Y=48}, },
				RandomLanding = false, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_GUAM] = {
				Name = "Japan to Guam",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=99, Y=43}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_WAKE] = {
				Name = "Japan to Wake",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=108, Y=52}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_TARAWA] = {
				Name = "Japan to Tarawa",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=113, Y=33}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_GUADALCANAL] = {
				Name = "Japan to Guadalcanal",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=109, Y=26}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_RABAUL] = {
				Name = "Japan to Rabaul",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=104, Y=29} },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_PHILIPPINES] = {
				Name = "Japan to Philippines",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=88, Y=41}, {X=88, Y=42}, {X=89, Y=40}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_JAYAPARA] = {
				Name = "Japan to Jayapara",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=98, Y=30}, {X=97, Y=30}, {X=96, Y=29}, {X=99, Y=30}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_MEDAN] = {
				Name = "Japan to Medan",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=75, Y=31}, {X=76, Y=30}, {X=77, Y=29}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_SINGAPORE] = {
				Name = "Japan to Singapore",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=77, Y=33}, {X=77, Y=32}, {X=78, Y=32}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_BORNEO] = {
				Name = "Japan to Borneo",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=85, Y=28}, {X=83, Y=28}, {X=84, Y=28}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_MAKASSAR] = {
				Name = "Japan to Makassar",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=88, Y=28}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_MANADO] = {
				Name = "Japan to Manado",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=90, Y=31}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_INVADE_JAKARTA] = {
				Name = "Japan to Jakarta",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=80, Y=26}, {X=81, Y=25}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
	},

	[GERMANY] = {	
			[TROOPS_GERMANY_NORWAY] = {
				Name = "Germany to Norway",
				CentralPlot = {X=21, Y=67},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=20, Y=73}, {X=20, Y=72}, }, -- near Hamburg
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=18, Y=76}, {X=21, Y=76}, },
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=18, Y=80}, {X=18, Y=79}, {X=19, Y=78}, {X=20, Y=78}, {X=20, Y=79}, }, -- Between Bergen and Oslo
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_GERMANY_SEELOWE_KIEL] = {
				Name = "Germany to UK (Seelowe from Kiel)",
				WaypointList = { {X=16, Y=75}, },
				RandomWaypoint = false, 
				LandingList = { {X=10, Y=76}, {X=10, Y=75}, {X=11, Y=74}, {X=11, Y=73}, {X=12, Y=72}, {X=12, Y=70},}, -- Between London and Edinburgh
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_SEELOWE_ST_NAZAIRE] = {
				Name = "Germany to UK (Seelowe from St Nazaire)",
				WaypointList = { {X=5, Y=68}, },
				RandomWaypoint = false, 
				LandingList = { {X=7, Y=70}, {X=7, Y=71}, {X=8, Y=72}, {X=8, Y=73}, {X=9, Y=75},}, -- Between Plymouth and Liverpool
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_GERMANY_UK] = {
				Name = "Germany to UK",
				CentralPlot = {X=21, Y=67},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 5, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=10, Y=67}, {X=16, Y=71}, }, -- Caen, Amsterdam
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=9, Y=70}, {X=10, Y=70}, {X=11, Y=70}, {X=12, Y=70},  }, -- East of Plymouth
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyReinforcementToUK, -- Must refer to a function, remove this line to use the default condition (true)
			},		
			[TROOPS_GERMANY_BACK_UK] = {
				Name = "Germany back to France from UK",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 8,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=11, Y=71}, {X=12, Y=72}, }, -- London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=11, Y=67}, {X=12, Y=67}, {X=13, Y=68}, }, -- near Caen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 2, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = GermanyDisengagefromUK, -- Must refer to a function, remove this line to use the default condition (true)
			},
	},

	[ITALY] = {	
			[TROOPS_ITALY_AFRICA] = {
				Name = "Italy to Africa",
				CentralPlot = {X=20, Y=57},
				MaxDistanceFromCentral = 10,
				ReserveUnits = 8, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=19, Y=57}, {X=21, Y=54}, {X=20, Y=55},  {X=20, Y=56}, }, -- near Rome, Naples
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=21, Y=50}, {X=18, Y=49},  }, -- Waypoints
				RandomWaypoint = true, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=19, Y=45}, {X=21, Y=45}, {X=27, Y=46}, {X=27, Y=47}, {X=28, Y=47}, {X=30, Y=46}, }, -- near Triploli, Benghazi
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 8, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = ItalyReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
	},

	[ENGLAND] = {	
			[TROOPS_UK_FRANCE] = {
				Name = "UK to France",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=11, Y=71}, {X=12, Y=72}, }, -- London
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil, -- waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=13, Y=69}, {X=13, Y=68}, {X=12, Y=67}, {X=11, Y=67},}, -- near Dunkerque
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = UKReinforcementToFrance, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_NORWAY] = {
				Name = "UK to Norway",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=10, Y=77}, {X=10, Y=78}, }, -- near Edinburgh
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=12, Y=81}, {X=17, Y=84}, {X=91, Y=83}, }, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=19, Y=82}, {X=19, Y=83}, {X=20, Y=83}, {X=21, Y=84}, {X=21, Y=85}, {X=22, Y=86}, }, -- Between Narvik and Bergen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 4, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToNorway, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_AFRICA] = {
				Name = "UK to Africa",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 4, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=7, Y=70}, {X=8, Y=70}, {X=9, Y=70},}, -- near Plymouth
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = { {X=3, Y=64}, {X=1, Y=56}, {X=4, Y=50}, {X=10, Y=50}, {X=15, Y=52}, {X=22, Y=49},  {X=32, Y=49}, }, 
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=34, Y=46}, {X=35, Y=46}, {X=36, Y=46}, {X=37, Y=46}, {X=39, Y=46}, {X=39, Y=47},  }, -- Between Alexandria and Haifa
				RandomLanding = false, -- false : sequential try in landing list
				MinUnits = 2,
				MaxUnits = 6, -- Maximum number of units on the route at the same time
				Priority = 5, 
				Condition = UKReinforcementToAfrica, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_UK_DDAY] = {
				Name = "UK goes D-Day !",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 7,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=7, Y=70}, {X=8, Y=70}, {X=9, Y=70}, {X=11, Y=71}, {X=12, Y=72}, }, -- near Plymouth, London
				RandomEmbark = true, -- true : random choice in spawn list
				WaypointList = nil, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = {{X=13, Y=69}, {X=13, Y=68}, {X=12, Y=67}, {X=11, Y=67}, {X=11, Y=68}, {X=9, Y=67}, {X=8, Y=67},}, -- Between Brest and Caen
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
				LandingList = { {X=12, Y=48}, {X=13, Y=49}, {X=14, Y=49},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_SICILYBRITISH] = {
				Name = "England to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=19, Y=49}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ITALYBRITISH] = {
				Name = "England to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=22, Y=53}, {X=22, Y=52}, {X=23, Y=53},},
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_OVERLORD_2] = {
				Name = "Overlord II",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = {{X=13, Y=69}, {X=13, Y=68}, {X=12, Y=67}, {X=11, Y=67}, {X=11, Y=68}, }, -- East of Caen
				RandomLanding = true, -- false : sequential try in landing list
			},

	},

	[FRANCE] = {	
			[TROOPS_FRANCE_AFRICA] = {
				Name = "France to Africa",
				CentralPlot = {X=12, Y=63},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 8, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=14, Y=59}, {X=15, Y=59}, {X=16, Y=59}, }, -- near Marseille
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=13, Y=49}, {X=14, Y=49}, {X=15, Y=49},  }, -- Between Alger and Tunis
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
				LandingList = { {X=14, Y=69}, {X=15, Y=70}, {X=15, Y=71}, },
				RandomLanding = true, -- false : sequential try in landing list
			},

	},

	[USSR] = {	
			[TROOPS_RUSSIA_WEST_1] = {
				Name = "East to West1",
				CentralPlot = {X=60, Y=75}, --Between Gorki and Novosibirsk
				MaxDistanceFromCentral = 20,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=42, Y=73},}, -- Gorki
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=33, Y=76}, {X=33, Y=72}, {X=36, Y=73}, {X=40, Y=72}, {X=36, Y=69}, }, -- Cities in North USSR
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 10, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = RussiaReinforcementToFront, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_RUSSIA_WEST_2] = {
				Name = "East to West2",
				CentralPlot = {X=88, Y=78}, --Jakutsk
				MaxDistanceFromCentral = 15,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=41, Y=67},}, -- Stalingrad
				RandomEmbark = false, -- true : random choice in spawn list
				WaypointList = nil,
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use sequential waypoint movement.
				LandingList = { {X=34, Y=66}, {X=37, Y=66}, {X=39, Y=62}, {X=45, Y=60}, {X=35, Y=61}, }, -- Cities in South USSR
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 1,
				MaxUnits = 10, -- Maximum number of units on the route at the same time
				Priority = 10, 
				Condition = RussiaReinforcementToFront, -- Must refer to a function, remove this line to use the default condition (true)
			},


	},

	[AMERICA] = {
			[TROOPS_LIBERATE_CASABLANCA] = {
				Name = "America to Africa 1",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=3, Y=44}, {X=3, Y=45}, {X=4, Y=47},{X=5, Y=48},  },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ORAN] = {
				Name = "America to Africa 2",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=8, Y=47}, {X=9, Y=47}, {X=11, Y=48}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_LIBERATE_ALGIERS] = {
				Name = "America to Africa 3",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=12, Y=48}, {X=13, Y=49}, {X=14, Y=49}, },
				RandomLanding = true, -- false : sequential try in landing list
			},	
			[TROOPS_LIBERATE_SICILY] = {
				Name = "America to Sicily",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=19, Y=50}, {X=20, Y=50}, },
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_LIBERATE_ITALY] = {
				Name = "America to Italy",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=20, Y=55}, {X=22, Y=54}, },
				RandomLanding = true, -- false : sequential try in landing list
			},		
			[TROOPS_OVERLORD_1] = {
				Name = "Overlord I",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=8, Y=65}, {X=9, Y=63}, {X=10, Y=62}, {X=9, Y=61}, },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_OVERLORD_3] = {
				Name = "Overlord III",
				WaypointList = nil, -- waypoints
				RandomWaypoint = true, 
				LandingList = { {X=8, Y=67}, {X=8, Y=66}, {X=8, Y=65}, {X=9, Y=67},  },
				RandomLanding = true, -- false : sequential try in landing list
			},
			[TROOPS_US_UK_DDAY_1] = {
				Name = "USA goes D-Day USA to UK",
				CentralPlot = {X=142, Y=60},
				MaxDistanceFromCentral = 15,
				ReserveUnits = 10, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=159, Y=66}, {X=159, Y=67}, {X=156, Y=61}, {X=156, Y=62}, {X=156, Y=63}, {X=157, Y=64},{X=157, Y=65}, {X=158, Y=65}, }, -- West coast
				RandomEmbark = true, -- true : random choice in spawn list
				WaypointList =  { {X=164, Y=63}, {X=174, Y=63}, {X=1, Y=63}, {X=3, Y=69}, }, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = { {X=6, Y=70}, {X=7, Y=70}, {X=7, Y=71}, {X=8, Y=72}, {X=7, Y=73}, {X=8, Y=73},  {X=9, Y=74}, {X=9, Y=75}, {X=9, Y=76}, {X=8, Y=77}, }, -- Between Plymouth and Edinburgh
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 15,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},
			[TROOPS_US_UK_DDAY_2] = {
				Name = "UK goes D-Day UK to France",
				CentralPlot = {X=10, Y=74},
				MaxDistanceFromCentral = 6,
				ReserveUnits = 0, -- minimum unit to keep in this area (ie : do not send those elsewhere)
				EmbarkList = { {X=7, Y=70}, {X=8, Y=70}, {X=9, Y=70}, {X=11, Y=71}, {X=12, Y=72}, }, -- near Plymouth, London
				RandomEmbark = true, -- true : random choice in spawn list
				WaypointList = nil, -- Waypoints
				RandomWaypoint = false, -- true : random choice in waypoint list (use 1 random waypoint), else use waypoint to waypoint movement.
				LandingList = {{X=13, Y=69}, {X=13, Y=68}, {X=12, Y=67}, {X=11, Y=67}, {X=11, Y=68}, {X=9, Y=67}, {X=8, Y=67},}, -- Between Brest and Caen
				RandomLanding = true, -- false : sequential try in landing list
				MinUnits = 16,
				MaxUnits = 20, -- Maximum number of units on the route at the same time
				Priority = 50, 
				Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (true)
			},


	},
}

----------------------------------------------------------------------------------------------------------------------------
-- Military Projects
----------------------------------------------------------------------------------------------------------------------------
-- add scenario specific restriction for projects
function PlayerEarth1936ProjectRestriction  (iPlayer, iProjectType)
	local bDebug = false
	local civID = GetCivIDFromPlayerID(iPlayer, false)	
		
	if civID == GERMANY and iProjectType == OPERATION_SEELOWE then
		if AreAtWar( iPlayer, GetPlayerIDFromCivID(USSR, false)) then
			Dprint("      - Operation Seelowe not available, Germany is at war with USSR...", bDebug)		
			return false 
		end
		local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Seelowe not available, Berlin is occupied...", bDebug)	
			return false 
		end
	end	
	
	if civID == GERMANY and iProjectType == OPERATION_WESERUBUNG then
		local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
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
		local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Berlin is occupied...", bDebug)	
			return false -- Paratroopers launch from Berlin...
		end
		local Cologne = GetPlot(19, 70):GetPlotCity()	-- Cologne
		if Cologne:IsOccupied() then
			Dprint("      - Operation Fall Gelb not available, Cologne is occupied...", bDebug)	
			return false -- 2nd army launch from Cologne...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_SONNENBLUME then
		local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
		if Berlin:IsOccupied() then
			Dprint("      - Operation Sonnenblume not available, Berlin is occupied...", bDebug)	
			return false 			-- Paratroopers launch from Berlin...
		end
	end
	if civID == GERMANY and iProjectType == OPERATION_TWENTYFIVE then
		local Munich = GetPlot(21, 64):GetPlotCity()	-- München
		if Munich:IsOccupied() then
			Dprint("      - Operation Twenty Five not available, München is occupied...", bDebug)	
			return false 			-- Operation starts from München...
		end
	end
	return true
end
--GameEvents.PlayerCanCreate.Add(PlayerEarth1936ProjectRestriction)

function IsGermanyReadyForWeserubung()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(NORWAY, true)) then
		Dprint("      - Operation Weserübung not ready, Germany is not at war with Norway...", bDebug)
		return false
	end
	local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Weserübung not ready, Berlin is occupied...", bDebug)	
		return false -- Paratroopers launch from Berlin...
	end
	return true
end

function IsGermanyReadyForSonnenblume()
	local bDebug = false
	local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Berlin is occupied...", bDebug)				
		return false -- Paratroopers launch from Berlin...
	end
	local Rome = GetPlot(19, 57):GetPlotCity()	-- Rome
	if Rome:IsOccupied() then
		Dprint("      - Operation Sonnenblume not ready, Rome is occupied...", bDebug)		
		return false 
	end
	local city = GetPlot(29, 47):GetPlotCity()	-- Tobruk
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
	local Munich = GetPlot(21, 64):GetPlotCity()	-- München
		if Munich:IsOccupied() then
			Dprint("      - Operation TwentyFive not ready, München is occupied...", bDebug)
			return false 			-- Operation starts from München...
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

	local enemyForces = GetEnemyLandForceInArea( pUSSR, 31, 61, 49, 93 )
	local allyForces = GetSameSideLandForceInArea( pUSSR, 31, 61, 49, 93 )

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
	local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
	if Berlin:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Berlin is occupied...", bDebug)		
		return false -- Paratroopers launch from Berlin...
	end
	local Cologne = GetPlot(19, 70):GetPlotCity()	-- Cologne
	if Cologne:IsOccupied() then
		Dprint("      - Operation Fall Gelb not ready, Cologne is occupied...", bDebug)			
		return false --  armies launch from Cologne...
	end
	return true
end

function IsGermanyReadyForSeelowe()
	local bDebug = false
	if AreAtWar( GetPlayerIDFromCivID(GERMANY, false), GetPlayerIDFromCivID(USSR, false)) then
		Dprint("      - Operation Seelowe not ready, Germany is at war with USSR......", bDebug)
		return false
	end
	local Berlin = GetPlot(23, 70):GetPlotCity()	-- Berlin
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


function IsJapanAtWarWithChina()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(JAPAN, false), GetPlayerIDFromCivID(CHINA, false)) then
		Dprint("      - Japan is not at war with China...", bDebug)
		return false
	end
	return true
end

function IsJapanAtWarWithAllies()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(JAPAN, false), GetPlayerIDFromCivID(NETHERLANDS, true)) then
		Dprint("      - Japan is not at war with the Netherlands...", bDebug)
		return false
	end
	if not AreAtWar( GetPlayerIDFromCivID(JAPAN, false), GetPlayerIDFromCivID(AUSTRALIA, true)) then
		Dprint("      - Japan is not at war with Australia...", bDebug)
		return false
	end
	if not AreAtWar( GetPlayerIDFromCivID(JAPAN, false), GetPlayerIDFromCivID(ENGLAND, false)) then
		Dprint("      - Japan is not at war with the UK...", bDebug)
		return false
	end
	if not AreAtWar( GetPlayerIDFromCivID(JAPAN, false), GetPlayerIDFromCivID(AMERICA, false)) then
		Dprint("      - Japan is not at war with America...", bDebug)
		return false
	end
	return true
end

function IsAlliesAtWarWithVichy()
	local bDebug = false
	if not AreAtWar( GetPlayerIDFromCivID(AMERICA, false), GetPlayerIDFromCivID(VICHY, true)) then
		Dprint("      - America is not at war with Vichy...", bDebug)
		return false
	end
		if not AreAtWar( GetPlayerIDFromCivID(ENGLAND, false), GetPlayerIDFromCivID(VICHY, true)) then
		Dprint("      - UK is not at war with Vichy...", bDebug)
		return false
	end
	return true
end


g_Military_Project = {
	------------------------------------------------------------------------------------
	[JAPAN] = {
	------------------------------------------------------------------------------------
		[OPERATION_CHINA] =  { -- projectID as index !
			Name = "Invasion of China",
			OrderOfBattle = {
				{	Name = "Nothern Chinese Invasion Force", X = 97, Y = 58, Domain = "City", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY, },
					UnitsXP = {		9,				9,			9,			  9,	           }, 
					InitialObjective = "88,56", -- Shanghai 
					LaunchType = "ParaDrop",
					LaunchX = 87, -- Destination plot
					LaunchY = 56,
					LaunchImprecision = 4, -- landing area
				},
				{	Name = "Middle Chinese Invasion Force", X = 97, Y = 58, Domain = "City", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY,  ARTILLERY,	ARTILLERY,},
					UnitsXP = {		9,				9,			9,			9,       }, 
					InitialObjective = "86,50", -- Fuzhou 
					LaunchType = "ParaDrop",					
					LaunchX = 86, -- Destination plot
					LaunchY = 51,
					LaunchImprecision = 4, -- landing area
				},
				{	Name = "Southern Chinese Invasion Force", X = 97, Y = 58, Domain = "City", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY,	ARTILLERY},
					UnitsXP = {		9,				9,	           9,             9,}, 
					InitialObjective = "80,46", -- Nanning
					LaunchType = "ParaDrop",					
					LaunchX = 80, -- Destination plot
					LaunchY = 45,
					LaunchImprecision = 4, -- landing area
				},
				{	Name = "Secondary Mid. Chinese Invasion Force", X = 87, Y = 59, Domain = "Land", CivID = JAPAN, 
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY,	},
					UnitsXP = {		9,				9,			9,			9,				}, 
					InitialObjective = "85,57", -- Nanjing 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_CHINA_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Northern Attack Force", X = 97, Y = 58, Domain = "City", CivID = JAPAN,    -- spawn at Tokio
					Group = {		JP_PARATROOPER,	JP_PARATROOPER, JP_PARATROOPER,	},
					UnitsXP = {		9,				9,				9,			}, 
					InitialObjective = "82,64", -- Peking
					LaunchType = "ParaDrop",
					LaunchX = 81, -- Destination plot
					LaunchY = 63,
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Secondary Southern Chinese Invasion Force", X = 86, Y = 46, Domain = "Land", CivID = JAPAN, 
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY, ARTILLERY,	},
					UnitsXP = {		9,				9,			9,			9,				}, 
					InitialObjective = "82,47", -- Guangzhou
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_CHINA_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Korean Air Invasion Force 1", X = 89, Y = 64, Domain = "Air", CivID = JAPAN, -- spawn at Pyöngyang
					Group = {JP_KI21}, 
					UnitsXP = {9},  
				},
				{	Name = "Korean Air Invasion Force 2", X = 90, Y = 55, Domain = "Air", CivID = JAPAN, -- spawn at Nagasaki
					Group = {JP_KI21}, 
					UnitsXP = {9},  
				},
				{	Name = "Korean Air Invasion Force 3", X = 89, Y = 61, Domain = "Air", CivID = JAPAN, -- spawn at Seoul
					Group = {JP_AICHI}, 
					UnitsXP = {9},  
				},
				{	Name = "Middle Attack Force", X = 97, Y = 58, Domain = "City", CivID = JAPAN,    -- spawn at Tokio
					Group = {		JP_PARATROOPER,	JP_PARATROOPER, },
					UnitsXP = {		9,				9,			}, 
					InitialObjective = "84,60", -- Zibo
					LaunchType = "ParaDrop",
					LaunchX = 85, -- Destination plot
					LaunchY = 60,
					LaunchImprecision = 2, -- landing area
				},
			},			
			Condition = IsJapanAtWarWithChina,
		},

		[OPERATION_PACIFIC] =  { -- projectID as index !
			Name = "Invasion of Indonesia and the Philippines",
			OrderOfBattle = {
				{	Name = "Guam Invasion Force", X = 97, Y = 45, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,             9,}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_GUAM, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Wake Invasion Force", X = 105, Y = 52, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,             9,}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_WAKE, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Guadalcanal Invasion Force", X = 109, Y = 28, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,             9,}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_GUADALCANAL, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Tarawa Invasion Force", X = 112, Y = 34, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY, JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,             9,}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_TARAWA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Rabaul Invasion Force", X = 103, Y = 31, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,  ARTILLERY,},
					UnitsXP = {		9,		9,}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_RABAUL, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Jayapara Invasion Force", X = 95, Y = 33, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY,  ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_JAYAPARA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Philippines Invasion Force", X = 90, Y = 44, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY,  ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_PHILIPPINES, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Singapore Invasion Force", X = 79, Y = 35, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_SINGAPORE, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Medan Invasion Force", X = 82, Y = 35, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_MEDAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Jakarta Invasion Force", X = 82, Y = 38, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_JAKARTA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Borneo Invasion Force", X = 93, Y = 34, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_BORNEO, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Manado Invasion Force", X = 94, Y = 37, Domain = "Land", CivID = JAPAN,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_MANADO, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Makassar Invasion Force", X = 97, Y = 34, Domain = "Land", CivID = JAPAN, AI = true,
					Group = {		JP_INFANTRY,	JP_INFANTRY, ARTILLERY,},
					UnitsXP = {		9,				9,				9,		}, 
					InitialObjective = nil, 
					LaunchType = "Amphibious",
					RouteID = TROOPS_INVADE_MAKASSAR, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
			},			
			Condition = IsJapanAtWarWithAllies,
		},
	},	
	------------------------------------------------------------------------------------
	[GERMANY] = {
	------------------------------------------------------------------------------------
		[OPERATION_WESERUBUNG] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_WESERUBUNG",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 23, Y = 70, Domain = "City", CivID = GERMANY, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, GE_PARATROOPER,	},
					UnitsXP = {		9,				9,	              9,}, 
					InitialObjective = "26,90", -- Narvik
					LaunchType = "ParaDrop",
					LaunchX = 26, -- Destination plot
					LaunchY = 91, -- (26,91) = Near Narvik
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Para Group 2", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Berlin
					Group = {		GE_PARATROOPER,	},
					UnitsXP = {		9,			}, 
					InitialObjective = "22,80", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 21, -- Destination plot
					LaunchY = 80, -- (21,80) = West of Oslo
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Para Group 3", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Berlin
					Group = {		GE_PARATROOPER,},
					UnitsXP = {		9,				}, 
					InitialObjective = "22,80", -- Oslo
					LaunchType = "ParaDrop",
					LaunchX = 22, -- Destination plot
					LaunchY = 81, -- (22,81) = North of Oslo
					LaunchImprecision = 1, -- landing area
				},
			},			
			Condition = IsGermanyReadyForWeserubung, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_SEELOWE] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SEELOWE",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER, },
					UnitsXP = {		15,				15,		  }, 
					InitialObjective =  "10,72", -- Birmingham 
					LaunchType = "ParaDrop",
					LaunchX = 10, -- Destination plot
					LaunchY = 73, -- (10,73) = Near Birmingham
					LaunchImprecision = 1, -- landing area
				}, 
				{	Name = "Amphibious Army 1", X = 18, Y = 74, Domain = "Land", CivID = GERMANY, AI = true,-- spawn west of Hamburg
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_III,	GE_PANZER_II},
					UnitsXP = {		15,				15,				 15,             15,             15,    }, 
					InitialObjective = "11,71", -- London 
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_KIEL, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Amphibious Army 2", X = 6, Y = 65, Domain = "Land", CivID = GERMANY, AI = true,-- spawn west of Brest
					Group = {		GE_INFANTRY,	GE_INFANTRY,	ARTILLERY,	GE_PANZER_IV,	GE_PANZER_II},
					UnitsXP = {		15,				15,				 15,          15,            15,     }, 
					InitialObjective = "8,70", -- Plymouth  
					LaunchType = "Amphibious",
					RouteID = TROOPS_GERMANY_SEELOWE_ST_NAZAIRE, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
			},			
			Condition = IsGermanyReadyForSeelowe, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_FALLGELB] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_FALLGELB",
			OrderOfBattle = {
				{	Name = "Para Group 1", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER	},
					UnitsXP = {		9,				9,}, 
					InitialObjective = "16,71", -- Amsterdam
					LaunchType = "ParaDrop",
					LaunchX = 15, -- Destination plot
					LaunchY = 71, -- (15,71) = Near Amsterdam
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Para Group 2", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true,-- spawn at Berlin
					Group = {		GE_PARATROOPER,	GE_PARATROOPER,	},
					UnitsXP = {		9,				9,				}, 
					InitialObjective = "14,69", -- Brussel
					LaunchType = "ParaDrop",
					LaunchX = 14, -- Destination plot
					LaunchY = 69, -- (14,69) = Near Brussel
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Army 1", X = 19, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		GE_INFANTRY,	GE_PANZER_IV,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		9,						9,				9,				9,			9,	}, 
					InitialObjective = "16,71", -- Amsterdam 
				},
				{	Name = "Support 1", X = 19, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "16,71", -- Amsterdam 
				},
				{	Name = "Army 2", X = 19, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		GE_INFANTRY,	GE_PANZER_III,	GE_PANZER_II,	GE_SS_INFANTRY,	GE_MECH_INFANTRY},
					UnitsXP = {		9,				9,				9,				9,				9,			}, 
					InitialObjective = "14,69", -- Brussel 
				},
				{	Name = "Support 2", X = 19, Y = 70, Domain = "City", CivID = GERMANY, AI = true, -- spawn at Cologne
					Group = {		ARTILLERY,	ARTILLERY,	AT_GUN,	AT_GUN,	GE_STUG_III},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "14,69", -- Brussel  
				},
			},
			Condition = IsGermanyReadyForFallGelb, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_SONNENBLUME] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_SONNENBLUME",
			OrderOfBattle = {
				{	Name = "Afrika Korps I", X = 23, Y = 70, Domain = "City", CivID = GERMANY,
					Group = {		GE_INFANTRY, GE_INFANTRY,	GE_PANZER_III,	GE_INFANTRY,	GE_PANZER_III,	},
					UnitsXP = {		9,	         9,				9,		         9,	    		 9,	}, 
					InitialObjective = "29,47", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 28, -- Destination plot
					LaunchY = 46, -- (28,46) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Afrika Korps II", X = 23, Y = 70, Domain = "City", CivID = GERMANY, AI = true,
					Group = {		GE_PANZER_IV,	ARTILLERY,	AT_GUN,	},
					UnitsXP = {		9,	             9,		     9,		}, 
					InitialObjective = "29,47", -- Tobruk
					LaunchType = "ParaDrop",
					LaunchX = 28, -- Destination plot
					LaunchY = 46, -- (28,46) = Near Tobruk
					LaunchImprecision = 2, -- landing area
				},
			},		
			Condition = IsGermanyReadyForSonnenblume, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_TWENTYFIVE] =  { -- projectID as index !
			Name = "Operation 25",
			OrderOfBattle = {
				{	Name = "Belgrade Assault Force", X = 21, Y = 64, Domain = "City", CivID = GERMANY,  AI = true,
					Group = {		GE_INFANTRY,	GE_PANZER_III, GE_PANZER_III, GE_PANZER_IV,	},
					UnitsXP = {		9,				9,				9,				9, }, 
					InitialObjective = "26,59", -- Belgrade
				},
				{	Name = "Zagreb Assault Force", X = 21, Y = 64, Domain = "City", CivID = GERMANY, AI = true,
					Group = {		GE_INFANTRY,	GE_INFANTRY, GE_PANZER_II,	},
					UnitsXP = {		9,				9,				9,	 }, 
					InitialObjective = "23,61", -- Zagreb
				},
			},			
			Condition = IsGermanyReadyForTwentyFive, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_MARITA] =  { -- projectID as index !
			Name = "Operation Marita",
			OrderOfBattle = {
				{	Name = "Thessaloniki Assault Force", X = 23, Y = 70, Domain = "Land", CivID = GERMANY,  AI = true,
					Group = {		GE_SS_INFANTRY, GE_PANZER_III,	},
					UnitsXP = {		25,				25,		}, 
					InitialObjective = "28,57", -- Thessaloniki
					LaunchType = "ParaDrop",
					LaunchX = 28, -- Destination plot
					LaunchY = 56,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Athens Assault Force", X = 23, Y = 70, Domain = "Land", CivID = GERMANY, AI = true,
					Group = {	GE_SS_INFANTRY, GE_PANZER_III, GE_PANZER_IV,	},
					UnitsXP = {		15,				15,				10,		 }, 
					InitialObjective = "29,54", -- Athens
					LaunchType = "ParaDrop",
					LaunchX = 28, -- Destination plot
					LaunchY = 53,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "Crete Assault Force", X = 23, Y = 70, Domain = "Land", CivID = GERMANY, AI = true,
					Group = {		GE_PARATROOPER,	},
					UnitsXP = {		15,				}, 
					InitialObjective = "30,50", -- Iraklion
					LaunchType = "ParaDrop",
					LaunchX = 29, -- Destination plot
					LaunchY = 50,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = IsGermanyAtWarWithGreece, -- Must refer to a function, remove this line to use the default condition (always true)
		},

	},
	------------------------------------------------------------------------------------
	[USSR] = {
	------------------------------------------------------------------------------------
		[OPERATION_MOTHERLANDCALL] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_MOTHERLANDCALL",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 44, Y = 73, Domain = "Land", CivID = USSR, -- spawn near Gorki
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,	     9,     9,     9,          9,          9,}, 
					InitialObjective = "23,70", -- Berlin
				},
				{	Name = "Support Group 1", X = 44, Y = 73, Domain = "Land", CivID = USSR, -- spawn near Gorki
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "23,70", -- Berlin
				},
				{	Name = "Army Group 2", X = 43, Y = 67, Domain = "Land", CivID = USSR, AI = true, -- spawn near Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_INFANTRY, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,       9,    9,     9,           9,          9,	}, 
					InitialObjective = "23,70", -- Berlin
				},
				{	Name = "Support Group 2", X = 43, Y = 67, Domain = "Land", CivID = USSR, AI = true, -- spawn near Stalingrad
					Group = {		RU_ZIS30,	RU_ZIS30, RU_AT_GUN, RU_AT_GUN, RU_ARTILLERY, RU_ARTILLERY, RU_ARTILLERY,	},
					InitialObjective = "23,70", -- Berlin
				},
			},			
			Condition = IsUSSRLosingWar, -- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_URANUS] =  { -- projectID as index !
			Name = "TXT_KEY_OPERATION_URANUS",
			OrderOfBattle = {
				{	Name = "Army Group 1", X = 41, Y = 70, Domain = "Land", CivID = USSR, -- spawn north of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_KV1, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,       9,    9,     9,           9,          9,	}, 
					InitialObjective = "41,67", -- Stalingrad
				},
				{	Name = "Support Group 1", X = 41, Y = 70, Domain = "Land", CivID = USSR, AI = true,-- spawn north of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "41,67", -- Stalingrad
				},
				{	Name = "Army Group 2", X = 42, Y = 64, Domain = "Land", CivID = USSR,  -- spawn south of Stalingrad
					Group = {		RU_NAVAL_INFANTRY,	RU_T34, RU_T34, RU_T34, RU_ISU122, RU_INFANTRY, RU_INFANTRY,	},
					UnitsXP = {		9,					9,       9,    9,     9,           9,          9,	}, 
					InitialObjective = "41,67", -- Stalingrad
				},
				{	Name = "Support Group 2", X = 42, Y = 64, Domain = "Land", CivID = USSR, AI = true, -- spawn south of Stalingrad
					Group = {		RU_SU26,	RU_ZIS30, RU_ZIS30, RU_ARTILLERY, RU_ARTILLERY, RU_BM13, RU_BM13,	},
					InitialObjective = "41,67", -- Stalingrad
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
	------------------------------------------------------------------------------------
	[ENGLAND] = {
	------------------------------------------------------------------------------------
		
		[OPERATION_HUSKY] =  { -- projectID as index !
			Name = "Operation Husky",
			OrderOfBattle = {
				{	Name = "Western Task Force (USA)", X = 17, Y = 51, Domain = "Land", CivID = AMERICA,
					Group = {	US_MARINES, ARTILLERY},
					UnitsXP = {		9,			9}, 
					InitialObjective = "20,49", -- Catania
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force (British)", X = 22, Y = 48, Domain = "Land", CivID = ENGLAND,
					Group = {	UK_INFANTRY, ARTILLERY},
					UnitsXP = {		9,	          9, }, 
					InitialObjective = "20,49", -- Catania
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_SICILYBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Paradrop Force (UK)", X = 11, Y = 71, Domain = "City", CivID = ENGLAND,
					Group = {		UK_PARATROOPER, },
					UnitsXP = {		9,	 }, 
					InitialObjective = "20,49", -- Catania
					LaunchType = "ParaDrop",
					LaunchX = 20, -- Destination plot
					LaunchY = 50,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = NorthAfricaLiberated,-- Must refer to a function, remove this line to use the default condition (always true)
		},

		[OPERATION_AVALANCHE] =  { -- projectID as index !
			Name = "Operation Avalanche",
			OrderOfBattle = {
				{	Name = "Northern Task Force (USA)", X = 19, Y = 53, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_MARINES, US_M7, US_M12},
					UnitsXP = {		9,				9,			9,       9}, 
					InitialObjective = "21,54", -- Napoli
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ITALY, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Southern Task Force (British)", X = 23, Y = 50, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, UK_MOBILE_BISHOP},
					UnitsXP = {		9,	             9,  }, 
					InitialObjective = "21,54", -- Napoli
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
				{	Name = "Western Task Force", X = 2, Y = 48, Domain = "Land", CivID = AMERICA,
					Group = {	US_INFANTRY, US_INFANTRY,	US_M24CHAFFEE},
					UnitsXP = {			9,			9,             9}, 
					InitialObjective = "4,46", -- Casablanca 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group", X = 1, Y = 51, Domain = "Land", CivID = AMERICA, AI = true,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective = "4,46", -- Casablanca
					LaunchType = "Amphibious",					 
					RouteID = TROOPS_LIBERATE_CASABLANCA, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force", X = 9, Y = 50, Domain = "Land", CivID = AMERICA,
					Group = {	US_MARINES, US_SHERMAN,	},
					UnitsXP = {		9,				9}, 
					InitialObjective =  "10,47", -- Oran 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group", X = 10, Y = 51, Domain = "Land", CivID = AMERICA, AI = true,
					Group = {		ARTILLERY, AT_GUN,	},
					InitialObjective =  "10,47", -- Oran
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ORAN, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Eastern Task Force (American)", X = 12, Y = 52, Domain = "Land", CivID = AMERICA,
					Group = {		US_INFANTRY, US_SHERMAN },
					UnitsXP = {		9,				9    }, 
					InitialObjective = "12,49", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERS, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force (British)", X = 14, Y = 52, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY, },
					UnitsXP = {		9,	}, 
					InitialObjective = "12,49", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group", X = 15, Y = 53, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {		ARTILLERY,	},
					InitialObjective = "12,49", -- Algiers 
					LaunchType = "Amphibious",
					RouteID = TROOPS_LIBERATE_ALGIERSBRITISH, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},		
				{	Name = "Paradrop Force", X = 11, Y = 71, Domain = "City", CivID = AMERICA,
					Group = {US_PARATROOPER,},
					UnitsXP = {		9,	 }, 
					InitialObjective = "10,47", -- Oran
					LaunchType = "ParaDrop",
					LaunchX = 10, -- Destination plot
					LaunchY = 45,
					LaunchImprecision = 1, -- landing area
				},
				{	Name = "French Resistance", X = 11, Y = 71, Domain = "City", CivID = FRANCE,
					Group = {		FR_LEGION, },
					UnitsXP = {		9,	 }, 
					InitialObjective = "12,49", -- Algiers
					LaunchType = "ParaDrop",
					LaunchX = 13, -- Destination plot
					LaunchY = 46,
					LaunchImprecision = 1, -- landing area
				},

			},			
			Condition = NorthAfricaInvaded, -- Must refer to a function, remove this line to use the default condition (always true)
		},
		
		[OPERATION_OVERLORD] =  { -- projectID as index !
			Name = "Operation Overlord",
			OrderOfBattle = {
				{	Name = "Western Task Force I", X = 5, Y = 64, Domain = "Land", CivID = AMERICA,
					Group = {	US_INFANTRY, US_INFANTRY,	US_INFANTRY, US_MARINES, US_MARINES, },
					UnitsXP = {			9,			9,             9,              9,        9,  }, 
					InitialObjective = "11,62", -- Bordeaux 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group I", X = 2, Y = 64, Domain = "Land", CivID = AMERICA, AI = true, 
					Group = {	ARTILLERY, ARTILLERY,  AT_GUN, AT_GUN, US_M10	},
					UnitsXP = {		9,			9,        9,        9,      9   }, 
					InitialObjective = "11,62", -- Bordeaux 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Western Task Force II", X = 1, Y = 68, Domain = "Land", CivID = AMERICA,
					Group = {	US_SHERMAN_IIA, US_SHERMAN_III,	US_SHERMAN_III, US_M24CHAFFEE, US_MECH_INFANTRY, },
					UnitsXP = {		      9,				9,			9,             9,              9,     }, 
					InitialObjective = "11,62", -- Bordeaux 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Western Group II", X = 1, Y = 71, Domain = "Land", CivID = AMERICA, AI = true, 
					Group = {		US_M18, US_M12, US_M16A1, US_M16A1, US_SEXTON	},
					UnitsXP = {		9,		9,		9,        9,        9,       }, 
					InitialObjective = "11,62", -- Bordeaux 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_1, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Western Paradrop Force", X = 11, Y = 71, Domain = "City", CivID = AMERICA,
					Group = {US_PARATROOPER, US_PARATROOPER,  US_SPECIAL_FORCES},
					UnitsXP = {		9,				9,		       29,            }, 
					InitialObjective = "11,62", -- Bordeaux 
					LaunchType = "ParaDrop",
					LaunchX = 11, -- Destination plot
					LaunchY = 61,
					LaunchImprecision = 2, -- landing area
				},
				{	Name = "Central Task Force I", X = 7, Y = 69, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_INFANTRY,	UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, UK_INFANTRY, },
					UnitsXP = {		9,				9,			9,             9,              9,       }, 
					InitialObjective = "10,67", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group I", X = 5, Y = 70, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {	ARTILLERY, ARTILLERY, AT_GUN, AT_GUN, UK_ACHILLES	},
					UnitsXP = {		9,			9,			9,          9,    9     }, 
					InitialObjective = "10,67", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Central Task Force II", X = 6, Y = 72, Domain = "Land", CivID = ENGLAND,
					Group = {		UK_M4_FIREFLY, UK_CHURCHILL,	UK_A24, UK_A24, UK_MECH_INFANTRY, },
					UnitsXP = {		      9,				9,			9,        9,            9 }, 
					InitialObjective = "10,67", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Central Group II", X = 7, Y = 74, Domain = "Land", CivID = ENGLAND, AI = true,
					Group = {UK_MOBILE_BISHOP, UK_MOBILE_AA_VICKERS, UK_MOBILE_BISHOP, UK_MOBILE_BISHOP, UK_MOBILE_AA_GUN	},
					UnitsXP = {		9,		             9,		        9,                        9,                 9}, 
					InitialObjective = "10,67", -- Caen 
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_2, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},				
				{	Name = "Central Paradrop Force", X = 11, Y = 71, Domain = "City", CivID = ENGLAND,
					Group = {UK_PARATROOPER, UK_SPECIAL_FORCES},
					UnitsXP = {		9,					29,     }, 
					InitialObjective = "10,67", -- Caen 
					LaunchType = "ParaDrop",
					LaunchX = 11, -- Destination plot
					LaunchY = 65,
					LaunchImprecision = 2, -- landing area
				},				
				{	Name = "Eastern Task Force I", X = 13, Y = 71, Domain = "Land", CivID = FRANCE,
					Group = {		FR_INFANTRY, FR_INFANTRY, },
					UnitsXP = {		9,				9  }, 
					InitialObjective = "15,69", -- Brussel
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Support Eastern Group I", X = 13, Y = 73, Domain = "Land", CivID = FRANCE, AI = true,
					Group = {		ARTILLERY,  FR_SAU40	},
					UnitsXP = {		9,				9   }, 
					InitialObjective = "15,69", -- Brussel
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "Eastern Task Force II", X = 15, Y = 73, Domain = "Land", CivID = AMERICA,
					Group = {		CA_INFANTRY, CA_INFANTRY },
					UnitsXP = {		    9,	   9	 }, 
					InitialObjective = "15,69", -- Brussel
					LaunchType = "Amphibious",
					RouteID = TROOPS_OVERLORD_3, -- must define a troops route for amphibious operation in g_TroopsRoutes !
				},
				{	Name = "French Resistance", X = 15, Y = 66, Domain = "Land", CivID = FRANCE,  -- spawn near Reims
					Group = {		FR_PARTISAN,	FR_PARTISAN,},
					InitialObjective = "15,67", -- Metz
				},

			},			
			Condition = ReadyForOverlord, -- Must refer to a function, remove this line to use the default condition (always true)
		},
	},		
}

function InitializeEarth1936Projects()

	local bDebug = false

	Dprint("-------------------------------------", bDebug)
	Dprint("Initializing specific projects for Earth 1936-1945 scenario...",bDebug)

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
	if date.Number >= 19390101 and PROJECT_P40 and not IsProjectDone(PROJECT_P40) then
		local projectInfo = GameInfo.Projects[PROJECT_P40]
		MarkProjectDone(PROJECT_P40, AMERICA)
		Events.GameplayAlertMessage(Locale.ConvertTextKey(projectInfo.Description) .." has been completed !")
	end

	if date.Number >= 19410101 and PROJECT_B25 and not IsProjectDone(PROJECT_B25) then
		local projectInfo = GameInfo.Projects[PROJECT_B25]
		MarkProjectDone(PROJECT_B25, AMERICA)
		Events.GameplayAlertMessage(Locale.ConvertTextKey(projectInfo.Description) .." has been completed !")
	end
end

--------------------------------------------------------------
-- UI functions
--------------------------------------------------------------
include("InstanceManager")

-- Tooltip init
function DoInitEarth1936UI()
	ContextPtr:LookUpControl("/InGame/TopPanel/REDScore"):SetToolTipCallback( ToolTipEarth1936Score )
	UpdateEarth1936ScoreString()
end

local tipControlTable = {};
TTManager:GetTypeControlTable( "TooltipTypeTopPanel", tipControlTable );

-- Score Tooltip for AmericaEuro1936
function ToolTipEarth1936Score( control )

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

function UpdateEarth1936ScoreString()

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

	-- Place the Shlisselburg Fortress in USSR
	SetCitadelAt(33, 77)

	-- Place the Mannerheim Line in Finland
	SetBunkerAt(33, 78)
	SetBunkerAt(35, 78)
	
	-- Place the fortifications for the Maginot Line
	if(PreGame.GetGameOption("MaginotLine") ~= nil) and (PreGame.GetGameOption("MaginotLine") >  0) then
		SetCitadelAt(18, 66)
		SetBunkerAt(18, 64)
		SetFortAt(17, 66)
		SetFortAt(16, 67)
	end

	-- Place the fortifications for the Siegfried Line
	if(PreGame.GetGameOption("Westwall") ~= nil) and (PreGame.GetGameOption("Westwall") >  0) then
		SetBunkerAt(20, 64)
		SetBunkerAt(19, 66)
		SetBunkerAt(18, 68)
		SetBunkerAt(18, 70)
		SetBunkerAt(18, 72)
	end
end

function SeasonScenario()
	local plot = Map.GetPlot(38, 84);
	local ter = plot:GetTerrainType();
	local feat = plot:GetFeatureType();
	Dprint("Terraintype 38,84 = ".. ter)
	Dprint("Featuretype 38,84 = old ".. feat)
	plot:SetFeatureType(0)
	local feat = plot:GetFeatureType();
	Dprint("Featuretype 38,84 = new ".. feat)

	
	local plot = Map.GetPlot(37, 78);
	local ter = plot:GetTerrainType();
	local feat = plot:GetFeatureType();
	Dprint("Terraintype 37,78 = ".. ter)
	Dprint("Featuretype 37,78 = ".. feat)

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
		if WINTERTIME == 0 then			-- Set spring
			for x = 0, 179, 1 do
				for y = 57, 93, 1 do	--Wintertime region
					local plotKey = x..","..y
					local plot = GetPlot(x,y)
					local map = LoadTerritoryMap()
					for i, data in pairs ( map ) do
						if (i == plotKey) then
							local ter = data.TerrainType
							plot:SetTerrainType(ter)
						end
					end
					local feat = plot:GetFeatureType();
					if feat == 0 then
						plot:SetFeatureType(-1)
					end
				end
			end
		elseif WINTERTIME == 1 then
			for x = 0, 40, 1 do				-- west of Murmansk
				for y = 88, 93, 1 do
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
					elseif rand <= 95 and ter == 6 and feat == -1 then -- Sea to Ice
						plot:SetFeatureType(0)
					end
				end
			end	
			for x = 41, 179, 1 do				-- east of Murmansk
				for y = 88, 93, 1 do
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
			for x = 0, 25, 1 do				-- west of Stockholm
				for y = 83, 87, 1 do
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
			for x = 26, 179, 1 do				-- east of Stockholm
				for y = 83, 87, 1 do
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
			for x = 0, 25, 1 do					-- west of Stockholm
				for y = 78, 82, 1 do
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
			for x = 26, 179, 1 do				-- east of Stockholm
				for y = 78, 82, 1 do
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
			for x = 0, 25, 1 do				-- west of Stockholm
				for y = 70, 77, 1 do
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
			for x = 26, 179, 1 do				-- east of Stockholm
				for y = 70, 77, 1 do
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
			for x = 0, 20, 1 do				-- west of Hamburg
				for y = 64, 69, 1 do
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
			for x = 21, 179, 1 do				-- east of Hamburg
				for y = 64, 69, 1 do
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
			for x = 0, 20, 1 do				-- west of Hamburg
				for y = 61, 63, 1 do
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
			for x = 21, 179, 1 do				-- east of Hamburg
				for y = 61, 63, 1 do
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
			for x = 24, 179, 1 do				-- east of Zagreb
				for y = 57, 60, 1 do
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
		SpawnList = { {X=9, Y=66}, {X=10, Y=65}, {X=13, Y=67}, {X=16, Y=66}, {X=16, Y=67}, {X=17, Y=66}, {X=18, Y=66}, {X=13, Y=64}, {X=13, Y=63},  {X=11, Y=61}, },
		RandomSpawn = true, -- true : random choice in spawn list
		CivID = FRANCE,
		Frequency = 50, -- probability (in percent) of partisan spawning at each turn
		Condition = NorthFranceInvaded, -- Must refer to a function, remove this line to use the default condition (true)
		},
	}
