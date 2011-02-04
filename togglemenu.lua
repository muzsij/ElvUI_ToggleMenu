-- By Foof & Hydra at Tukui.org
-- modified by Gorlasch
-- modified by HyPeRnIcS
local E, C, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales

local buttonwidth = E.Scale(190)
local buttonheight = E.Scale(20)
local defaultframelevel = 0
local addonToggleOnly = true -- Sets the default value for the addon menu (true = toggle-only, false = enhanced version)
local maxMenuEntries = 30 -- Maximum number of menu entries per column (0 - unlimited number)

local addons = {
	["Recount"] = function()
		ToggleFrame(Recount.MainWindow)
		Recount.RefreshMainWindow()
	end,
	
	["Skada"] = function()
		Skada:ToggleWindow()
	end,
	
	["GatherMate2"] = function()
		GatherMate2.db.profile["showMinimap"] = not GatherMate2.db.profile["showMinimap"]
		GatherMate2.db.profile["showWorldMap"] = not GatherMate2.db.profile["showWorldMap"]
		GatherMate2:GetModule("Config"):UpdateConfig()
	end,
	
	["AtlasLoot"] = function()
		ToggleFrame(AtlasLootDefaultFrame)
	end,
	
	["AuctionProfitMaster"] = function()
		RunSlashCmd("/apm config")
	end,

	["Omen"] = function()
		ToggleFrame(Omen.Anchor)
	end,
	
	["DXE"] = function()
		_G.DXE:ToggleConfig()
	end,
	
	["DBM-Core"] = function()
		DBM:LoadGUI()
	end,
	
	["TinyDPS"] = function()
		ToggleFrame(tdpsFrame)
	end,
	
	["Tukui_ConfigUI"] = function()
		SlashCmdList.CONFIG()
	end,

	["Panda"] = function()
		ToggleFrame(PandaPanel)
	end,

	["PallyPower"] = function()
		ToggleFrame(PallyPowerFrame)
	end,

	["ACP"] = function()
		ToggleFrame(ACP_AddonList)
	end,

	["ScrollMaster"] = function()
		LibStub("AceAddon-3.0"):GetAddon("ScrollMaster").GUI:OpenFrame(1)
	end,

	["PugLax"] = function()
		RunSlashCmd("/puglax")
	end,

	["RaidAchievement"] = function()
		RA_MinimapButton_OnClick()	
	end,

	["clcInfo"] = function()
		RunSlashCmd("/clcinfo")
	end,

	
}

function RunSlashCmd(cmd)
  local slash, rest = cmd:match("^(%S+)%s*(.-)$")
  for name, func in pairs(SlashCmdList) do
     local i, slashCmd = 1
     repeat
        slashCmd, i = _G["SLASH_"..name..i], i + 1
        if slashCmd == slash then
           return true, func(rest)
        end
     until not slashCmd
  end
end 

local MenuBG = CreateFrame("Frame", "ElvTMenuBackground", UIParent)
E.CreatePanel(MenuBG, buttonwidth + E.Scale(8), buttonheight * 5 + E.Scale(18), "TOPRIGHT", TukuiMinimap, "TOPLEFT", E.Scale(-5), 0)
E.CreateShadow(MenuBG)
E.SetTransparentTemplate(MenuBG)
MenuBG:SetFrameLevel(defaultframelevel+0)
MenuBG:SetFrameStrata("HIGH")
MenuBG:Hide()

 
local AddonBG = CreateFrame("Frame", "ElvTMenuAddOnBackground", UIParent)
E.CreatePanel(AddonBG, buttonwidth + E.Scale(8), 1, "TOPRIGHT", MenuBG, "TOPRIGHT", 0, 0)
E.CreateShadow(AddonBG)
E.SetTransparentTemplate(AddonBG)
AddonBG:SetFrameLevel(defaultframelevel+0)
AddonBG:SetFrameStrata("HIGH")
AddonBG:Hide()

function E.ToggleMenu_Toggle()
	ToggleFrame(ElvTMenuBackground)
	if ElvTMenuAddOnBackground:IsShown() then ElvTMenuAddOnBackground:Hide() end
end

local Text = nil

-- Integrate the menu into the panel
local classcolor = RAID_CLASS_COLORS[E.myclass]
local hovercolor = {classcolor.r,classcolor.g,classcolor.b,1}

local MinimapButton = CreateFrame("Button","ElvTMenuMinimapButton",Minimap)
E.CreatePanel(MinimapButton, E.Scale(35), E.Scale(20), "LEFT", Minimap, "LEFT", E.Scale(2),E.Scale(2))
MinimapButton:EnableMouse(true)
MinimapButton:RegisterForClicks("AnyUp")
MinimapButton:SetFrameStrata("HIGH")
MinimapButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b)
		MinimapButton:Show()
	end)
