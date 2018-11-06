-- RedPacific1942
-- Author: bacononaboat
-- DateCreated: 3/25/2017
--------------------------------------------------------------
print("Loading Red PACIFIC 1942 Functions...")
print("-------------------------------------")

-----------------------------------------
-- Initializing Scenario Functions...
-----------------------------------------


-- functions to call at beginning of each turn
function ScenarioOnNewTurn()

	-- InitializePacific1942rojects()
end

-- functions to call at end of each turn
function ScenarioOnEndTurn()
	SaveAllTable()
end

-- functions to call at end of 1st turn
function ScenarioOnFirstTurnEnd()
	SaveAllTable()
end

-- functions to call ASAP after loading this file when game is launched for the first time
function ScenarioOnFirstTurn()
end

-- functions to call ASAP after loading a saved game
function ScenarioOnLoading()
	--GameEvents.PlayerCanCreate.Add(PlayerEuro1940ProjectRestriction)
	--SetAIStrategicValues()
end

-- functions to call after game initialization (DoM screen button "Begin your journey" appears)
function ScenarioOnGameInit()
	--GameEvents.PlayerCanCreate.Add(PlayerEuro1940ProjectRestriction)
	--SetAIStrategicValues()
	BalanceScenario()
end

-- functions to call after game initialization (DoM screen button "Continue your journey" appears) after loading a saved game
function ScenarioOnGameInitReloaded()
end

-- functions to call after entering game (DoM screen button pushed for a new game or reloading)
function ScenarioOnEnterGame()
	DoInitPacific1942UI()
	GameEvents.CityCaptureComplete.Add(	UpdatePacific1942ScoreString )
end