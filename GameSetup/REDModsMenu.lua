----------------------------------------------------
-- Mods Menu
----------------------------------------------------
print("-------------------------------------")
print("Loading Mods Menu...")
print("-------------------------------------")

include( "InstanceManager" );
include ("RED_Version" )
include ("RedUtils")

g_InstanceManager = InstanceManager:new( "ModInstance", "Label", Controls.ModsStack );

g_FirstInitialization = true
g_TotalTime = 0
g_PreviousSecond = 0
g_Packages = {}

g_BuildMinimumVersion	= 403694	-- minimal game build
g_NumBackground			= 11		-- number of available background screens to chose from
g_DLL_MinimumVersion	= 3			-- DLL minimum version to be used
g_Data_MinimumVersion	= 1			-- DataFile minimum version to be used
g_WarningLink			= "http://forums.civfanatics.com/showthread.php?t=472345"

g_AuthorizedModList = {
	"1fa4b768-ae75-4260-b727-6a2becc6530e", -- R.E.D. WWII Edition
	"2ac737a3-00a3-4d33-9b88-714266967b12", -- R.E.D. WWII Data Files
	"a7761578-3a65-475a-a1aa-9a9699660415", -- R.E.D. WWII Audio Files
	"57402d0e-06cb-4e71-831c-10ccd40e9572", -- R.E.D. Quick Combat
	"5739c052-e089-4c19-9f3b-73b5363d4f5c", -- Fast Moves
	"a26ba0d5-2926-4fb2-af6e-b865d69475ea", -- R.E.D. Xtrem for WWII
	"142ec258-8dba-4ac8-9101-4c475bf85351", -- LiveTuner - Icon Viewer
	"139c327c-57ec-4c30-afb1-8ca41998492d", -- LiveTuner - Texture Viewer
	"2896c6d4-0273-4527-813b-b9ab58f0b95e", -- R.E.D. DLL
	"1f0a153b-26ae-4496-a2c0-a106d9b43c95", -- UI - Promotion Tree
	"170c8ed1-b516-4fe2-b571-befeac39d220", -- I.G.E. - Ingame Editor
	"8affec94-2588-4fe9-a87a-703a64bdf53c", -- Unit Tester
	"c70dee73-8179-4a19-a3e5-1d931908ff43", -- MultiPlayer ModsPack Maker
	"5ffb233b-d9f3-4ec4-8fae-b8705b40c413", -- R.E.D. WWII 3D Leaders
	"0ea285a9-861d-4341-ad48-632358e5eb5d", -- RED WW II German Soundtrack 
	"1fd60d1a-34e8-4fd8-8fc5-ffef8407da66", -- RED WW II Russian Soundtrack
	"afce9c94-fecc-485e-9f62-0c24b9848993", -- RED Pacific
}


local bNeedModUpdate = false
local bNeedDLCUpdate = false

local RED_WWII_ID = "1fa4b768-ae75-4260-b727-6a2becc6530e";
local latestREDVersion = Modding.GetLatestInstalledModVersion(RED_WWII_ID);
local modUserData = Modding.OpenUserData(RED_WWII_ID, latestREDVersion);
modUserData.SetValue("forceModActivation", 0); -- make sure this is not set to 1 BEFORE the override files are installed, it could force mods loading without asking (once)

--------------------------------------------------
-- Navigation Routines (Installed,Online,Back)
--------------------------------------------------
function NavigateBack()
	--[[
	ContextPtr:LookUpControl("/FrontEnd/AtlasLogo"):SetTextureAndResize( "CivilzationVAtlas.dds" ) -- restore civ5 background
	UIManager:DequeuePopup( ContextPtr );
	--]]
	-- Exit game instead of returning to mod menu as it doesn't unload VFS override files...
    --Events.UserRequestClose();


	UIManager:SetUICursor( 1 );
	Modding.DeactivateMods();
	UIManager:DequeuePopup( ContextPtr );
	UIManager:SetUICursor( 0 );
	
	Events.SystemUpdateUI( SystemUpdateUIType.RestoreUI, "MainMenu" );
end