MinimapButton:HookScript("OnLeave", function(self) 
		self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) 
		MinimapButton:Hide()
	end)
MinimapButton:SetScript("OnMouseDown", function() E.ToggleMenu_Toggle() end)
MinimapButton:Hide()
local MinimapButton_text = MinimapButton:CreateFontString(nil,"LOW")
MinimapButton_text:SetFont(C["media"].font,C["general"].fontscale,"OUTLINE")
MinimapButton_text:SetPoint("Center",E.Scale(1),E.Scale(-1))
MinimapButton_text:SetJustifyH("CENTER")
MinimapButton_text:SetJustifyV("MIDDLE")
MinimapButton_text:SetText("Menu")

Minimap:HookScript("OnEnter", function() 	
		MinimapButton:Show()
	end)

Minimap:HookScript("OnLeave", function() 	
		MinimapButton:Hide()
	end)
	
local menu = CreateFrame("Button", "ElvTMenuMain", MenuBG) -- Main buttons
menu.itemcount = 0

function E.TMenuAddMainMenuItem(buttontext, buttonfunc)
	local menu = _G["ElvTMenuMain"]
	menu.itemcount = menu.itemcount+1
	local i = menu.itemcount
	menu[i] = CreateFrame("Button", "ElvTMenuMain"..i, MenuBG)
	E.CreatePanel(menu[i], buttonwidth, buttonheight, "TOP", MenuBG, "TOP", 0, E.Scale(-4))
	menu[i]:SetFrameLevel(defaultframelevel+1)
	menu[i]:SetFrameStrata("HIGH")
	if i == 1 then
		menu[i]:SetPoint("TOP", MenuBG, "TOP", 0, E.Scale(-4))
	else
		menu[i]:SetPoint("TOP", menu[i-1], "BOTTOM", 0, E.Scale(-4))
	end
	menu[i]:EnableMouse(true)
	menu[i]:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
	menu[i]:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
	menu[i]:RegisterForClicks("AnyUp")
	local Text = menu[i]:CreateFontString(nil, "LOW")
	Text:SetFont(C.media.font, C.general.fontscale)
	Text:SetPoint("CENTER", menu[i], 0, 0)
	Text:SetText(buttontext)
	menu[i]:SetScript("OnClick", buttonfunc)
	_G["ElvTMenuBackground"]:SetHeight(buttonheight * menu.itemcount + E.Scale((menu.itemcount+1)*4))
end

E.TMenuAddMainMenuItem("Close Menu",function() MenuBG:Hide() ElvTMenuAddOnBackground:Hide() end)
E.TMenuAddMainMenuItem("AddOns", function() ToggleFrame(ElvTMenuAddOnBackground); ToggleFrame(ElvTMenuBackground); end)
E.TMenuAddMainMenuItem("ElvUI Config", function() RunSlashCmd("/ec") end)
E.TMenuAddMainMenuItem("Calendar", function() ToggleCalendar() end)
E.TMenuAddMainMenuItem("Reload UI", function() ReloadUI() end)
E.TMenuAddMainMenuItem("KeyRing", function() OpenAllBags(); ToggleKeyRing() end)
E.TMenuAddMainMenuItem("Move UI Objects", function() RunSlashCmd("/moveui") end)
E.TMenuAddMainMenuItem("Farm mode", function() RunSlashCmd("/farmmode") end)
E.TMenuAddMainMenuItem("DPS Layout", function() RunSlashCmd("/dps") end)
E.TMenuAddMainMenuItem("Heal Layout", function() RunSlashCmd("/heal") end)

local returnbutton = CreateFrame("Button", "ElvTAddonMenuReturnButton", AddonBG)
E.CreatePanel(returnbutton, buttonwidth, buttonheight, "TOPLEFT", AddonBG, "TOPLEFT", E.Scale(4), E.Scale(-4))
returnbutton:EnableMouse(true)
returnbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
returnbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
returnbutton:RegisterForClicks("AnyUp")
returnbutton:SetFrameLevel(defaultframelevel+1)
returnbutton:SetFrameStrata("HIGH")
Text = returnbutton:CreateFontString(nil, "LOW")
Text:SetFont(C.media.font, C.general.fontscale)
Text:SetPoint("CENTER", returnbutton, 0, 0)
Text:SetText("Return")
returnbutton:SetScript("OnMouseUp", function() ToggleFrame(ElvTMenuAddOnBackground); ToggleFrame(ElvTMenuBackground); end)

-- new stuff

