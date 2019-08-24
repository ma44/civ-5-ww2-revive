--------------------------------------------------------------
--------------------------------------------------------------
-- Lua RedUnitFunctions
-- Author: Gedemon
-- DateCreated: 7/15/2011 1:28:32 AM
--------------------------------------------------------------
--------------------------------------------------------------

print("Loading Red Units Functions...")
print("-------------------------------------")

--------------------------------------------------------------
-- units capture tiles
--------------------------------------------------------------

function UnitCaptureTile(playerID, UnitID, x, y, norepeat)
	local bDebug = false
	local plot = Map.GetPlot(x,y)
	if (plot == nil) then
		return
	end
	
	if ( plot:IsCity() or plot:IsWater() ) then
		return
	end

	-- check here if an unit can't capture a tile and return
	local player = Players[ playerID ]
	local unit = player:GetUnitByID(UnitID)
	local unitClassID = unit:GetUnitClassType()
	if not ( CanCaptureTile(unitClassID) ) then
		return
	end

	local plotKey = GetPlotKey ( plot )
	local ownerID = plot:GetOwner()
	if ( norepeat == 0 ) then
		for plot in PlotAreaSpiralIterator(plot, 1, sector, anticlock, DIRECTION_OUTWARDS, false) do
			UnitCaptureTile(playerID, UnitID, x, y, 1)
		end
	end

	-- If the unit is moving on another player territory...
	if (playerID ~= ownerID and ownerID ~= -1) then
		Dprint("-------------------------------------", bDebug)
		Dprint("Unit moving on tile ("..x..","..y..") is in another civ (id="..ownerID..") territory", bDebug)

		local player2 = Players[ ownerID ]		
		local team = Teams[ player:GetTeam() ]
		local team2 = Teams[ player2:GetTeam() ]

		-- If we are at war with the other player :
		if team:IsAtWar( player2:GetTeam() ) then
			Dprint(" - Unit owner (id="..playerID..") and tile owner (id="..ownerID..") are at war", bDebug)
			firstOwner = GetPlotFirstOwner( plotKey )	
			local bPillageDefense = false
					
			if (firstOwner == -1) then
				firstOwner = ownerID -- assume that current owner is also the first owner when there wasn't one on map initialization
			end

			-- liberating our territory
			if (firstOwner == playerID) then
				Dprint(" - Unit is liberating it's own territory", bDebug)
				g_FixedPlots[plotKey] = true
				plot:SetOwner(playerID, -1 )
				--bPillageDefense = true

			-- capturing current owner territory			
			elseif ( ownerID == firstOwner) then
				Dprint(" - Unit is capturing territory", bDebug)				
				g_FixedPlots[plotKey] = true
				plot:SetOwner(playerID, -1 )
				bPillageDefense = true

			else
				-- don't free old owner territory if we're at war !
				local player3 = Players[ firstOwner ]				
				if team:IsAtWar( player3:GetTeam() ) then
					Dprint(" - Unit is capturing territory, old owner civ (id=".. firstOwner ..") is also at war with unit owner", bDebug)
					g_FixedPlots[plotKey] = true
					plot:SetOwner(playerID, -1 )
					bPillageDefense = true

				elseif ( not player3:IsAlive() ) then
					Dprint(" - Unit is capturing territory, old owner civ (id=".. firstOwner ..") is dead", bDebug)
					g_FixedPlots[plotKey] = true
					plot:SetOwner(playerID, -1 )
					bPillageDefense = true

				else
				-- liberating old owner territory
					Dprint(" - Unit is liberating this territory belonging to another civ (id=".. firstOwner ..")", bDebug)
					g_FixedPlots[plotKey] = true
					plot:SetOwner(firstOwner, -1 )
					--bPillageDefense = true

					if player3:IsMinorCiv() and not player:IsMinorCiv() then
						player3:ChangeMinorCivFriendshipWithMajor( playerID, LIBERATE_MINOR_TERRITORY_BONUS ) -- give diplo bonus for liberating minor territory
					end
				end
			end
			if bPillageDefense then -- defensive improvement are damaged if we're capturing territory
				local improvementType = plot:GetImprovementType()
				if improvementType ~= -1 and (not plot:IsImprovementPillaged()) and GameInfo.Improvements[improvementType].DefenseModifier > 0 then
					plot:SetImprovementPillaged( true )
					SetPillageDamage (plot:GetX(), plot:GetY(), true, false, UnitID, playerID)
				end
			end
		end
	end

end
-- GameEvents.UnitSetXY.Add( UnitCaptureTile )
-- add to Events after map initialization (or re-loading) in RedEuro1940.Lua or other scenario Lua file