----------------------------------------------------
-- UI Event Handlers
----------------------------------------------------
function OnSinglePlayerClick()
	--UIManager:QueuePopup( Controls.ScenarioMod, PopupPriority.ScenarioMod ); -- what's wrong here ?
	--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/ScenarioMod/"):SetHide(false) -- even if in VFS, the context is ModsMenu ?
	Controls.ScenarioMod:SetHide(false)

	Controls.ModsMenuGrid:SetHide(true)
end
Controls.SinglePlayerButton:RegisterCallback(Mouse.eLClick, OnSinglePlayerClick);
----------------------------------------------------
function OnLoadSingleGameButtonClick()
	--UIManager:QueuePopup( Controls.SingleLoadScreen, PopupPriority.SingleLoadScreen );
	--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/SingleLoadScreen/"):SetHide(false)
	Controls.SingleLoadScreen:SetHide(false)

	Controls.ModsMenuGrid:SetHide(true)
end
Controls.LoadSingleGameButton:RegisterCallback(Mouse.eLClick, OnLoadSingleGameButtonClick);
----------------------------------------------------------------------
----------------------------------------------------
function OnLoadHotseatGameButtonClick()
	--UIManager:QueuePopup( Controls.SingleLoadScreen, PopupPriority.SingleLoadScreen );
	--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/HotSeatLoadScreen/"):SetHide(false)
	Controls.HotSeatLoadScreen:SetHide(false)

	Controls.ModsMenuGrid:SetHide(true)
end
Controls.LoadHotseatGameButton:RegisterCallback(Mouse.eLClick, OnLoadHotseatGameButtonClick);
----------------------------------------------------------------------
----------------------------------------------------
function OnMultiPlayerClick()
	UIManager:QueuePopup( Controls.ModMultiplayerSelectScreen, PopupPriority.ModMultiplayerSelectScreen );
end
Controls.MultiPlayerButton:RegisterCallback(Mouse.eLClick, OnMultiPlayerClick);
----------------------------------------------------------------------
Controls.BackButton:RegisterCallback(Mouse.eLClick, NavigateBack);