local expandbutton = CreateFrame("Button", "ElvTAddonMenuExpandButton", AddonBG)
E.CreatePanel(expandbutton, buttonwidth, buttonheight/2, "BOTTOM", AddonBG, "BOTTOM", 0, E.Scale(4))
expandbutton:EnableMouse(true)
expandbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
expandbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
expandbutton:RegisterForClicks("AnyUp")
expandbutton:SetFrameLevel(defaultframelevel+1)
expandbutton:SetFrameStrata("HIGH")
Text = expandbutton:CreateFontString(nil, "LOW")
Text:SetFont(C.media.font, C.general.fontscale)
Text:SetPoint("CENTER", expandbutton, 0, 0)
Text:SetText("v")
expandbutton.txt = Text

local collapsedAddons = {
	["DBM"]      = "DBM-Core",
	["ElvUI"]    = "ElvUI",
}

local addonInfo
local lastMainAddon = "XYZNonExistantDummyAddon"
local lastMainAddonID = 0
if not addonInfo then
	addonInfo = {{}}
	for i = 1,GetNumAddOns() do
		name,title,_, enabled, _, _, _ = GetAddOnInfo(i)
		if(name and enabled) then
			addonInfo[i] = {["enabled"] = true,  ["is_main"] = false, collapsed = true, ["parent"] = i}
		else
			addonInfo[i] = {["enabled"] = false, ["is_main"] = false, collapsed = true, ["parent"] = i}
		end
		-- check special addon list first
		local addonFound = false
		for key, value in pairs(collapsedAddons) do
			if strsub(name, 0, strlen(key)) == key then
				addonFound = true
				if name == value then
					lastMainAddon = name
					lastMainAddonID = i
					addonInfo[i].is_main = true
				else
					addonInfo[i].parent = lastMainAddonID
					for j = 1,GetNumAddOns() do
						name_j, _, _, _, _, _, _ = GetAddOnInfo(j)
						if name_j == value then
							addonInfo[i].parent = j
						end
					end
				end
			end
		end
		-- collapse addons with common prefix
		if not addonFound then
			if strsub(name, 0, strlen(lastMainAddon)) == lastMainAddon then
				addonInfo[lastMainAddonID].is_main = true
				addonInfo[i].parent = lastMainAddonID
			else
				lastMainAddon = name
				lastMainAddonID = i
			end
		end
	end
end

local addonmenuitems = {};

local function addonEnableToggle(self, i)
	local was_enabled = addonInfo[i].enabled
	for j = 1,GetNumAddOns() do
		if ((addonInfo[j].parent == i and addonInfo[i].collapsed) or (i==j and not addonInfo[addonInfo[i].parent].collapsed)) then
			if was_enabled then
				DisableAddOn(j)
				addonmenuitems[j]:SetBackdropColor(unpack(C.media.bordercolor))
			else
				EnableAddOn(j)
				addonmenuitems[j]:SetBackdropColor(unpack(C.media.backdropcolor))
			end
			addonInfo[j].enabled = not was_enabled
		end
	end
end

local function addonFrameToggle(self, i)
	local name, _,_, _, _, _, _ = GetAddOnInfo(i)
	if addons[name] then
		if IsAddOnLoaded(i) then
			addons[name]()
		end
	end
end


local function refreshAddOnMenu()
	local menusize = 1
	for i = 1,GetNumAddOns() do
		local name, _,_, _, _, _, _ = GetAddOnInfo(i)
		if (addonInfo[i].is_main or (addonInfo[i].parent == i) or not addonInfo[addonInfo[i].parent].collapsed) then
			if (not addonToggleOnly or (addons[name] and IsAddOnLoaded(i))) then
				menusize = menusize + 1
			end
		end
	end
	if maxMenuEntries and maxMenuEntries > 0 then
		menuwidth  = ceil(menusize/maxMenuEntries)
	else
		menuwidth  = 1
	end
	menuheigth = ceil(menusize/menuwidth)

	local lastMenuEntryID = 0
	menusize = 1
	for i = 1,GetNumAddOns() do
		local name, _,_, _, _, _, _ = GetAddOnInfo(i)
		addonmenuitems[i]:Hide()		
		if (addonInfo[i].is_main or (addonInfo[i].parent == i) or not addonInfo[addonInfo[i].parent].collapsed) then
			if (not addonToggleOnly or (addons[name] and IsAddOnLoaded(i))) then
				addonmenuitems[i]:ClearAllPoints()
				if (menusize == 1) then
					addonmenuitems[i]:SetPoint( "TOP", returnbutton, "BOTTOM", 0, E.Scale(-4))
				elseif menusize % menuheigth == 0 then
					addonmenuitems[i]:SetPoint( "LEFT", addonmenuitems[lastMenuEntryID], "RIGHT", E.Scale(4), (menuheigth - 1) * (buttonheight + E.Scale(4)))
				else
					addonmenuitems[i]:SetPoint( "TOP", addonmenuitems[lastMenuEntryID], "BOTTOM", 0, E.Scale(-4))
				end
				addonmenuitems[i]:Show()
				lastMenuEntryID = i
				menusize = menusize + 1
			end
		end
		if addonInfo[i].is_main then
			if addonToggleOnly then
				addonmenuitems[i].expandbtn:Hide()
			else
				addonmenuitems[i].expandbtn:Show()
			end
		end
	end
	AddonBG:SetHeight((menuheigth * buttonheight) + buttonheight/2 + ((menuheigth + 2) * E.Scale(4)))
	AddonBG:SetWidth((menuwidth * buttonwidth) + ((menuwidth + 1) * E.Scale(4)))
	expandbutton:SetWidth((menuwidth * buttonwidth) + ((menuwidth-1) * E.Scale(3)))