--------------------------------------------------------------
-- Units renaming
-- to do : make it scenario dependant ? allow defined strings ?
--------------------------------------------------------------
function UnitName(playerID, unitID, num) -- num = number of unit of this type
	
	local bDebug = false
	local player = Players[ playerID ]
	local unit = player:GetUnitByID( unitID )

	--Dprint("-------------------------------------", bDebug)
	Dprint ("Renaming new unit...", bDebug)
	local unitType = unit:GetUnitType()
	local unitClassType = unit:GetUnitClassType()
	local numType = g_Unit_Classes[unitClassType].NumType or -1
	local str = nil
	Dprint ("numType: "..numType, bDebug)
	--------------------------------------------- France ---------------------------------------------
	if ( GetCivIDFromPlayerID (playerID) == FRANCE ) then		
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1ere "
			else			
				str = num .. "eme "
			end
			str = str .. "Division d'infanterie"
			unit:SetName(str)
		end	
		if ( numType == CLASS_INFANTRY_2 ) then
			if (num == 1) then
				str = "1er "
			else			
				str = num .. "eme "
			end
			str = str .. "Regiment etranger d'infanterie"
			unit:SetName(str)
		end
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1er "
			else			
				str = num .. "eme "
			end
			str = str .. "Regiment de Chasseurs Parachutistes"
			unit:SetName(str)
		end
		if ( numType == CLASS_SPECIAL_FORCES ) then
			if (num == 1) then
				str = "1ere "
			else			
				str = num .. "eme "
			end
			str = str .. "Compagnie d'Infanterie de l'Air"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then
			if (num == 1) then
				str = "1ere "
			else			
				str = num .. "eme "
			end
			str = str .. "Division d'Infantrie Motorisee"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1ere "
			else			
				str = num .. "eme "
			end
			str = str .. "Division blindee"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1ere "
			else			
				str = num .. "eme "
			end
			str = str .. "Regiment de defense aerienne"
			unit:SetName(str)
		end
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1er "
			else			
				str = num .. "eme "
			end
			str = str .. "Regiment d'artillerie"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1er "
			else			
				str = num .. "eme "
			end
			str = str .. "Escadron de chasse"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1er "
			else			
				str = num .. "eme "
			end
			str = str .. "Escadron de bombardement"
			unit:SetName(str)
		end
		if ( unitType == FR_BATTLESHIP ) then
			local name = { "Dunkerque", "Strasbourg"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == FR_GALISSONIERE ) then
			local name = { "La Galissonniere", "Montcalm", "Georges Leygues", "Jean de Vienne", "Marseillaise", "Gloire"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == FR_BATTLESHIP_2 ) then
			local name = { "Richelieu", "Jean Bart", "Clemenceau", "Gascogne"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == FR_SUBMARINE ) then
			local name = { "Acheron", "Pegase", "Promethee", "Fresnel", "Protee", "Acteon", "Redoutable", "Vengeur", "Poincare", "Pascal", "Archimede", "Pasteur",
			"Poncelet", "Argo", "Achille", "Monge", "Persee", "Ajax", "Phenix"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == FR_FANTASQUE ) then
			local name = { "Chacal", "Jaguar", "Leopard", "Lynx", "Panthere", "Tigre", "Fantasque", "Malin", "Terrible", "Indomptable", "Audacieux", "Triomphant",
			"Mogador", "Volta", "Cassard", "Chevalier Paul", "Kersaint", "Maill� Breze", "Tartu", "Vauquelin", "Aigle", "Vautour", "Albatros", "Gerfaut", "Milan", "Epervier",
			"Bison", "Guepard", "Lion", "Valmy", "Verdun", "Vauban"}	
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == FR_CARRIER ) then
			local name = { "Joffre"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end	--------------------------------------------- Germany ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == GERMANY ) then
 		
		if ( numType == CLASS_INFANTRY ) then
			str = num .. ". Infanterie-Division"
			unit:SetName(str)
		end
		if ( numType == CLASS_INFANTRY_2 ) then
			str = num .. ". SS Waffen-Grenadier-Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			str = num .. ". Fallschirm-Jaeger-Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_SPECIAL_FORCES ) then
			local name = { "Brandenburg", "Muenstereifel", "Niederrhein"}
			if (num <= # name) then
				str = name[num]
				str = "Fallschirm-Jaeger-Bataillon '".. name[num] .."'"
				unit:SetName(str)
			else
				str = num .. ". Fallschirm-Jaeger-Bataillon"
			end
		end	
		if IsArmorClass( numType ) then
			str = num .. ". Panzer-Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			str = num .. ". Luftabwehr-Regiment"
			unit:SetName(str)
		end
		if ( numType == CLASS_ARTILLERY ) then
			str = num .. ". Artillerie-Regiment"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then
			str = num .. ". Panzergrenadier-Division"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			str = "Jagdgeschwader " .. num
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			str = "Kampfgeschwader " .. num
			unit:SetName(str)
		end
		if ( unitType == GE_BATTLESHIP ) then
			local name = { "Scharnhorst", "Gneisenau"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_BATTLESHIP_2 ) then
			local name = { "Bismarck", "Tirpitz"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_LEIPZIG ) then
			local name = { "Leipzig", "Nuernberg"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_DEUTSCHLAND ) then
			local name = { "Luetzow", "Admiral Scheer", "Admiral Graf Spee"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_SUBMARINE ) then
			local name = { "U 27", "U 28", "U 29", "U 30", "U 31", "U 32", "U 33", "U 34", "U 35", "U 36", "U 45", "U 46", "U 47", "U 48", "U 49", "U 50", "U 51", "U 52", "U 53", "U 54", "U 55",
			"U 69", "U 70", "U 71", "U 72", "U 73", "U 74", "U 75", "U 76", "U 77", "U 78", "U 79", "U 80", "U 81", "U 82", "U 83", "U 84", "U 85", "U 86", "U 87", "U 88", "U 89", "U 90", "U 91",
			"U 92", "U 93", "U 94", "U 95", "U 96", "U 97", "U 98", "U 99", "U 100", "U 101", "U 102", "U 132", "U 133", "U 134", "U 135", "U 136", "U 201", "U 202", "U 203", "U 204", "U 205", 
			"U 205", "U 206", "U 207", "U 208", "U 209", "U 210", "U 211", "U 212"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_SUBMARINE_2 ) then
			local name = { "U 2321", "U 2322", "U 2333", "U 2334" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_DESTROYER_2 ) then
			local name = { "Z 23", "Z 24", "Z 25", "Z 26", "Z 27", "Z 28", "Z 29", "Z 30", "Z 31", "Z 32", "Z 33", "Z 34", "Z 35", 
			"Z 36", "Z 37", "Z 38", "Z 39", "Z 40", "Z 41", "Z 42", "Z 43", "Z 44", "Z 45"  }	
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_DESTROYER ) then
			local name = { "Z 1 Leberecht Maass", "Z 2 Georg Thiele", "Z 3 Max Schultz", "Z 4 Richard Beitzen", "Z 5 Paul Jacobi", "Z 6 Theodor Riedel", "Z 7 Hermann Schoemann", "Z 8 Bruno Heinemann",
			 "Z 9 Wolfgang Zenker", "Z 10 Hans Lody", "Z 11 Bernd von Arnim", "Z 12 Erich Giese", "Z 13 Erich Koellner", "Z 14 Friedrich Ihn", "Z 15 Erich Steinbrinck", "Z 16 Friedrich Eckoldt" }	
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GE_CARRIER ) then
			local name = { "Graf Zeppelin"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- Italy ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == ITALY ) then
 		
		if ( unitType == IT_INFANTRY ) then
			str = num .. "a Divisione fanteria"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			str = num .. "a Parachute Battalion"
			unit:SetName(str)
		end		
		if IsArmorClass( numType ) then
			str = num .. "a Divisione corazzata"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			str = num .. "a Reggimento Difesa aerea"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			str = num .. "a Reggimento Artiglieria"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			str = num .. "a Squadriglia di caccia"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			str = num .. "a Squadriglia di bombardieri"
			unit:SetName(str)
		end
		if ( unitType == IT_BATTLESHIP ) then
			local name = { "Vittorio Veneto", "Littorio", "Roma", "Impero"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == IT_ZARA ) then
			local name = { "Zara", "Fiume", "Pola", "Gorizia"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == IT_DI_CAVOUR ) then
			local name = { "Conte Di Cavour", "Giulio Cesare", "Leonardo Da Vinci"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == IT_SUBMARINE ) then
			local name = { "Goffredo Mameli", "Pier Capponi", "Giovanni da Procida", "Tito Speri","Lorenzo Marcello", "Giacomo Nani", "Sebastiano Venier", "Lazzaro Mocenigo", 
			"Andrea Provana", "Agostino Barbarigo", "Angelo Emo", "Francesco Morosini", "Enrico Dandolo", "Alfredo Cappellini", "Emilio Fa di Bruno"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == IT_SOLDATI ) then
			local name = { "Alpino", "Artigliere", "Ascari", "Aviere","Bersagliere", "Camicia Nera", "Carabiniere", "Corazziere", "Fuciliere", "Geniere", "Granatiere", "Lanciere", 
			"Bombardiere", "Carrista", "Corsaro", "Legionario", "Mitragliere", "Squadrista", "Velite", "Bombardiere", "Carrista", "Corsaro" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == IT_CARRIER ) then
			local name = { "Aquila"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- USSR ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == USSR ) then
 		
		if ( unitType == RU_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Pekhota Deleniye"
			unit:SetName(str)
		end	
		if ( unitType == RU_NAVAL_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Morskaya Pekhota Deleniye"
			unit:SetName(str)
		end			
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Wosduschno-Dessantnyje Woiska"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Mekhanizirovannaya Pekhota"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Bak Deleniye"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "PVO"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Artilleriya Polk"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Istrebitel Deleniye"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Bombardirovshchik Deleniye"
			unit:SetName(str)
		end
		if ( unitType == RU_BATTLESHIP ) then
			local name = { "Sovetsky Soyuz", "Sovetskaya Ukraina", "Sovetskaya Rossiya", "Sovetskaya Belorussiya"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == RU_GANGUT ) then
			local name = { "Gangut", "Sewastopol", "Petropawlowsk", "Poltawa"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == RU_KIROV ) then
			local name = { "Kirov", "Voroshilov", "Maxim Gorky", "Molotov", "Kaganovich", "Kalinin"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == RU_SUBMARINE ) then
			local name = { "SHK 101", "SHK 102", "SHK 103", "SHK 104", "SHK 105", "SHK 106", "SHK 107", "SHK 108", "SHK 109", "SHK 110", "SHK 111", "SHK 112", "SHK 113", "SHK 114", "SHK 115", "SHK 116",
			"SHK 117", "SHK 118", "SHK 119", "SHK 120", "SHK 121", "SHK 122", "SHK 123", "SHK 124", "SHK 125", "SHK 126", "SHK 127", "SHK 128", "SHK 129", "SHK 130", "SHK 131", "SHK 132", "SHK 133",
			"SHK 134", "SHK 135", "SHK 136", "SHK 137", "SHK 138", "SHK 139", "SHK 201", "SHK 202", "SHK 203", "SHK 204", "SHK 205", "SHK 206", "SHK 207", "SHK 208", "SHK 209", "SHK 210", "SHK 211",
			"SHK 212", "SHK 213", "SHK 214", "SHK 215", "SHK 216", "SHK 301", "SHK 302", "SHK 303", "SHK 304", "SHK 305", "SHK 306", "SHK 307", "SHK 308", "SHK 309", "SHK 310", "SHK 311", "SHK 312",
			"SHK 313", "SHK 314", "SHK 315", "SHK 316", "SHK 317", "SHK 318"}
		
			Dprint ("num: "..num, bDebug)
		
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == RU_GNEVNY ) then
			local name = { "Bodry", "Bystry", "Bezuprechny", "Bditelny", "Boiky", "Bezposhchadny","Gnevny", "Gordy", "Gromky", "Grozny", "Gremyashchy", "Grozyashtchi", "Sokrushitelny", "Steregushchy", 
			"Stremitelny", "Rezvyy", "Ryanyy", "Rastoropnyy", "Redkiy", "Razyashchyy", "Reshitelnyy", "Retivyy", "Revnostnyy", "Razyaryonnyy", "Razumnyy", "Rekordnyy", "Rezkiy" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end

	--------------------------------------------- Greece ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == GREECE ) then		
		if ( unitType == GR_INFANTRY ) then
			str = num .. "i Merarchia Pezikou"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			str = num .. "i Ieros Lochos"
			unit:SetName(str)
		end	
		if IsArmorClass( numType ) then
			str = num .. "i Merarchia Tethorakismenon"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			str = num .. "i Merarchia Aeramyna"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			str = num .. "i Merarchia Pirobolikou"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			str = num .. "i Omada Maxitikon"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			str = num .. "i Omada Bombardistikon"
			unit:SetName(str)
		end
		if ( unitType == GR_PISA ) then
			local name = { "Georgios Averof"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GR_SUBMARINE ) then
			local name = {"Y-1 Katsonis", "Y-2 Papanikolis", "Y-3 Proteus", "Y-4 Nereus", "Y-5 Triton)", "Y-6 Glavkos"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == GR_GEORGIOS ) then
			local name = { "Vasilefs Georgios", "Vasilissa Olga", "Thyella", "Sfendoni", "Niki", "Aspis", "Aetos", "Ierax", "Leon", "Panthir", "Psara", "Hydra", "Spetsai",
			" Kountouriotis"}	
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- U.K. ---------------------------------------------

	elseif (GetCivIDFromPlayerID (playerID) == ENGLAND) then	
		
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Infantry Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Airborn Division"
			unit:SetName(str)
		end
		if ( numType == CLASS_SPECIAL_FORCES ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "SAS Regiment"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then

			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Mechanized Infantry Division"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Armored Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Air Defense Regiment"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Artillery Regiment"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Fighter Squadron"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Bomber Squadron"
			unit:SetName(str)
		end
		
		if ( unitType == UK_BATTLESHIP ) then
			local name = { "HMS Hood", "HMS Rodney"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_BATTLESHIP_2 ) then
			local name = { "HMS King George V", "HMS Prince Of Wales", "HMS Duke Of York", "HMS Anson", "HMS Howe"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_LEANDER ) then
			local name = {	"HMS Leander", "HMS Orion", "HMS Neptune", "HMS Ajax", "HMS Achilles",
							"HMS Amphion", "HMS Apollo", "HMS Phaeton"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_ELIZABETH ) then
			local name = { "HMS Queen Elizabeth", "HMS Warspite", "HMS Valiant", "HMS Barham", "HMS Malaya"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_SUBMARINE ) then
			local name = { "HMS Triton", "HMS Thetis", "HMS Trident", "HMS Tribune", "HMS Triumph", "HMS Tarpon", "HMS Taku", "HMS Thistle", "HMS Truant", "HMS Triad", "HMS Tigris", "HMS Tuna",
			"HMS Tetrarch", "HMS Talisman", "HMS Torbay", "HMS Thunderbolt", "HMS Thrasher", "HMS Tempest", "HMS Traveller", "HMS Thorn", "HMS Trusty", "HMS Turbulent", "HMS Trooper", "HMS Trespasser",
			"HMS Thule", "HMS Tudor", "HMS Taurus", "HMS Tireless", "HMS Token", "HMS Tactician", "HMS Truculent", "HMS Templar", "HMS Tradewind", "HMS Tally-Ho", "HMS Trenchant", "HMS Tantalus", 
			"HMS Tantivy", "HMS Telemachus", "HMS Talent", "HMS Terrapin", "HMS Totem", "HMS Thorough", "HMS Truncheon", "HMS Tiptoe", "HMS Trump", 
			"HMS Taciturn", "HMS Tapir", "HMS Thor", "HMS Tiara", "HMS Turpin", "HMS Tarn", "HMS Thermopylae", "HMS Teredo"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_SUBMARINE_2 ) then
			local name = { "HMS Undine", "HMS Unity", "HMS Ursula", "HMS Umpire", "HMS Una", "HMS Unbeaten", "HMS Undaunted", "HMS Union", "HMS Unique", "HMS Upholder", "HMS Upright"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_TRIBA ) then
			local name = {"HMS Afridi", "HMS Cossack", "HMS Ashanti", "HMS Eskimo", "HMS Gurkha", "HMS Mohawk", "HMS Nubian", "HMS Sikh", "HMS Somali", "HMS Zulu", "HMS Tartar", "HMS Punjabi", 
			"HMS Matabele", "HMS Mashona", "HMS Bedouin", "HMS Atherstone", "HMS Berkeley", "HMS Cattistock", "HMS Cleveland", "HMS Eglinton", "HMS Exmoor", "HMS Fernie", "HMS Garth", "HMS Hambledon", 
			"HMS Holderness", "HMS Cotswold", "HMS Cottesmore", "HMS Mendip", "HMS Meynell", "HMS Pytchley", "HMS Quantock", "HMS Quorn", "HMS Southdown", "HMS Tynedale", "HMS Whaddon" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_CARRIER ) then
			local name = { "HMS Ark Royal"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == UK_CARRIER_2 ) then
			local name = { "HMS Illustrious", "HMS Formidable", "HMS Victorious"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- USA ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == AMERICA ) then		
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Infantry Division"
			unit:SetName(str)
		end	
		
		if ( numType == CLASS_INFANTRY_2 ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Marine Division"
			unit:SetName(str)
		end	

		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Airborn Division"
			unit:SetName(str)
		end
		if ( numType == CLASS_SPECIAL_FORCES ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Ranger Regiment"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then

			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Mechanized Infantry Division"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Armored Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Air Defense Regiment"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Artillery Regiment"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Fighter Group USAAF"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Bombardment Group USAAF"
			unit:SetName(str)
		end
		if ( unitType == US_BALTIMORE ) then
			local name = { "USS Baltimore", "USS Boston", "USS Canberra", "USS Quincy", "USS Pittsburgh", "USS Saint Paul", "USS Columbus", 
				       "USS Helena", "USS Bremerton", "USS Fall River", "USS Macon", "USS Toledo", "USS Los Angeles", "USS Chicago" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_BATTLESHIP ) then
			local name = { "USS Indiana", "USS South Dakota", "USS Alabama", "USS Massachusetts"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_BATTLESHIP_2 ) then
			local name = { "USS Iowa", "USS New Jersey", "USS Wisconsin", "USS Missouri", "USS Illinois", "USS Kentucky"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_PENNSYLVANIA ) then
			local name = { "USS Pennsylvania", "USS Arizona"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_CARRIER ) then
			local name = { "USS Yorktown", "USS Enterprise", "USS Hornet"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_CARRIER_2 ) then
			local name = { "USS Essex", "USS Bon Homme Richard", "USS Intrepid", "USS Kearsarge"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_SUBMARINE ) then
			local name = { "USS Gato", "USS Greening", "USS Grouper", "USS Growler", "USS Grunion", "USS Guardfish", "USS Albacore", "USS Amberjack", "USS Barb", "USS Blackfish", "USS Bluefish", 
			"USS Bonefish", "USS Cod", "USS Cero", "USS Corvina", "USS Darter", "USS Drum", "USS Flying Fish", "USS Finback", "USS Haddock", "USS Halibut", "USS Herring", "USS Kingfish", "USS Shad",
			"USS Silversides", "USS Trigger", "USS Wahoo", "USS Whale", "USS Angler", "USS Bashaw", "USS Bluegill", "USS Bream", "USS Cabalia", "USS Cobia", "USS Croaker", "USS Dace", "USS Dorado", 
			"USS Flasher", "USS Flier", "USS Flounder", "USS Gabilan", "USS Gunnel", "USS Gurnard", "USS Haddo", "USS Hake", "USS Harder", "USS Hoe", "USS Jack", "USS Lapon", "USS Mingo", 
			"USS Muskallunge", "USS Paddle", "USS Pargo", "USS Peto", "USS Poggy", "USS Pompon", "USS Puffer", "USS Rasher", "USS Raton", "USS Ray", "USS Redfin"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_BENSON ) then
			local name = {"USS Benson", "USS Mayo", "USS Madison", "USS Lansdale", "USS Hilary P. Jones", "USS Charles F. Hughes", "USS Laffey", "USS Woodworth", "USS Farenholt", "USS Bailey", "USS Bancroft", "USS Barton", 
			"USS Boyle", "USS Champlin", "USS Meade", "USS Murphy", "USS Parker", "USS Caldwell", "USS Coghlan", "USS Frazier", "USS Gansevoort", "USS Gillespie", "USS Hobby", "USS Kalk", 
			"USS Kendrick", "USS Laub", "USS MacKenzie", "USS McLanahan", "USS Nields", "USS Ordronaux" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == US_FLETCHER ) then
			local name = {"USS Fletcher", "USS Radford", "USS Jenkins", "USS La Vallette", "USS Nicholas", "USS O'Bannon", "USS Chevalier", "USS Saufley", "USS Waller", "USS Strong", "USS Taylor", "USS De Haven", 
			"USS Bache", "USS Beale", "USS Guest", "USS Bennett", "USS Fullam", "USS Hudson", "USS Hutchins", "USS Pringle", "USS Stanly", "USS Stevens", "USS Halford", "USS Leutze", 
			"USS Watson", "USS Philip", "USS Renshaw", "USS Ringgold", "USS Schroeder", "USS Sigsbee", "USS Conway", "USS Cony", "USS Converse", "USS Eaton", "USS Foote", "USS Spence", "USS Terry"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end

	--------------------------------------------- JAPAN ---------------------------------------------
	elseif ( GetCivIDFromPlayerID (playerID) == JAPAN ) then		
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Infantry Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Airborn Division"
			unit:SetName(str)
		end
		if ( numType == CLASS_SPECIAL_FORCES ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Ninja Regiment"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Armored Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Air Defense Regiment"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Artillery Regiment"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Fighter Group"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Imperial Bombardment Group"
			unit:SetName(str)
		end
		if ( unitType == JP_KAGERO ) then
			local name = { "Kagero", "Shiranui", "Kuroshio", "Oyashio", "Hayashio", "Natsushio", "Hatsukaze", 
				       "Yukikaze", "Amatsukaze", "Tokitsukaze", "Urakaze", "Isokaze", "Hamakaze", "Tanikaze", 
					   "Nowaki", "Arashi", "Hagikaze", "Maikaze", "Akigumo"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_BATTLESHIP ) then
			local name = { "Kongo", "Hiei", "Kirishima", "Haruna"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_BATTLESHIP_2 ) then
			local name = { "Yamato", "Musashi", "Shinano", "Kii"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_CARRIER ) then
			local name = { "Kaga", "Akagi"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_CARRIER_2 ) then
			local name = { "Shokaku", "Zuikaku"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_MYOKO ) then
			local name = { "Myoko", "Nachi", "Haguro", "Ashigara"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		
		if ( unitType == JP_SUBMARINE ) then
			local name = { "I-15", "I-16", "I-17", "I-18", "I-19", "I-20", "I-21", "I-22", "I-23", "I-24", "I-25", 
			"I-26", "I-27", "I-28", "I-29", "I-30", "I-31", "I-32", "I-33", "I-34", "I-35", "I-36", "I-37", "I-38", "I-39"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_SUBMARINE_2 ) then
			local name = {"I-400", "I-401", "I-402"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
		if ( unitType == JP_TAKAO ) then
			local name = {"Takao", "Atago", "Chokai", "Maya"}
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- CHINA ---------------------------------------------
	
	elseif ( GetCivIDFromPlayerID (playerID) == CHINA ) then		
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Infantry Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Airborn Division"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Armored Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Air Defense Regiment"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Artillery Regiment"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Fighter Group"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Kuomintang Bombardment Group"
			unit:SetName(str)
		end
		if ( unitType == DESTROYER ) then
			local name = {"Ning Hai", "Ping Hai", "Chao Ho", "Hai Yung", "Ying Swei", "Yat Sen" }
			if (num <= # name) then
				str = name[num]
				unit:SetName(str)
			end
		end
	--------------------------------------------- other ---------------------------------------------

	else
		if ( numType == CLASS_INFANTRY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Infantry Division"
			unit:SetName(str)
		end	
		if ( numType == CLASS_PARATROOPER ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Airborn Division"
			unit:SetName(str)
		end
		if ( numType == CLASS_SPECIAL_FORCES ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. " Special Forces Regiment"
			unit:SetName(str)
		end
		if ( numType == CLASS_MECHANIZED_INFANTRY ) then

			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Mechanized Infantry Division"
			unit:SetName(str)
		end
		if IsArmorClass( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Armored Division"
			unit:SetName(str)
		end
		if IsAAGun( numType ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Air Defense Regiment"
			unit:SetName(str)
		end	
		if ( numType == CLASS_ARTILLERY ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Artillery Regiment"
			unit:SetName(str)
		end
		if IsFighterClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Fighter Squadron"
			unit:SetName(str)
		end
		if IsBomberClass( numType  ) then
			if (num == 1) then
				str = "1st "
			elseif (num == 2) then			
				str = "2nd "
			elseif (num == 3) then			
				str = "3rd "
			else
				str = num .. "th "
			end
			str = str .. "Bomber Squadron"
			unit:SetName(str)
		end
	end
	if str then
		Dprint ("New name : " .. str, bDebug)
		return str
	else
		Dprint ("No name found", bDebug)
		return unit:GetName()
	end
end


--------------------------------------------------------------
-- Units management
--------------------------------------------------------------
function PathBlocked(pPlot, pPlayer)
	if ( pPlot == nil or pPlayer == nil) then
		Dprint ("WARNING : CanPass() called with a nil argument")
		return true
	end

	local ownerID = pPlot:GetOwner()
	local playerID = pPlayer:GetID()

	if ( ownerID == playerID or ownerID == -1 ) then
		return false
	end

	local pOwner = Players [ ownerID ]
	if ( pPlayer:GetTeam() == pOwner:GetTeam() or pOwner:IsAllies(playerID) or pOwner:IsFriends(playerID) ) then
		return false
	end

	--local team1 = Teams [ pPlayer:GetTeam() ]
	local plotTeam = Teams [ pOwner:GetTeam() ]
	if plotTeam:IsAllowsOpenBordersToTeam( pPlayer:GetTeam() ) then
		return false
	end

	return true -- return true if the path is blocked...
end

function NoNationalPath(pPlot, pPlayer)
	if ( pPlot == nil or pPlayer == nil) then
		Dprint ("WARNING : CanPass() called with a nil argument")
		return true
	end

	local ownerID = pPlot:GetOwner()
	local playerID = pPlayer:GetID()

	if ( ownerID == playerID or ownerID == -1 ) then
		return false
	end
	return true -- return true if the path is blocked...
end

function CanGetSupply (playerID, unitID, bShow )

	local bDebug = false
	local player = Players[ playerID ]
	local unit = player:GetUnitByID( unitID )
	local unitPlot = unit:GetPlot()
	local unitType = unit:GetUnitType()
	local unitArea = unitPlot:GetArea()
	local bHighlight = bShow or false

	if ( GameInfo.Units[unitType].Domain == "DOMAIN_SEA" or GameInfo.Units[unitType].Domain == "DOMAIN_AIR" or unit:IsEmbarked() ) then
		-- for now don't check naval supply lines
		return true
	end

	-- first check closest own cities
	Dprint (" - Search supply line for " .. unit:GetName() .. " (unitID =".. unit:GetID() ..", playerID =".. playerID ..")", bDebug)
	local closeCity = GetCloseCity ( playerID, unitPlot )
	if closeCity then
		local cityPlot = closeCity:Plot()
		-- first check the area, no need to calculate land path if not in the same land... 
		if ( cityPlot:GetArea() == unitArea and isPlotConnected(player, unitPlot, cityPlot, "Land", bHighlight, nil , PathBlocked) ) then
			Dprint ("   - Found path with close city (".. closeCity:GetName() ..")", bDebug )
			return true
		end
	end
	
	-- then all own cities
	Dprint ("   - No path with close city, check all cities", bDebug )
	for city in player:Cities() do
		local cityPlot = city:Plot()
		if ( cityPlot:GetArea() == unitArea and isPlotConnected(player, unitPlot, cityPlot, "Land", bHighlight, nil ,PathBlocked) ) then
			Dprint ("   - Found path with city (".. city:GetName() ..")", bDebug )
			return true
		end	
	end

	-- try logistic entry plots if they are defined
	if g_LogisticEntryPlot then
		for plotKey, entryData in pairs(g_LogisticEntryPlot) do
			if entryData.Active then
				local bCanUse = true
				if entryData.Civs then
					bCanUse = false
					for i, civID in pairs(entryData.Civs) do
						if civID == GetCivIDFromPlayerID (playerID) then
							bCanUse = true
						end
					end
				end
				if bCanUse then
					local entryPlot = GetPlotFromKey ( plotKey )
					if ( entryPlot and entryPlot:GetArea() == unitArea and isPlotConnected(player, unitPlot, entryPlot, "Land", bHighlight, nil ,PathBlocked) ) then
						Dprint ("   - Found path with entry plot at (".. plotKey ..")", bDebug )
						return true
					end
				end
			end
		end
	end
	
	if ( not player:IsMinorCiv() ) then -- crash fix: can't test minors for friends / ally ?
		-- now check friend / ally cities
		for player_num = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
			if player_num ~= playerID then
				local other = Players [ player_num ]
				if other:IsAlive() then -- dead can't provide reinforcements
					--local unitTeam = Teams [ player:GetTeam() ]
					local bAllied = ( player:GetTeam() == other:GetTeam() or other:IsAllies(playerID) or other:IsFriends(playerID) )
					if ( bAllied ) then
						Dprint ("   - No path with close city, check ally (" .. other:GetName() .. ") cities", bDebug)
						-- first check closest allied city
						local closeCity = GetCloseCity ( player_num, unitPlot )
						if closeCity then -- a civ may still be alived but without cities...
							local cityPlot = closeCity:Plot()
							-- check the area first, no need to calculate land path if not in the same land... 
							if ( cityPlot:GetArea() == unitArea and isPlotConnected(player, unitPlot, cityPlot, "Land", bHighlight, nil , PathBlocked) ) then
								Dprint ("   - Found path with close city (".. closeCity:GetName() ..")", bDebug )
								return true
							end
						end
	
						-- then all his cities
						Dprint ("   - No path with close city, check all " .. other:GetName() .. " cities", bDebug )
						for city in other:Cities() do
							local cityPlot = city:Plot()
							if ( cityPlot:GetArea() == unitArea and isPlotConnected(player, unitPlot, cityPlot, "Land", bHighlight, nil ,PathBlocked) ) then
								Dprint ("   - Found path with city (".. city:GetName() ..")", bDebug )
								return true
							end	
						end				
					end
				end
			end
		end
	end
end

-- check if units can embark from plot
function CanEmbarkFrom(plot, unit)
	local bDebug = false
	local player = Players[unit:GetOwner()]
	local bSea = false
	local bHarbor = false
	Dprint("   - Checking adjacent plots for embark promotion", bDebug)
	local adjacentPlots = GetAdjacentPlots(plot, true) -- list of all adjacent plots + center plot
	for i, adjPlot in pairs(adjacentPlots) do
		if adjPlot:IsWater() and not adjPlot:IsLake() then
			Dprint("   - Found water !", bDebug)
			bSea = true
		elseif adjPlot:IsCity() then
			Dprint("   - Found City !", bDebug)
			local city = adjPlot:GetPlotCity()
			if (city:GetNumBuilding(HARBOR) > 0) and AreSameSide( unit:GetOwner(), city:GetOwner()) then -- and not city:IsBlockaded() 
				Dprint("   - With a friendly harbor !", bDebug) --not blockaded-- not tested
				bHarbor = true
			end			
		end
	end
	if bSea and bHarbor then
		return true
	else
		return false
	end 
end


--------------------------------------------------------------
-- Units Initialization
--------------------------------------------------------------

function RegisterNewUnit(playerID, unit, bNoAutoNaming) -- unit is object, not ID

	local bDebug = false

	if NO_AUTO_NAMING then
		bNoAutoNaming = NO_AUTO_NAMING
	end
	local unitClass = unit:GetUnitClassType()
	local unitType = unit:GetUnitType()
	local value = g_Unit_Classes[unitClass]
	local unitID = unit:GetID()

	if ( value == nil ) then
		Dprint("WARNING : unit (id="..unit:GetID()..", class='".. GameInfo.Units[unitType].Class .."', type='".. GameInfo.Units[unitType].Type .."') is not defined in g_Unit_Classes table", bDebug )
		value = {Moral = 100, NumType = -1, MaxHP = 100}
	end	

	if (value.NumType == nil) then
		Dprint("WARNING : NumType for type='".. GameInfo.Units[unitType].Type .."' class=".. GameInfo.Units[unitType].Class .." (".. unitClass ..") is not defined in g_Unit_Classes table", bDebug )
		-- some units did not have valid NumType but everything else is okay, initialize with unitType as hardcoded fix :-/
		-- todo: find out why this is needed
		value.NumType = unitType
	end

	-- temp, waiting to see if variable maxHP could be implemented
	local maxHP = MAX_HP -- maxHP from Defines here
	--[[
	local maxHP = value.MaxHP
	local initialDamage = MAX_HP - value.MaxHP -- set custom maxHP by substracting the value.MaxHP (requested MaxHit point for this unit) to the global MAX_HP than applying the result as damage (or none if the requested max HP is >= global max HP)
	if initialDamage > 0 then
		unit:SetDamage (initialDamage)
	end 
	--]]

	local unitKey = GetUnitKey(unit)

	MapModData.RED.UnitData[unitKey] = { 
		UniqueID = unitID.."-"..playerID.."-"..os.clock(), -- for linked statistics
		UnitID = unitID,
		BuilderID = playerID,
		Damage = 0,
		OwnerID = playerID,
		TurnCreated = Game.GetGameTurn(),
		NumType = value.NumType,
		Type = GameInfo.Units[unitType].Type,
		TypeID = unitType,
		Moral = value.Moral,
		Alive = true,
		TotalXP = unit:GetExperience(),
		CombatXP = 0,
		MaxHP = value.MaxHP,
		OrderType = nil,
		OrderReference = nil,
		OrderObjective = nil,
		TransportType = nil,
		TransportReference = nil,
		TotalControl = false, -- when set to true, R.E.D. scripts can totally control the unit, even if it belongs to human
	}

	if not (bNoAutoNaming) then
		local num = CountUnitClass (unitClass, playerID)
		UnitName(playerID, unitID, num)
	end

	-- remove embarked promotion if needed
	CheckEmbarkedPromotion(unit)

	-- Set special units that can stack with normal units (but not with other special units)
	if IsRegiment(unit) then
		unit:SetIsSpecialType(true)
	end
	--DynamicTilePromotion(playerID, UnitID, unit:GetX(), unit:GetY())

	-- apply germany trait
	if GetCivIDFromPlayerID (playerID) == GERMANY then		
		if IsArmorClass(value.NumType) and not (IsAssaultGun(unit) or IsTankDestroyer(unit)) then
			unit:SetHasPromotion(PROMOTION_BLITZ, true)
		end
	end

	-- apply italy trait
	if GetCivIDFromPlayerID (playerID) == ITALY then
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_LAND ) then	
			unit:SetHasPromotion(PROMOTION_DESERT_POWER, true)
		end
	end

	-- apply russian trait
	if GetCivIDFromPlayerID (playerID) == USSR then
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_LAND ) then	
			unit:SetHasPromotion(PROMOTION_ARCTIC_POWER, true)
		end
	end

	-- apply english trait
	if GetCivIDFromPlayerID (playerID) == ENGLAND then
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_SEA ) then	
			unit:SetHasPromotion(PROMOTION_EXTRA_MOVE, true)
		end
	end

	-- some units can only fight in defense
	--if IsTankDestroyer(unit) or unit:IsHasPromotion(PROMOTION_FORTIFIED_GUN) then
	if unit:IsHasPromotion(PROMOTION_FORTIFIED_GUN) then
		unit:SetMadeAttack(true) -- will be set to false when needed in counter-fire / first strike functions in RedCombat.lua
	end

	--[[
	-- Place fort under airport
	if unitType == AIRFIELD then
		local plot = unit:GetPlot()
		local fortType = GameInfoTypes["IMPROVEMENT_FORT"]
		if (plot:GetImprovementType() ~= fortType) then
			plot:SetImprovementType(fortType)
		end
	end

	-- Place citadel under fortified guns
	if unitType == FORTIFIED_GUN then
		local plot = unit:GetPlot()
		--local citadelType = GameInfoTypes["IMPROVEMENT_CITADEL"]
		local citadelType = GameInfoTypes["IMPROVEMENT_FORT"] -- to do: resize citadel ? use fort
		if (plot:GetImprovementType() ~= citadelType) then
			plot:SetImprovementType(citadelType)
		end
	end
	--]]

	LuaEvents.NewUnitCreated()
end

function InitializeUnit(playerID, unitID)
	local bDebug = true
	local player = Players[ playerID ]
	local unit = player:GetUnitByID( unitID )
	if unit then
		local unitKey = GetUnitKey(unit)

		-- initialize only new units...
		if unit:GetGameTurnCreated() ~= Game.GetGameTurn() then
			return
		end
		-- don't initialise settlers
		if unit:GetUnitType() == SETTLER then
			Dprint("  - Unit (TypeID=".. unit:GetID() ..") is a Settler, don't initialize... ", bDebug) 
			return
		end


		if ( SetMinorUU(playerID, unitID) ) then
			-- unit was changed to Minor UU during the above test, don't initialize now, this will be recalled by the new UU creation
			return
		end
	
		if MapModData.RED.UnitData[unitKey] then
			-- unit already registered, don't add it again...
			Dprint("  - ".. unit:GetName() .." is already registered as " .. MapModData.RED.UnitData[unitKey].Type, bDebug) 
			return
		end

		Dprint ("Initializing new unit (".. unit:GetName() ..") for ".. player:GetName() .."...", bDebug)
		local bNoAutoNaming = string.len(unit:GetNameNoDesc()) > 1 -- check if unit has a custom name
		RegisterNewUnit(playerID, unit, bNoAutoNaming) -- no autonaming if unit already has a custom name
		Dprint("-------------------------------------", bDebug)
	else
		Dprint ("- WARNING : tried to initialize nil unit for ".. player:GetName(), bDebug)

	unit:SetDamage( unit:GetMaxHitPoints() - (unit:GetMaxHitPoints * 0.66 ) ) -- Makes making units have a bit of a delay until full health, useful for stopping massive spamming of units and costs resources

	end

end
-- Events.SerialEventUnitCreated.Add( InitializeUnit )
-- add to Events after map initialization (or re-loading)


--------------------------------------------------------------
-- Units placement from Order of Battle
--------------------------------------------------------------
function PlaceUnits(oob)
	local playerID = GetPlayerIDFromCivID( oob.CivID, oob.IsMinor )
	local player = Players [ playerID ]
	local plot = GetPlot(oob.X, oob.Y)
	local plotList = GetAdjacentPlots(plot, true)
	local placedUnits = 0
	for i, unitPlot in pairs (plotList) do
		local unitType = oob.Group[i]
		if unitPlot:GetNumUnits() > 0 then
			Dprint("- WARNING : trying to place unit on occupied plot at " .. unitPlot:GetX() .."," .. unitPlot:GetY())
		end
		if unitType and (unitPlot:GetNumUnits() == 0 or FORCE_UNIT_SPAWNING_ON_OCCUPIED_PLOT) then
			local unit = player:InitUnit(unitType, unitPlot:GetX(), unitPlot:GetY())
			FinalizeUnitFromOOB(unit, oob, i)
			placedUnits = placedUnits + 1
		end
	end
	if placedUnits < #oob.Group then
		Dprint("- WARNING : asked to place " ..  tostring(#oob.Group) .. " units, but found valid plots for only " .. tostring(placedUnits))
	end
end
function PlaceAirUnits(oob)
	local playerID = GetPlayerIDFromCivID( oob.CivID, oob.IsMinor )
	local player = Players [ playerID ]
	local plot = GetPlot(oob.X, oob.Y)
	for i, unitType in ipairs (oob.Group) do
		local unit = player:InitUnit(unitType, oob.X, oob.Y)
		FinalizeUnitFromOOB(unit, oob, i)
	end
end
function FinalizeUnitFromOOB(unit, oob, i)
	local bDebug = false
	local playerID = GetPlayerIDFromCivID( oob.CivID, oob.IsMinor )
	local player = Players [ playerID ]
	if unit:GetDomainType() == DomainTypes.DOMAIN_LAND and unit:GetPlot():IsWater() then
		Dprint("- initializing Land unit on sea...", bDebug)
		if (not unit:IsHasPromotion(PROMOTION_EMBARKATION)) then
			Dprint("   - Adding embarked promotion unitID =".. unit:GetID(), bDebug)
			unit:SetHasPromotion(PROMOTION_EMBARKATION, true)
		end
		--unit:SetEmbarked(true)
		unit:Embark(unit:GetPlot())
	end
	if IsRegiment(unit) and not unit:IsSpecialType() then
		Dprint("WARNING: ".. unit:GetName() .." of ".. player:GetName() .." was not marked 'special type', mark it...") 
		unit:SetIsSpecialType(true)
	end
	if unit:GetDomainType() == DomainTypes.DOMAIN_SEA and not unit:GetPlot():IsWater() then
		Dprint("- WARNING : tried to spawn a sea unit on land, calling JumpToNearestValidPlot()...", bDebug)
		unit:JumpToNearestValidPlot() -- safe with sea units ?
	end
	if oob.UnitsName and oob.UnitsName[i] then
		Dprint("   - Set name to unitID =".. unit:GetID(), bDebug)
		unit:SetName(oob.UnitsName[i])
	end
	if oob.UnitsXP and oob.UnitsXP[i] then
		Dprint("   - Set XP to unitID =".. unit:GetID(), bDebug)
		unit:SetExperience(oob.UnitsXP[i])
	end
	if oob.Promotions and oob.Promotions[i] then
		Dprint("   - Set promotion to unitID =".. unit:GetID(), bDebug)
		for j, promotion in pairs(oob.Promotions[i]) do
			unit:SetHasPromotion(promotion, true)
		end
	end
	if oob.InitialObjective then -- Initial objective is set for all units of all groups tagged InitialObjective = true		
		Dprint("   - Set Initial objective to unitID =".. unit:GetID(), bDebug)
		unit:SetDeployFromOperationTurn(Game.GetGameTurn()+1)
	end
end

-- Initial Order of Battle
function InitializeOOB ()
	-- mass units initialization is made in PlaceUnits() and PlaceAirUnits() functions
	local bDebug = false
	if g_Initial_OOB then
		Dprint("-------------------------------------")
		Dprint("Initialize Order of Battle" )
		local dominanceZone = {}
		for i, oob in ipairs (g_Initial_OOB) do
			local playerID = GetPlayerIDFromCivID (oob.CivID, oob.IsMinor)	
			Dprint("CivID = " .. oob.CivID, bDebug)
			Dprint("PlayerID = " .. playerID, bDebug)
			local player = Players[playerID]
			local bIsHumanSide = player and (player:IsHuman() or IsSameSideHuman(player))
			if (not (bIsHumanSide and oob.AI)) 
			--or BothSideHuman() 
			then
				Dprint("-------------------------------------", bDebug)
				Dprint("Placing ".. oob.Name, bDebug)
				if oob.Domain == "Land" or  oob.Domain == "Sea" then
					PlaceUnits(oob)
				elseif oob.Domain == "Air" or oob.Domain == "City" then
					PlaceAirUnits(oob)
				else
					Dprint("WARNING, domain is not valid : ".. oob.Domain, bDebug)
				end
				if oob.InitialObjective then
					dominanceZone[player] = oob.InitialObjective
				end
			end
		end
		for player, plotkey in pairs(dominanceZone) do
			Dprint("Set dominance zone for ".. player:GetName() .. " at " .. plotkey, bDebug)
			player:AddTemporaryDominanceZone (GetPlotXYFromKey (plotkey), AI_TACTICAL_TARGET_CITY)
		end
		Dprint("-------------------------------------", bDebug)
		Dprint("End of Order of Battle initialization ...", bDebug)
	end
end

-- Mid-Game Reinforcement
function SpawnReinforcements(playerID)

	local bDebug = false

	if g_Reinforcement_OOB then
		local CivID = GetCivIDFromPlayerID (playerID)
		if g_Reinforcement_OOB[CivID] then
			local player = Players[playerID]
			Dprint("-------------------------------------")
			Dprint("Check Reinforcement to spawn for ".. player:GetName())
			local turn = Game.GetGameTurn()
			local turnDate, prevDate = 0, 0
			if g_Calendar[turn] then turnDate = g_Calendar[turn].Number else turnDate = 19470105 end
			if g_Calendar[turn-1] then prevDate = g_Calendar[turn-1].Number else  prevDate = turnDate - 1 end
	
			Dprint ("Current turn date : " .. turnDate ..", next turn date :" .. prevDate, bDebug )

			for date, reinforcements in pairs(g_Reinforcement_OOB[CivID]) do
				if date <= turnDate and date > prevDate then
					for i, oob in ipairs (reinforcements) do
						Dprint (date .. " <= " .. turnDate .." and ".. date .." > " .. prevDate, bDebug )
						local bIsHumanSide = player and (player:IsHuman() or IsSameSideHuman(player))
						if (not (bIsHumanSide and oob.AI)) 
						-- or BothSideHuman()
						then
							Dprint("-------------------------------------", bDebug)
							Dprint("Placing ".. oob.Name, bDebug)
							if oob.Domain == "Land" or  oob.Domain == "Sea" then
								PlaceUnits(oob)
							elseif oob.Domain == "Air" or oob.Domain == "City" then
								PlaceAirUnits(oob)
							else
								Dprint("WARNING, domain is not valid : ".. oob.Domain, bDebug)
							end
						end
					end					
					if oob.InitialObjective then
						player:AddTemporaryDominanceZone (GetPlotXYFromKey ( oob.InitialObjective ), AI_TACTICAL_TARGET_CITY)
					end
				end
			end
			Dprint("-------------------------------------", bDebug)
			Dprint("End of Reinforcement spawning ...", bDebug)
		end
	end
end
-- GameEvents.PlayerDoTurn.Add(SpawnReinforcements)

-- Register Preplaced Units, to add in OnGameInit () after loading tables
function RegisterScenarioUnits()
	Dprint("-------------------------------------")
	Dprint("Register existing units from scenario maps ...")
	local bDebug = false
	for playerID = 0, GameDefines.MAX_CIV_PLAYERS - 1 do
		local player = Players[playerID]
		if player:IsAlive() and GetCivIDFromPlayerID (playerID) ~= HOTSEAT_CIV_TO_KILL then
			for unit in player:Units() do
				if (unit:GetUnitType() ~= SETTLER) then
					local unitKey = GetUnitKey(unit)
					if MapModData.RED.UnitData[unitKey] then
						-- unit already registered, don't add it again...
						Dprint("  - ".. unit:GetName() .." is already registered as " .. MapModData.RED.UnitData[unitKey].Type, bDebug) 
						return
					end
					Dprint ("Initializing scenario unit ".. unit:GetName() .. " for ".. player:GetName() .."...", bDebug)
					Dprint ("Complete Name: , Short Name:" .. unit:GetNameNoDesc(), bDebug)

					-- add scenario specific promotions (normally called in DynamicTilePromotion, but it's called after WB placed units are initialized...)
					SetScenarioPromotion(unit)

					local bNoAutoNaming = string.len(unit:GetNameNoDesc()) > 1 -- check if unit has a custom name
					RegisterNewUnit(playerID, unit, bNoAutoNaming) -- no autonaming if unit already has a custom name
					Dprint("-------------------------------------", bDebug)
				end
			end
		end
	end
end

function LaunchMilitaryOperation(playerID)

	local bDebug = false
	
	Dprint("-------------------------------------", bDebug)
	Dprint("Check for Military Operations...", bDebug)

	if not g_Military_Project then
		Dprint("- But no military project defined for this scenario...", bDebug)
		return
	end

	if playerID == nil then
		Dprint("- PlayerID was nil, assume LaunchMilitaryOperation was called by ActivePlayerStartTurn for active player...", bDebug)
		playerID = Game.GetActivePlayer()
		if not Players[playerID]:IsHuman() then		
			Dprint("- Game.GetActivePlayer() has returned a non human player... WTF ??? escaping here, bug maybe caused by auto end turn...", bDebug)
			return
		end
	end

	local player = Players[playerID]

	if player:IsHuman() and not IsActivePlayerTurnInitialised() then
		Dprint("- Player is human, but function called before it's turn has been initialized, wait for ActivePlayerStartTurn...", bDebug)
		return -- for human player this will be called again at ActivePlayerStart turn
	end

	local civID = GetCivIDFromPlayerID(playerID, false)

	if not g_Military_Project[civID] then
		Dprint("- But no military project defined for this nation...", bDebug)
		return
	end

	
	if (player:IsMinorCiv() and (not g_Military_Project[civID].IsMinor)) or ((not player:IsMinorCiv()) and g_Military_Project[civID].IsMinor) then
		Dprint("- but minor/major/project defines do not match...", bDebug)
		return
	end

	Dprint("-------------------------------------", bDebug)
	Dprint("Initializing Military Operations for " .. player:GetName(), bDebug)

	for id, militaryOperation in pairs(g_Military_Project[civID]) do	
		local savedData = Modding.OpenSaveData()
		local saveStr = "Operation-"..id
		local triggered = savedData.GetValue(saveStr)
		if triggered ~= 1 then -- not triggered yet, test it !
			-- check if required project is done
			if (IsProjectDone(id, civID)) then
				local condition
				if militaryOperation.Condition then
					condition = militaryOperation.Condition()
					Dprint(" - Checking Operation ID = " .. tostring(id), bDebug)
				else
					condition = true -- if no condition set, assume always true
				end

				if condition then
					
					Dprint(" - Launching Operation ID = " .. tostring(id), bDebug)
					Dprint(" - Code Name =  " .. Locale.ConvertTextKey(militaryOperation.Name), bDebug)
					if militaryOperation.Name then
						Events.GameplayAlertMessage(Locale.ConvertTextKey(militaryOperation.Name).." has been launched !")
						BroadcastNotification(NotificationTypes.NOTIFICATION_PROJECT_COMPLETED, Locale.ConvertTextKey(militaryOperation.Name).." launched !", Locale.ConvertTextKey(militaryOperation.Name).." launched !", nil, nil, id, playerID )
					end
					LaunchUnits(militaryOperation)

					if (not CanRepeatProject(id)) then
						Dprint(" - Marking Operation done...", bDebug)
						local saveStr = "Operation-"..id
						savedData.SetValue(saveStr, 1) -- mark as triggered !
					else
						Dprint(" - Operation can be repeated, mark project as not completed so it can be launched again...", bDebug)
						MarkProjectNotCompleted(id, civID) -- now that Civ can build this project again...
					end
					LuaEvents.MilitaryOperationLaunched(id, civID) -- can use LuaEvents.MilitaryOperationLaunched.Add(anyScenarioFunction) in the scenarios Lua to do additional stuff...
					
					--PauseGame(3)
				end
			end
		end
	end
	Dprint("Military Operations initialized...", bDebug)
	Dprint("-------------------------------------", bDebug)
end

function LaunchUnits(militaryOperation)
	local bDebug = false
	for i, oob in ipairs (militaryOperation.OrderOfBattle) do
		local playerID = GetPlayerIDFromCivID( oob.CivID, oob.IsMinor )
		local player = Players [ playerID ]
		local bIsHumanSide = player and (player:IsHuman() or IsSameSideHuman(player))
		if (not (bIsHumanSide and oob.AI)) or BothSideHuman() then
			Dprint("   - Launching " .. tostring(oob.Name), bDebug)
			--PauseGame(2)
			local plot = GetPlot(oob.X, oob.Y)
			local plotList = GetAdjacentPlots(plot, true)

			local objectivePlot = nil
			local objectivePlotList = {}
			local validPlotList = {}
			local bParadrop = (oob.LaunchType and oob.LaunchType == "ParaDrop")
			local bAmphibious = (oob.LaunchType and oob.LaunchType == "Amphibious")
			if  bParadrop then
				objectivePlot = GetPlot(oob.LaunchX, oob.LaunchY)
				objectivePlotList = GetPlotsInCircle(objectivePlot, 0, oob.LaunchImprecision)
				for i, testPlot in pairs(objectivePlotList) do
					if testPlot:GetNumUnits() == 0 and not testPlot:IsWater() and not testPlot:IsImpassable() and not testPlot:IsCity() and not IsNeutral(testPlot:GetOwner()) then
						table.insert(validPlotList, testPlot)
					end
				end
				Shuffle(validPlotList)
			end
	
	--		if player:GetID() == Game:GetActivePlayer() and bParadrop then
			if bParadrop then
			
				Dprint("   - Looking at objective at " .. tostring(objectivePlot:GetX()) .. "," .. tostring(objectivePlot:GetY()), bDebug)
				UI.LookAt(objectivePlot, 0)
				--PlaceCameraAtPlot(objectivePlot)
			end

			local placedUnits = 0
			local unitList = {}

			-- place units on map
			for i, unitPlot in pairs (plotList) do
				local unitType = oob.Group[i]
				if unitPlot:GetNumUnits() > 0 then
					Dprint("- WARNING : trying to place unit on occupied plot at " .. unitPlot:GetX() .."," .. unitPlot:GetY())
				end
				if unitType and (unitPlot:GetNumUnits() == 0 or FORCE_UNIT_SPAWNING_ON_OCCUPIED_PLOT) then
			
					local bCanPlaceUnit = true
					if bParadrop and not validPlotList[i] then
						Dprint("- WARNING : Not enough valid Airdrop destination plot for i = " .. tostring(i))
						bCanPlaceUnit = false
					end
					if bCanPlaceUnit then
						local unit = player:InitUnit(unitType, unitPlot:GetX(), unitPlot:GetY())
						RegisterNewUnit(playerID, unit) -- force immediate registration to allow change in MapModData.RED.UnitData
						local unitKey = GetUnitKey(unit)
						FinalizeUnitFromOOB(unit, oob, i)
						placedUnits = placedUnits + 1
						table.insert(unitList, unitKey)

						if bAmphibious then -- initialize first move for Amphibious operation
							Dprint("   - Initialize first move for Amphibious unit...", bDebug)							
							
							local routeID = oob.RouteID

							MapModData.RED.UnitData[unitKey].OrderReference = routeID
							MapModData.RED.UnitData[unitKey].TotalControl = true

							local newWaypoint = GetFirstWaypoint(playerID, routeID)

							if newWaypoint then
								MapModData.RED.UnitData[unitKey].OrderType = RED_MOVE_TO_EMBARKED_WAYPOINT
								MapModData.RED.UnitData[unitKey].OrderObjective = newWaypoint
								MoveUnitTo (unit, GetPlot (newWaypoint.X, newWaypoint.Y ))
							else
								local newDestination = GetDestinationToDisembark(playerID, routeID)
								MapModData.RED.UnitData[unitKey].OrderType = RED_MOVE_TO_DISEMBARK
								MapModData.RED.UnitData[unitKey].OrderObjective = newDestination
								MoveUnitTo (unit, GetPlot (newDestination.X, newDestination.Y ))
							end
						end
					end
				end
			end

			-- now the show for paradrop...
			if bParadrop then
				--PauseGame(2)
				spotterList = {}
				Dprint("   - Placing spotters for Paradrop mission...", bDebug)
				for i, unitKey in pairs (unitList) do		
					local dropPlot = validPlotList[i]		
					local spotter = player:InitUnit(SETTLER, dropPlot:GetX(), dropPlot:GetY())
					spotter:SetHasPromotion(PROMOTION_AIR_RECON, true)

					local spotterKey = GetUnitKey(spotter)
					Dprint("     - Placing spotters (key = ".. tostring(spotterKey) ..") at " .. tostring(dropPlot:GetX()) .."," .. tostring(dropPlot:GetY()), bDebug)
					table.insert(spotterList, spotterKey)
				end
				
				--PauseGame(2)
				--UI.LookAt(objectivePlot, 0)
				local paraList = {}
				for i, unitKey in pairs (unitList) do
					local unit = GetUnitFromKey ( unitKey )
					local dropPlot = validPlotList[i]
					
					Dprint("   - Launch Paradrop mission for " .. unit:GetName() .. " (unitID = ".. unit:GetID() .. ") at " .. tostring(dropPlot:GetX()) .."," .. tostring(dropPlot:GetY()), bDebug)
					
					unit:SetHasPromotion(PROMOTION_PARADROP, false) -- to do: restore after removing long paradrop in case it was set
					unit:SetHasPromotion(PROMOTION_LONG_PARADROP, true)
					unit:PopMission()
					unit:PushMission(MissionTypes.MISSION_PARADROP, dropPlot:GetX(), dropPlot:GetY(), 0, 0, 1, MissionTypes.MISSION_PARADROP, unit:GetPlot(), unit)
					--unit:SetMoves(0)
					unit:SetHasPromotion(PROMOTION_LONG_PARADROP, false)
					unit:PopMission()
					ChangeUnitOwner (unit, unit:GetOwner()) -- trying to fix a strange bug (bad initialization for those units...)
				end

				Dprint("   - Remove spotters for Paradrop mission...", bDebug)
				for v in player:Units() do
					if (v:GetUnitType() == SETTLER) then
						Dprint("     - removing spotter at " .. tostring(v:GetX()) .."," .. tostring(v:GetY()), bDebug)
						v:Kill(true, -1)
					end
				end
			end
										
			if oob.InitialObjective then
				player:AddTemporaryDominanceZone (GetPlotXYFromKey ( oob.InitialObjective ), AI_TACTICAL_TARGET_CITY)
			end

			if placedUnits < #oob.Group then
				Dprint("- WARNING : asked to place " ..  tostring(#oob.Group) .. " units, but found valid plots for only " .. tostring(placedUnits))
			end
		end
	end
end

-- unused / WIP
function WarPlannedOperations( iTeam1, iTeam2, bWar ) -- Check for military operation to launch at DoW...

	local bDebug = false

	if (bWar) then
		for playerID = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			local player = Players[playerID]
			if player and player:IsAlive() then
				if player:GetTeam() == iTeam1 or player:GetTeam() == iTeam2 then -- to do : check if player is in active turn
					--LaunchMilitaryOperation(playerID)
				end				
			end
		end
	end	
end
-- Events.WarStateChanged.Add( WarPlannedOperations ) at game init...


--------------------------------------------------------------
-- units Max Health
--------------------------------------------------------------

-- Not used, main problem is number of figures relative to global maxHP and the need to pass unitData to UnitFlagManager.lua
function GetUnitMaxHP(unit)
	local unitKey = GetUnitKey (unit)
	return unitData[unitKey].MaxHP or MAX_HP 
end


--------------------------------------------------------------
-- Minor Civilizations Units replacing
--------------------------------------------------------------
function ChangeUnitTo ( playerID, unitID, unitType )
	local player = Players[ playerID ]
	local unit = player:GetUnitByID( unitID )

	-- get position before killing the unit !
	local x = unit:GetX()
	local y = unit:GetY()

	-- kill old unit
	unit:SetDamage( unit:GetMaxHitPoints() )

	-- create the new unit from the old one
	local newUnit = player:InitUnit(unitType, x, y)
	newUnit:SetExperience ( unit:GetExperience() )
	newUnit:SetLevel ( unit:GetLevel() )
	for unitPromotion in GameInfo.UnitPromotions() do
		local unitPromotionID = unitPromotion.ID
		if( unit:IsHasPromotion( unitPromotionID ) ) then
			newUnit:SetHasPromotion( unitPromotionID )
		end
	end
end

function GetMinorUUType(playerID, unitClassTypeID)
	local player = Players[ playerID ]
	local playerCivID = player:GetMinorCivType()
	local minorUUID = nil
	local minorList = g_Minor_UU[playerCivID]
	if minorList then
		minorUUID = minorList[unitClassTypeID]
	end

	if minorUUID then
		return minorUUID
	end
	return -1
end

function SetMinorUU( playerID, unitID )

	local player = Players[ playerID ]
	if ( player:IsMinorCiv() ) then
		local unit = player:GetUnitByID( unitID )
		local unitType = unit:GetUnitType()		
		local unitClassTypeID = unit:GetUnitClassType()
		local citystateUUTypeID = GetMinorUUType( playerID, unitClassTypeID )

		-- be cautious when setting conditions, remember that we can create an infinite loop here
		if (citystateUUTypeID >= 0  and unitType ~= citystateUUTypeID) then
			ChangeUnitTo ( playerID, unitID, citystateUUTypeID )
			return true
		end
	end

	return false
end

--function OnUnitCreated( playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible )
--Events.SerialEventUnitCreated.Add( HandleCityStateUU )


--------------------------------------------------------------
-- Units Upgrade
--------------------------------------------------------------

-- Return next upgrade type for this unit type
function GetUnitUpgradeType(unitType)
	if g_UnitUpgrades and g_UnitUpgrades[unitType] then
		return g_UnitUpgrades[unitType]
	end
	return nil
end

-- Return the last available upgrade type for this player and unit type
function GetLastUnitUpgradeType(player, unitType)
	local testType = unitType
	local upgradeType = nil

	repeat
		testType = GetUnitUpgradeType(testType)
		if testType and player:CanTrain(testType) then
			upgradeType = testType
		end
	until not testType

	return upgradeType
end

function GetUnitUpgradeCost(unitType, upgradeType)
	local diffCost = tonumber(GameInfo.Units[upgradeType].Cost) - tonumber(GameInfo.Units[unitType].Cost)
	local cost = GameDefines.BASE_UNIT_UPGRADE_COST +  diffCost * GameDefines.UNIT_UPGRADE_COST_PER_PRODUCTION
	if cost > 0 then
		return cost
	else
		return 0
	end
end

function UpgradingUnits(playerID)
	local bDebug = false
	local player = Players[playerID]
	if ( player:IsAlive() and not player:IsBarbarian() ) then
		Dprint("-------------------------------------", bDebug)
		Dprint("Check possible unit upgrade for ".. player:GetCivilizationShortDescription() .."...", bDebug)
		local upgradeTable = {} 
		for unit in player:Units() do
			local upgradeType = GetLastUnitUpgradeType(player, unit:GetUnitType() )
			-- to do : check if upgradeType can also be upgraded and upgrade to last type available...
			if upgradeType -- upgrade is available ?
			  and (unit:GetDamage() < unit:GetMaxHitPoints() / 2) -- don't upgrade more than half-damaged unit
			  and not unit:IsEmbarked()
			  and not (unit:IsHasPromotion(PROMOTION_NO_SUPPLY)) and not (unit:IsHasPromotion(PROMOTION_NO_SUPPLY_SPECIAL_FORCES)) -- unit must have supply line
			  then
				table.insert(upgradeTable, { Unit = unit, XP = unit:GetExperience(), UpgradeType = upgradeType })
				Dprint("   -- possible upgrade for ".. unit:GetName() .." (".. unit:GetExperience() .."xp) to " .. Locale.ConvertTextKey(GameInfo.Units[upgradeType].Description), bDebug)
			end
		end
		table.sort(upgradeTable, function(a,b) return a.XP > b.XP end) -- upgrade higher XP first...
		for i, data in ipairs(upgradeTable) do
			local reqMateriel = GetUnitUpgradeCost(data.Unit:GetUnitType(), data.UpgradeType)
			if (reqMateriel <= MapModData.RED.ResourceData[playerID].Materiel) then
				Dprint("Upgrade ".. data.Unit:GetName() .." to " .. Locale.ConvertTextKey(GameInfo.Units[data.UpgradeType].Description), bDebug)
				MapModData.RED.ResourceData[playerID].Materiel = MapModData.RED.ResourceData[playerID].Materiel - reqMateriel
				MapModData.RED.ResourceData[playerID].MatToUpgrade = reqMateriel
				local oldType = data.Unit:GetUnitType()
				local plot = data.Unit:GetPlot()
				local newUnit = ChangeUnitType (data.Unit, data.UpgradeType)
				if newUnit then
					player:AddNotification(NotificationTypes.NOTIFICATION_UNIT_PROMOTION, newUnit:GetNameNoDesc() .. " have just been upgraded from ".. Locale.ConvertTextKey(GameInfo.Units[oldType].Description).." to " .. Locale.ConvertTextKey(GameInfo.Units[data.UpgradeType].Description), newUnit:GetNameNoDesc() .. " upgraded !", -1, -1, data.UpgradeType, newUnit:GetID())
					return -- upgrade one unit per turn max...
				end
			end
		end		
		Dprint("No upgrade made (not enought materiel, or no upgradable units available)", bDebug)
		MapModData.RED.ResourceData[playerID].MatToUpgrade = nil
	end
end
-- add to GameEvents.PlayerDoTurn


--------------------------------------------------------------
-- Units Promotions
--------------------------------------------------------------

function DynamicUnitPromotion(playerID)

	local bDebug = false

	local player = Players[playerID]
	if ( player:IsAlive() ) then	
		Dprint("-------------------------------------", bDebug)
		Dprint("Add and remove dynamic promotions for ".. player:GetName() .." units ...", bDebug)
		for unit in player:Units() do
			-- Supply line ?
			local unitType = unit:GetUnitType()
			local noSupply
			if HasNoCombatPenaltyFromSupply(unitType) then
				noSupply = PROMOTION_NO_SUPPLY_SPECIAL_FORCES
			elseif UseFuel(unitType) then
				noSupply = PROMOTION_NO_SUPPLY_MECHANIZED
			else
				noSupply = PROMOTION_NO_SUPPLY
			end

			if CanGetSupply(playerID, unit:GetID()) then
				if (unit:IsHasPromotion(noSupply)) then
					Dprint("   - Removing mark " .. unit:GetName() .. " (unitID =".. unit:GetID() ..", playerID =".. playerID .."), supply line reopen", bDebug)
					unit:SetHasPromotion(noSupply, false)
				end
			elseif not (unit:IsHasPromotion(noSupply)) then
				Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..", playerID =".. playerID .."), has no supply line", bDebug)
				unit:SetHasPromotion(noSupply, true)
				if UseFuel(unitType) then
					unit:SetMoves(Round(unit:MovesLeft() * (NO_SUPPLY_LINE_INITIAL_MOVEMENT_LEFT/100)))
				end
			else
				Dprint("   - " .. unit:GetName() .. " (unitID =".. unit:GetID() ..", playerID =".. playerID .."), has still no supply line but is already marked", bDebug)
				if UseFuel(unitType) then
					unit:SetMoves(Round(unit:MovesLeft() * (NO_SUPPLY_LINE_MOVEMENT_LEFT/100)))
				end
			end

			if UseFuel(unitType) and not unit:IsHasPromotion(noSupply) then -- don't apply the penalty twice...
				if (unit:IsHasPromotion(PROMOTION_LIGHT_RATIONING)) then unit:SetMoves(Round(unit:MovesLeft() * (LIGHT_RATIONING_MOVEMENT_LEFT/100))) end
				if (unit:IsHasPromotion(PROMOTION_RATIONING))		then unit:SetMoves(Round(unit:MovesLeft() * (MEDIUM_RATIONING_MOVEMENT_LEFT/100))) end
				if (unit:IsHasPromotion(PROMOTION_HEAVY_RATIONING)) then unit:SetMoves(Round(unit:MovesLeft() * (HEAVY_RATIONING_MOVEMENT_LEFT/100))) end
			end

		end
	end
end
-- add to GameEvents.PlayerDoTurn on loading / reloading a game.

function DynamicTilePromotion(playerID, UnitID, x, y)

	-- to do : optimization...

	local bDebug = false

	local plot = Map.GetPlot(x,y)
	local player = Players [ playerID ]
	local unit = player:GetUnitByID(UnitID)
	local unitType = unit:GetUnitType()

	if unit:IsEmbarked() and (not player:IsHuman()) then bDebug = False; end

	if (plot) then 
		Dprint("-------------------------------------", bDebug)
		Dprint("Add and remove dynamic tile promotions for ".. unit:GetName() .." (id=".. unit:GetID() ..") at " .. tostring(GetPlotKey ( plot )), bDebug)

		-- Embarked promotion...

		CheckEmbarkedPromotion(unit) -- Remove/Add embarked promotion for AI units if required by scenario (like reinforcement routes)

		if EMBARK_FROM_HARBOR and not (NO_AI_EMBARKATION and not player:IsHuman()) then -- here we check the AI only if it's allowed to embark at will
			if not ( GameInfo.Units[unitType].Domain == "DOMAIN_SEA" or GameInfo.Units[unitType].Domain == "DOMAIN_AIR" or unit:IsEmbarked() ) then -- don't test those -- 
				if CanEmbarkFrom(plot, unit) then
					if not (unit:IsHasPromotion(PROMOTION_EMBARKATION)) then
						Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", can Embark", bDebug)
						unit:SetHasPromotion(PROMOTION_EMBARKATION, true)
					end
				elseif (unit:IsHasPromotion(PROMOTION_EMBARKATION)) then
					Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", can no longer Embark", bDebug)
					unit:SetHasPromotion(PROMOTION_EMBARKATION, false)
				end				
			end
		end

		if not ( GameInfo.Units[unitType].Domain == "DOMAIN_SEA" or GameInfo.Units[unitType].Domain == "DOMAIN_AIR" or unit:IsHasPromotion(PROMOTION_EMBARKATION)) then
			local area = plot:Area()
			if area:GetNumCities() == 0 then
				Dprint("   - Somehow " .. unit:GetName() .. " has managed to land on a desert island, be nice and give it the embark promotion...", bDebug)
				unit:SetHasPromotion(PROMOTION_EMBARKATION, true)
			end
		end

		-- Paradrop from cities only
		if CanParadrop(unitType) then
			if ( plot:IsCity() and AreSameSide( plot:GetOwner(), playerID)) then
				if not (unit:IsHasPromotion(PROMOTION_PARADROP)) then
					Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", can Paradrop", bDebug)
					unit:SetHasPromotion(PROMOTION_PARADROP, true)
				end
			elseif (unit:IsHasPromotion(PROMOTION_PARADROP)) then
				Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", can no longer Paradrop", bDebug)
				unit:SetHasPromotion(PROMOTION_PARADROP, false)
			end
		end

		-- Special Forces
		if unit:IsHasPromotion(PROMOTION_SPECIAL_FORCES) then
			if ( plot:GetFeatureType() == FeatureTypes.FEATURE_FOREST or plot:GetFeatureType() == FeatureTypes.FEATURE_JUNGLE) then
				if not (unit:IsHasPromotion(PROMOTION_INVISIBLE)) then
					Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", invisible in wood or jungle", bDebug)
					unit:SetHasPromotion(PROMOTION_INVISIBLE, true)
				end
			elseif (unit:IsHasPromotion(PROMOTION_INVISIBLE)) then
				Dprint("   - Marking " .. unit:GetName() .. " (unitID =".. unit:GetID() ..") of ".. player:GetName() ..", remove invisibility", bDebug)
				unit:SetHasPromotion(PROMOTION_INVISIBLE, false)
			end
		end

		-- Scenarios may specify custom promotions...
		SetScenarioPromotion(unit)

	end
end
-- add to GameEvents.UnitSetXY on loading and reloading game (this event is also fired when unit is created)

function CheckEmbarkedPromotion(unit)
	local bDebug = false
	local player = Players[unit:GetOwner()]
	local unitType = unit:GetUnitType()

	if NO_AI_EMBARKATION and not player:IsHuman() then

		if not unit:GetDomainType() == DomainTypes.DOMAIN_LAND then
			return
		end
	
		local unitKey = GetUnitKey(unit)
		local specialCase = false
		if MapModData.RED.UnitData[unitKey] then -- don't test new units before initialisation of MapModData.RED.UnitData
			if MapModData.RED.UnitData[unitKey].OrderType == RED_MOVE_TO_EMBARK or MapModData.RED.UnitData[unitKey].OrderType == RED_MOVE_TO_DISEMBARK then
				specialCase = true
			end
			if MapModData.RED.UnitData[unitKey].OrderType == RED_MOVE_TO_EMBARKED_WAYPOINT and (not unit:IsEmbarked()) then
				-- Do not remove the embarkation promotion if we're still on land but trying to reach a waypoint on water...
				specialCase = true
			end

			if (unit:IsHasPromotion(PROMOTION_EMBARKATION))	and not specialCase then -- as the AI is not allowed to use embarkation, only allow units embark/disembark from a scenario specific event
				Dprint("   - Removing embarkation promotion from " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_EMBARKATION, false)
			end

			if (not unit:IsHasPromotion(PROMOTION_EMBARKATION))	and MapModData.RED.UnitData[unitKey].OrderType == RED_MOVE_TO_DISEMBARK and unit:IsEmbarked() then -- allow unit to disembark, but do not give back to unit that have disembarked near their disembark plot (maybe redondant with the check for landing code, but should handle the cases when MAX_LANDING_PLOT_DISTANCE is too low for the sea front scale)
				Dprint("   - Adding embarkation promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_EMBARKATION, true)
			end
		end

	elseif not EMBARK_FROM_HARBOR and not (unit:IsHasPromotion(PROMOTION_EMBARKATION)) and not ( GameInfo.Units[unitType].Domain == "DOMAIN_SEA" or GameInfo.Units[unitType].Domain == "DOMAIN_AIR" ) then
		Dprint("   - Adding embarkation promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
		unit:SetHasPromotion(PROMOTION_EMBARKATION, true)
	end
end

function SetScenarioPromotion(unit)
	local bDebug = false
	
	if USE_TACTICAL_RANGE then
		if unit:IsRanged() and (unit:GetDomainType() == DomainTypes.DOMAIN_LAND) then
			if (not unit:IsHasPromotion(PROMOTION_RANGE_3)) then
				Dprint("   - Adding +3 range promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_RANGE_3, true)
			end
		end
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_AIR ) then
			if (not unit:IsHasPromotion(PROMOTION_RANGE_6)) then
				Dprint("   - Adding +6 range promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_RANGE_6, true)
			end
		end
	end
		
	if USE_FAST_OCEAN_MOVE then
		if (unit:IsEmbarked() or unit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
			if (not unit:IsHasPromotion(PROMOTION_OCEAN_MOVEMENT)) then
				Dprint("   - Adding x2 Ocean move to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_OCEAN_MOVEMENT, true)
			end
		elseif (not unit:IsEmbarked()) and ( unit:GetDomainType() == DomainTypes.DOMAIN_LAND ) then
			if (unit:IsHasPromotion(PROMOTION_OCEAN_MOVEMENT)) then
				Dprint("   - Removing x2 Ocean move to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_OCEAN_MOVEMENT, false)
			end
		end
	end
		
	if USE_FAST_NAVAL_MOVE then
		if (unit:IsEmbarked() or unit:GetDomainType() == DomainTypes.DOMAIN_SEA) then
			if (not unit:IsHasPromotion(PROMOTION_NAVAL_MOVEMENT)) then
				Dprint("   - Adding +2 Sea moves to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_NAVAL_MOVEMENT, true)
			end
		elseif (not unit:IsEmbarked()) and ( unit:GetDomainType() == DomainTypes.DOMAIN_LAND ) then
			if (unit:IsHasPromotion(PROMOTION_NAVAL_MOVEMENT)) then
				Dprint("   - Removing +2 Sea moves to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_NAVAL_MOVEMENT, false)
			end
		end
	end

	if USE_EARTH_MOVE then
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_LAND ) then
			if (not unit:IsHasPromotion(PROMOTION_EARTH_LS_RANGE)) then
				Dprint("   - Adding -1 move promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_EARTH_LS_RANGE, true)
			end
		end
		if ( unit:GetDomainType() == DomainTypes.DOMAIN_AIR ) then
			if (not unit:IsHasPromotion(PROMOTION_EARTH_AIR_RANGE)) then
				Dprint("   - Adding -2 range promotion to " .. unit:GetName() .. " (unitID =".. unit:GetID(), bDebug)
				unit:SetHasPromotion(PROMOTION_EARTH_AIR_RANGE, true)
			end
		end
	end

end


function RemoveFreePromotions(unit)
	local thisUnit = GameInfo.Units[unit:GetUnitType()]
	local condition = "UnitType = '" .. thisUnit.Type .. "'";
	for row in GameInfo.Unit_FreePromotions( condition ) do
		local promotion = GameInfo.UnitPromotions[row.PromotionType];
		if promotion then
			if (unit:IsHasPromotion(promotion.ID)) then
				unit:SetHasPromotion(promotion.ID, false)
			end
		end	
	end
end

function RestoreFreePromotions(unit)
	local thisUnit = GameInfo.Units[unit:GetUnitType()]
	local condition = "UnitType = '" .. thisUnit.Type .. "'";
	for row in GameInfo.Unit_FreePromotions( condition ) do
		local promotion = GameInfo.UnitPromotions[row.PromotionType];
		if promotion then
			if (not unit:IsHasPromotion(promotion.ID)) then
				unit:SetHasPromotion(promotion.ID, true)
			end
		end	
	end
end

function InitializeDynamicPromotions()
	for playerID = 0, GameDefines.MAX_CIV_PLAYERS - 1 do
		local player = Players[playerID]
		if player and player:IsAlive() then
			for unit in player:Units() do
				DynamicTilePromotion(playerID, unit:GetID(), unit:GetX(), unit:GetY())
			end
		end
	end
end


-------------------------------
-- New unit:fonctions()
-------------------------------

function GetPreviousDamage(self)
	local unitKey = GetUnitKey(self)
	local damage = 0
	if MapModData.RED.UnitData[unitKey] then
		damage = MapModData.RED.UnitData[unitKey].Damage
	end
	return damage
end

function NewUnitSetDamage(self, damage)
	local unitKey = GetUnitKey(self)
	if MapModData.RED.UnitData[unitKey] then
		MapModData.RED.UnitData[unitKey].Damage = damage
	end
	self:OldSetDamage(damage)
end

--function InitializeUnitFunctions(playerID, unitID)
function InitializeUnitFunctions(playerID, unitID)

	local bDebug = false
	
	--local player = Players[ playerID ]
	--local unit = player:GetUnitByID( unitID )
	local player = Players[Game.GetActivePlayer()]
	for unit in player:Units() do -- get the first unit we found...
		-- update unit functions...
		local u = getmetatable(unit).__index
	
		Dprint ("------------------ ", bDebug)
		Dprint ("Updating unit metatable... ", bDebug)

		-- initialize once...
		if not u.OldSetDamage then
			u.OldSetDamage = u.SetDamage
			-- set replacement
			u.SetDamage = NewUnitSetDamage
			u.GetPreviousDamage = GetPreviousDamage
			-- remove from event
			GameEvents.GameCoreUpdateBegin.Remove( InitializeUnitFunctions )
		end
		break
	end
end


-------------------------------
-- Combat restriction
-------------------------------

function CanRangeStrike(iPlayer, iUnit, x, y)
	--Dprint("Can range strike at (" .. x .. "," .. y ..") ?")
	local player = Players[iPlayer]
	if not player then
		return false
	end
	local unit = player:GetUnitByID(iUnit)
	local plot = GetPlot(x,y)

	if (not unit) or (not plot) then -- we may want to change that to allow range strike on improvement...
		return false 
	end

	local unitDomain = unit:GetDomainType()
	local unitPlot = unit:GetPlot()

	if g_NoRangeAttack and g_NoRangeAttack[unit:GetUnitType()] then -- some ranged units can't range attack (ex: the Me-262 can only intercept or air sweep)		
		return false 
	end

	if unitDomain == DomainTypes.DOMAIN_SEA and unitPlot:IsCity() then -- naval units can't fire from harbors
		return false
	end

	if unitDomain == DomainTypes.DOMAIN_LAND and unit:Range() < 3 and (unitPlot:GetArea() ~= plot:GetArea() and not plot:IsWater()) then -- don't fire across sea channel unless we are really long range...
		return false
	end

	local unitCount = plot:GetNumUnits()
	local bestDefender = nil
	for i = 0, unitCount - 1, 1 do	
    	local testUnit = plot:GetUnit(i)
		if testUnit and testUnit:IsBetterDefenderThan(bestDefender, unit) then
			bestDefender = testUnit
		end
	end
	if bestDefender then
		local defenderClassType = bestDefender:GetUnitClassType()
		local defenderNumType = g_Unit_Classes[defenderClassType].NumType or -1
		--Dprint("defendernumtype = " .. tostring(defenderNumType))
		local classType = unit:GetUnitClassType()
		local numType = g_Unit_Classes[classType].NumType or -1
		--Dprint("attackernumtype = " .. tostring(numType))
		-- to attack submarines we can't be land based or large bomber
		-- to do : change that check to depth charge or torpedoes promotions
		if not plot:IsCity() and IsSubmarineClass(defenderNumType) and (unitDomain == DomainTypes.DOMAIN_LAND or (unitDomain == DomainTypes.DOMAIN_AIR --[[and not IsSmallBomberClass(numType)--]])) then
			return false
		end
	end

	return true
end
--GameEvents.CanRangeStrikeAt.Add(CanRangeStrike)


function UnitsBleeding(playerID)
	local bDebug = false
	local player = Players[playerID]
	if ( player:IsAlive() and not player:IsBarbarian() ) then
		Dprint("-------------------------------------", bDebug)
		Dprint("Check units bleeding for ".. player:GetCivilizationShortDescription() .."...", bDebug)
		for unit in player:Units() do
			if IsBleeding(unit) and (not unit:IsDead()) then
				Dprint(" - apply bleeding to ".. unit:GetName() .."...", bDebug)
				local damage = unit:GetDamage()
				unit:SetDamage(unit:GetDamage() + BLEEDING_PER_TURN)
			end
		end
	end
end


-- Spawning Partisans
function SpawnPartisans(playerID)
	local bDebug = false
	if g_Partisan then
		local player = Players [ playerID ]
		if (not player:IsAlive()) or player:IsBarbarian() then
			return
		end
		Dprint("-------------------------------------", bDebug)
		Dprint("Check Partisans to spawn for ".. player:GetName(), bDebug)
		local rand = math.random( 1, 100 )
		local condition
		local bSpawned = false
		for i, data in ipairs(g_Partisan) do
			local OwnerID = GetPlayerIDFromCivID( data.CivID, data.IsMinor )
			if playerID == OwnerID then			
				if data.Condition then
					condition = data.Condition()
				else
					condition = true -- if no condition set, assume always true
				end
			end
			if condition and rand < data.Frequency then
				if data.RandomSpawn then
					local numTry = 0
					while not bSpawned and numTry < 20 do -- check 20 random plots from list for spawning...
						local spawnList = data.SpawnList
						local randPlot = math.random( 1, #spawnList )
 						Dprint("      - Random spawn position selection = " .. randPlot, bDebug)
						local plotPosition = spawnList[randPlot]
						bSpawned = InitPartisanUnit(playerID, plotPosition.X, plotPosition.Y)
						numTry = numTry + 1
					end
				else
					for i, plotPosition in ipairs(data.SpawnList) do
 						Dprint("      - Sequential spawn position selection = " .. i, bDebug)
						if not bSpawned then
							bSpawned = InitPartisanUnit(playerID, plotPosition.X, plotPosition.Y)
						end
					end
				end
			end
		end
	end
end
-- GameEvents.PlayerDoTurn.Add(SpawnPartisans)

function InitPartisanUnit(playerID, x, y)
	local bDebug = false
	local plot = GetPlot(x, y)
	if plot:GetNumUnits() == 0 then
		local player = Players[playerID]
		local unit = player:InitUnit(FR_PARTISAN, x, y)
		Dprint("      - Partisan placed...", bDebug)
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, "New partisan unit formed !", "New partisan unit formed !", x, y)
		Dprint("      - Creating new partisan at ("..x..","..y..")", bDebug)
		if unit then
			RegisterNewUnit(player:GetID(), unit) -- force immediate registration
		end
		return true
	end
	return false
end