--------------------------------------------------
-- Show/Hide Handler
--------------------------------------------------
ContextPtr:SetShowHideHandler(function(isHiding)
	if(not isHiding) then

		--Initialize()
		modUserData.SetValue("forceModActivation", 0);

		local supportsSinglePlayer = Modding.AllEnabledModsContainPropertyValue("SupportsSinglePlayer", 1);
		local supportsMultiplayer = Modding.AllEnabledModsContainPropertyValue("SupportsMultiplayer", 1);
		
		--Controls.SinglePlayerButton:SetDisabled(not supportsSinglePlayer);
		--Controls.MultiPlayerButton:SetDisabled(not supportsMultiplayer);
		
		--if(supportsSinglePlayer and not supportsMultiplayer) then
			--OnSinglePlayerClick();
		--elseif(supportsMultiplayer and not supportsSinglePlayer) then
			--OnMultiPlayerClick();
		--end
		
		if g_FirstInitialization then
			g_InstanceManager:ResetInstances();
		
			local mods = Modding.GetEnabledModsByActivationOrder();
		
			if(#mods == 0) then
				Controls.ModsInUseLabel:SetHide(true);
			else
				Controls.ModsInUseLabel:SetHide(false);
				for i,v in ipairs(mods) do
					local displayName = Modding.GetModProperty(v.ModID, v.Version, "Name");
					local displayNameVersion = ""
					local sToolTip = ""
					if IsModAuthorized (v.ModID) then
						displayNameVersion = string.format("[ICON_BULLET] %s (v. %i)", displayName, v.Version);
						local modDetails = Modding.GetInstalledModDetails(v.ModID, v.Version)
						sToolTip = string.format(modDetails.Teaser)
					else
						displayNameVersion = string.format("[ICON_BULLET][COLOR_RED] %s (v. %i)[ENDCOLOR]", displayName, v.Version)
						sToolTip = "Not in the list of authorized mods."
						Modding.DisableMod(v.ModID, v.Version)
					end
					local listing = g_InstanceManager:GetInstance();
					listing.Label:SetText(displayNameVersion);
					listing.Label:SetToolTipString(sToolTip);
				end
			end
			g_FirstInitialization = false
		end
	end
end);

--------------------------------------------------
-- Input Handler
--------------------------------------------------
ContextPtr:SetInputHandler( function(uiMsg, wParam, lParam)

	if uiMsg == KeyEvents.KeyDown then
		if wParam == Keys.VK_ESCAPE then
			NavigateBack();
		end
	end

	return true;
end);

Controls.MultiPlayerButton:SetHide(true);

function CompareTime(time1, time2)
	
	--First, convert the table into a single numerical value
	-- YYYYMMDDHH
	function convert(t)
		local r = 0;
		if(t.year ~= nil) then
			r = r + t.year * 1000000
		end
		
		if(t.month ~= nil) then
			r = r + t.month * 10000
		end
		
		if(t.day ~= nil) then
			r = r + t.day * 100
		end
		
		if(t.hour ~= nil) then
			r = r + t.hour;
		end
		
		return r;
	end
	
	local ct1 = convert(time1);
	local ct2 = convert(time2);
	
	if(ct1 < ct2) then
		return -1;
	elseif(ct1 > ct2) then
		return 1;
	else
		return 0;
	end
end

function Initialize()
	local bDebug = false
	modUserData.SetValue("forceModActivation", 0);

	-- "back" button lead to exit game instead of returning to mod menu as it doesn't unload VFS override files...
	--Controls.BackButton:LocalizeAndSetText("TXT_KEY_MENU_EXIT_TO_WINDOWS")

	
	Dprint("- Initialize mandatory Game Option...", bDebug) -- but maybe to soon for PreGame here ?
	PreGame.SetGameOption("GAMEOPTION_DOUBLE_EMBARKED_DEFENSE_AGAINST_AIR", 1)
	PreGame.SetGameOption("GAMEOPTION_FREE_PLOTS", 1)
	PreGame.SetGameOption("GAMEOPTION_NO_MINOR_DIPLO_SPAM", 1)
	PreGame.SetGameOption("GAMEOPTION_CAN_STACK_IN_CITY", 1)
	PreGame.SetGameOption("GAMEOPTION_CAN_ENTER_FOREIGN_CITY", 1)
	--PreGame.SetGameOption("GAMEOPTION_UNIT_LIMIT_FIX", 1) -- In SQL rules
	PreGame.SetGameOption("GAMEOPTION_REBASE_IN_FRIENDLY_CITY", 1)

	Dprint("-------------------------------------", bDebug)
	Dprint("Game compatibility checks...", bDebug)
	Dprint("-------------------------------------", bDebug)
	
	local gameVersion = UI.GetVersionInfo()
	Dprint ("game version : " .. gameVersion , bDebug)

	local i1 = string.find( gameVersion, " " )
	local i2 = string.find( gameVersion, ")" )
	local buildVersion = tonumber(string.sub(gameVersion, i1+2, i2-1))
	Dprint ("build version : " .. buildVersion, bDebug)

	Dprint ("mod version : " .. g_RED_Version, bDebug)

	local bWrongGameVersion = false
	if buildVersion < g_BuildMinimumVersion then
		print (" - Game need to be updated...")
		bWrongGameVersion = true
	end
	
	Dprint("-------------------------------------", bDebug)
	Dprint("Check DLC compatibility list...", bDebug)
	Dprint("-------------------------------------", bDebug)

	local MongolDlcID = "293C1EE3-1176-44F6-AC1F-59663826DE74" -- Mongol DLC ID	
	local RedWW2DataFilesModID = "2ac737a3-00a3-4d33-9b88-714266967b12" -- R.E.D. WWII Datafile

	local bMongolDlcActive = ContentManager.IsActive(MongolDlcID, ContentType.GAMEPLAY)
	bNeedModUpdate = false
	bNeedDLCUpdate = false


	-- remove all DLC that are not required (for savegame compatibility)
	local packageIDs = ContentManager.GetAllPackageIDs()
	g_Packages = {}
	
	Dprint("Active DLCs :", bDebug)
	for i, id in ipairs(packageIDs) do
		
		local bActive = ContentManager.IsActive(id, ContentType.GAMEPLAY)
		local sDescription = Locale.Lookup(ContentManager.GetPackageDescription(id))

		if(not ContentManager.IsUpgrade(id)) then
			if id ~= MongolDlcID then
				if bActive then
					Dprint (" - " .. sDescription .. " : Not needed, marked for deactivation...", bDebug)
					table.insert(g_Packages, {
						id,
						ContentType.GAMEPLAY,
						false
					});
				end		
			end
		elseif bActive then
			Dprint (" - " .. sDescription .. " : Active...", bDebug)
		end
    end	    
	bNeedDLCUpdate = (#g_Packages > 0)


	if not bMongolDlcActive then
		Dprint (" - Mongol DLC inactive, marked for activation...", bDebug)
		table.insert(g_Packages, {MongolDlcID, ContentType.GAMEPLAY, true})
		bNeedDLCUpdate = true
	else		
		Dprint (" - Mongol DLC is loaded", bDebug)
	end
	
	Dprint("-------------------------------------", bDebug)
	Dprint("Check Mods compatibility list...", bDebug)
	Dprint("-------------------------------------", bDebug)	

	
	local bDataFile = false -- set to true if the data file is loaded
	local bDataVersion = false -- set to true if the loaded datafile version is correct
	local dataNumVersion = 0
	local iNumUnauthorizedMods = 0

	-- list mods
	Dprint("Active mods :", bDebug)
	local unsortedInstalledMods = Modding.GetInstalledMods()
	for key, modInfo in pairs(unsortedInstalledMods) do
		if modInfo.Enabled then
			if (modInfo.Name) then
				-- Don't allow another mod to be activated, let's help clean debugging
				if not IsModAuthorized ( modInfo.ID ) then 				
					Dprint (" - " .. modInfo.Name .. " (v." .. modInfo.Version ..") : Not authorised, marked for deactivation...", bDebug)
					iNumUnauthorizedMods = iNumUnauthorizedMods + 1
					--Modding.DisableMod(modInfo.ID, modInfo.Version)
					bNeedModUpdate = true
				else				
					Dprint (" - " .. modInfo.Name .. " (v." .. modInfo.Version ..")", bDebug)
					if (modInfo.ID == RedWW2DataFilesModID) then
						bDataLoaded = true
						dataNumVersion = modInfo.Version
						if (modInfo.Version >= g_Data_MinimumVersion) then
							bDataVersion = true
						end
					end
				end
			end
		end
	end
	if g_FirstInitialization then
		Dprint("", bDebug)
		Dprint("Deactivated mods :", bDebug)
		local unsortedInstalledMods = Modding.GetInstalledMods()
		for key, modInfo in pairs(unsortedInstalledMods) do
			if not (modInfo.Enabled) then
				if (modInfo.Name) then
					Dprint (" - " .. modInfo.Name .. " (v." .. modInfo.Version ..")", bDebug)
				end
			end
		end			
	end

		
	Dprint("- Initializing WWII background...", bDebug)

	local randNum = math.random(1, g_NumBackground)
	local background = "Background_" .. tostring(randNum) .. ".dds"

	-- Special date background...
	local special = {
		start = {
			year = 2012,
			month = 12,
			day = 24,
			hour = 1,
		},			
		stop = {
			year = 2012,
			month = 12, 
			day = 25,
			hour = 23,
		},			
		background = "special.dds"

	}
	local currentDate = os.date("!*t");
	if(CompareTime(currentDate, special.start) >= 0 and CompareTime(special.stop, currentDate) >= 0) then
			background = special.background
	end

	if not bDataVersion then -- Use default texture if data file is not correct !
		background = "_background.dds"
	end

	Dprint("- Set texture to " .. background, bDebug)

	ContextPtr:LookUpControl("/FrontEnd/AtlasLogo"):SetTextureAndResize( background )
	--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/PreLoading/LoadingImage"):SetTextureAndResize( background )

	if bDataVersion then -- show logo only if correct version of data file is loaded
		--ContextPtr:LookUpControl("/FrontEnd/MainMenu/Civ5Logo"):SetTextureAndResize( "RED_WWII_Logo.dds" )
		--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/Civ5Logo"):SetTextureAndResize( "RED_WWII_Logo.dds" )

		--Controls.Civ5Logo:SetTextureAndResize( "RED_WWII_Logo.dds" )
		Controls.Civ5Logo:SetHide( true ) -- Until we have a semi-transparent good-looking logo...
	else
		--ContextPtr:LookUpControl("/FrontEnd/MainMenu/Civ5Logo"):SetHide( true )
		--ContextPtr:LookUpControl("/FrontEnd/MainMenu/ModsEULAScreen/ModsBrowser/ModsMenu/Civ5Logo"):SetHide( true )
		Controls.Civ5Logo:SetHide( true ) 
	end
	
	-- Check if all correct mod components are loaded
	local bValid = true
	local warningHelp = ''
	local warningString = ''	

	if bNeedModUpdate then		
		print("ERROR: Unauthorized Mod(s) !")
		warningHelp = "[COLOR_RED]Configuration Error:[NEWLINE]" .. tostring(iNumUnauthorizedMods) .." Unauthorized Mod(s) ![ENDCOLOR][NEWLINE]Marked for deactivation in mods menu.[NEWLINE]You need to exit and reload R.E.D."
		warningString = "Click Here for Main Menu."
		bValid = false
	end

	if bNeedDLCUpdate then
		print("ERROR: Need to update DLC !")
		warningHelp = "[COLOR_RED]Configuration Error:[NEWLINE]Some DLCs are not needed[ENDCOLOR][NEWLINE]Marked for deactivation in main menu.[NEWLINE]You need to exit and reload R.E.D."
		warningString = "Click Here for Main Menu."
		bValid = false
	end

	if not bMongolDlcActive then
		print("ERROR: Mongol's DLC is needed !")
		warningHelp = "[COLOR_RED]Configuration Error:[NEWLINE]The Mongol DLC is required[ENDCOLOR][NEWLINE]Marked for reactivation in main menu.[NEWLINE]You need to exit and reload R.E.D."
		warningString = "Click Here for Main Menu."
		bValid = false
	end

	if not GameDefines.DLL_RED_VANILLA then
		print("ERROR: Custom DLL not found !")
		warningHelp = "[COLOR_RED]Installation Error:[NEWLINE]R.E.D. DLL is not active ![ENDCOLOR]"
		warningString = "Click for installation instructions."
		bValid = false
	elseif GameDefines.DLL_RED_VANILLA < g_DLL_MinimumVersion then
		print("ERROR: RED DLL deprecated !")
		warningHelp = "[COLOR_RED]Installation Error:[NEWLINE]Obsolete R.E.D. DLL ![ENDCOLOR][NEWLINE]v." .. tostring(GameDefines.DLL_RED_VANILLA) .." detected.[NEWLINE]v." .. tostring(g_DLL_MinimumVersion) .." needed."
		warningString = "Click for installation instructions."
		bValid = false
	end

	if not bDataLoaded then
		print("ERROR: DataFile not found !")
		warningHelp = "[COLOR_RED]Installation Error:[NEWLINE]R.E.D. Data Files is not active ![ENDCOLOR]"
		warningString = "Click for installation instructions."
		bValid = false
	elseif not bDataVersion then
		print("ERROR: DataFile deprecated !")
		warningHelp = "[COLOR_RED]Installation Error:[NEWLINE]Obsolete R.E.D. Data Files ![ENDCOLOR][NEWLINE]v." .. tostring(dataNumVersion) .." detected.[NEWLINE]v." .. tostring(g_Data_MinimumVersion) .." needed."
		warningString = "Click here for installation instructions."
		bValid = false
	end

	if bWrongGameVersion then
		print("ERROR: Wrong version of the game !")
		warningHelp = "[COLOR_RED]Installation Error:[NEWLINE]Wrong game version ![ENDCOLOR][NEWLINE]Build #" .. tostring(buildVersion) .." detected.[NEWLINE]Update Civ5 or use Windows version."
		warningString = "Click for installation instructions."
		bValid = false
	end

	if not bValid then
		Controls.WarningTitle:SetText(warningHelp)
		Controls.WarningButton:SetText(warningString)
		Controls.WarningGrid:SetHide(false)
		if bNeedDLCUpdate then
			Controls.WarningButton:RegisterCallback(Mouse.eLClick, OnDeactivateDLCs)
			Controls.BackButton:RegisterCallback(Mouse.eLClick, OnDeactivateDLCs)
		elseif bNeedModUpdate then
			Controls.WarningButton:RegisterCallback(Mouse.eLClick, OnDeactivateMods)
			Controls.BackButton:RegisterCallback(Mouse.eLClick, OnDeactivateMods)
		else
			Controls.WarningButton:RegisterCallback(Mouse.eLClick, function()	Steam.ActivateGameOverlayToWebPage(g_WarningLink); end)
		end
		Controls.LoadSingleGameButton:SetDisabled(true)
		Controls.LoadHotseatGameButton:SetDisabled(true)
		Controls.SinglePlayerButton:SetDisabled(true)
	else
		Controls.WarningGrid:SetHide(true)
	end

	Dprint("-------------------------------------", bDebug)
	--g_FirstInitialization = false
end

function IsModAuthorized (id)
	local bCheck = false
	for i, modID in pairs(g_AuthorizedModList) do
		if id == modID then
			bCheck = true
		end
	end
	return bCheck
end

function OnDeactivateMods()
	local bDebug = false
	Dprint("-------------------------------------", bDebug)
	Dprint("Updating Mods...", bDebug)
	Dprint("-------------------------------------", bDebug)
	modUserData.SetValue("forceModActivation", 1);
	UIManager:SetUICursor(1)
	Modding.DeactivateMods()
	UIManager:SetUICursor(0)
	Events.SystemUpdateUI( SystemUpdateUIType.RestoreUI, "MainMenu" );
end


function OnDeactivateDLCs()
	local bDebug = false
	Dprint("-------------------------------------", bDebug)
	Dprint("Updating DLCs...", bDebug)
	Dprint("-------------------------------------", bDebug)
	modUserData.SetValue("forceModActivation", 1);
	UIManager:SetUICursor(1);
	ContentManager.SetActive(g_Packages);
	UIManager:SetUICursor(0);
	Events.SystemUpdateUI( SystemUpdateUIType.RestoreUI, "MainMenu" );
end

function MenuTimer(tickCount, timeIncrement)
	local bDebug = false
	g_TotalTime = g_TotalTime + timeIncrement
	local iWaitTime = 10
	local iTimeLeft = iWaitTime
	if g_TotalTime > g_PreviousSecond then
		g_PreviousSecond = math.ceil(g_TotalTime)
		iTimeLeft = iWaitTime - g_PreviousSecond		
		if (bNeedModUpdate or bNeedDLCUpdate) and iTimeLeft > 0 then
			Dprint("- Auto-Exit in ".. tostring(iTimeLeft) .. " seconds...", bDebug)
			Controls.BackButton:SetText("Auto-Exit in ".. tostring(iTimeLeft) .. " seconds...")
		end
	end
	if g_TotalTime > iWaitTime then
		-- Deactivate unauthorized mods or not needed DLCs

		if bNeedDLCUpdate then
			Dprint("-------------------------------------", bDebug)
			Dprint("Updating DLCs...", bDebug)
			Dprint("-------------------------------------", bDebug)
			modUserData.SetValue("forceModActivation", 1);
			UIManager:SetUICursor(1);
			ContentManager.SetActive(g_Packages);
			UIManager:SetUICursor(0);
			Events.SystemUpdateUI( SystemUpdateUIType.RestoreUI, "MainMenu" );

		elseif bNeedModUpdate then		
			Dprint("-------------------------------------", bDebug)
			Dprint("- Updating MODs...", bDebug)
			Dprint("-------------------------------------", bDebug)
			modUserData.SetValue("forceModActivation", 1);
			UIManager:SetUICursor(1)
			Modding.DeactivateMods()
			UIManager:SetUICursor(0)
			Events.SystemUpdateUI( SystemUpdateUIType.RestoreUI, "MainMenu" );
		end
	end
end
Events.LocalMachineAppUpdate.Add(MenuTimer)

Initialize()