end

expandbutton:SetScript("OnMouseUp", function(self) 
	addonToggleOnly = not addonToggleOnly
	if addonToggleOnly then
		self.txt:SetText("v")
		self.txt:SetPoint("CENTER", self, 0, 0)
	else
		self.txt:SetText("^")
		self.txt:SetPoint("CENTER", self, 0, E.Scale(-2))
	end
	refreshAddOnMenu()
end)

for i = 1,GetNumAddOns() do
	local name, _,_, _, _, _, _ = GetAddOnInfo(i)
	addonmenuitems[i] = CreateFrame("Button", "AddonMenu"..i, AddonBG)
	E.CreatePanel(addonmenuitems[i], buttonwidth, buttonheight, "TOP", returnbutton, "BOTTOM", 0, E.Scale(-3))
	addonmenuitems[i]:EnableMouse(true)
	addonmenuitems[i]:RegisterForClicks("AnyUp")
	addonmenuitems[i]:SetFrameLevel(defaultframelevel+1)
	addonmenuitems[i]:SetFrameStrata("HIGH")
	addonmenuitems[i]:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			addonEnableToggle(self, i)
		else
			addonFrameToggle(self, i)
		end				
	end)
	addonmenuitems[i]:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) 
		GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, 0)
		GameTooltip:AddLine("Addon "..name)
		GameTooltip:AddLine("Rightclick to enable or disable (needs UI reload)")			
		if addons[name] then
			if IsAddOnLoaded(i) then
				GameTooltip:AddLine("Leftclick to toggle addon window")
			end
		end
		GameTooltip:Show()
	end)
	addonmenuitems[i]:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor))
		GameTooltip:Hide()
	end)
	if addonInfo[i].enabled then
		addonmenuitems[i]:SetBackdropColor(unpack(C.media.backdropcolor))
	else
		addonmenuitems[i]:SetBackdropColor(unpack(C.media.bordercolor))
	end
	Text = addonmenuitems[i]:CreateFontString(nil, "LOW")
	Text:SetFont(C.media.font, C.general.fontscale)
	Text:SetPoint("CENTER", addonmenuitems[i], 0, 0)
	Text:SetText(select(2,GetAddOnInfo(i)))
	if addonInfo[i].is_main then
		local expandAddonButton = CreateFrame("Button", "AddonMenuExpand"..i, addonmenuitems[i])
		E.CreatePanel(expandAddonButton, buttonheight-E.Scale(6), buttonheight-E.Scale(6), "TOPLEFT", addonmenuitems[i], "TOPLEFT", E.Scale(3), E.Scale(-3))
		expandAddonButton:SetFrameLevel(defaultframelevel+2)
		expandAddonButton:SetFrameStrata("HIGH")
		expandAddonButton:EnableMouse(true)
		expandAddonButton:HookScript("OnEnter", function(self)
			self:SetBackdropBorderColor(unpack(hovercolor))
			GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, 0)
			if addonInfo[i].collapsed then
				GameTooltip:AddLine("Expand "..name.." addons")
			else
				GameTooltip:AddLine("Collapse "..name.." addons")
			end
			GameTooltip:Show()
		end)
		expandAddonButton:HookScript("OnLeave", function(self)
			self:SetBackdropBorderColor(unpack(C.media.bordercolor))
			GameTooltip:Hide()
			end)
		expandAddonButton:RegisterForClicks("AnyUp")
		Text = expandAddonButton:CreateFontString(nil, "LOW")
		Text:SetFont(C.media.font, C.general.fontscale)
		Text:SetPoint("CENTER", expandAddonButton, 0, 0)
		Text:SetText("+")
		expandAddonButton.txt = Text
		expandAddonButton:SetScript("OnMouseUp", function(self)
			addonInfo[i].collapsed = not addonInfo[i].collapsed
			if addonInfo[i].collapsed then
				self.txt:SetText("+")
			else
				self.txt:SetText("-")
			end
			refreshAddOnMenu()
		end)
		addonmenuitems[i].expandbtn = expandAddonButton
	end
	addonmenuitems[i]:Hide()
end

refreshAddOnMenu()
