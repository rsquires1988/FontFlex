--[[
	This is a framework showing how to create a plugin for ElvUI.
	It creates some default options and inserts a GUI table to the ElvUI Config.
	If you have questions then ask in the Tukui lua section: https://www.tukui.org/forum/viewforum.php?f=10
]]

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local FontFlex = E:NewModule('FontFlex', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0'); --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0. We can make use of these later.
local EP = LibStub("LibElvUIPlugin-1.0") -- automatically inserts our GUI tables when ElvUI_Config is loaded.
local LSM = LibStub("LibSharedMedia-3.0")
local ACH = E.Libs.ACH

local addonName, addonTable = ... --See http://www.wowinterface.com/forums/showthread.php?t=51502&p=304704&postcount=2

--Default options
P["FontFlex"] = {
	["Enabled"] = true,
	["Font"] = 'PT Sans Narrow',
	["FontSize"] = 32,
	["FontOutline"] = 'OUTLINE'
}

--Function we can call when a setting changes.
--In this case it just checks if "SomeToggleOption" is enabled. If it is it prints the value of "SomeRangeOption", otherwise it tells you that "SomeToggleOption" is disabled.
function FontFlex:Update()
	local enabled = E.db.FontFlex.Enabled
	local font = E.db.FontFlex.Font
	local fontSize = E.db.FontFlex.FontSize
	local fontOutline = E.db.FontFlex.FontOutline

	if enabled then
		ZoneTextFont:SetFont(LSM:Fetch('font', font), fontSize, fontOutline)
		SubZoneTextFont:SetFont(LSM:Fetch('font', font), fontSize, fontOutline)
		print("CustomZoneTextFont is", font .. ",", fontOutline .. ", Size:", fontSize)
	else
		print("CustomZoneTextFont is disabled")
	end
end

-- function FontFlex:OnZoneChange(event, ...)
-- 	ZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	SubZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	print("Zone changed: " .. GetZoneText())
-- end
--
-- function FontFlex:OnSubZoneChange(event, ...)
-- 	ZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	SubZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	print("Sub Zone changed: " .. GetRealZoneText())
-- end
--
-- function FontFlex:OnIndoorZoneChange(event, ...)
-- 	ZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	SubZoneTextFont:SetFont(LSM:Fetch('font', E.db.FontFlex.Font), E.db.FontFlex.FontSize, E.db.FontFlex.FontOutline)
-- 	print("Indoor Zone changed: " .. GetSubZoneText())
-- end

-- FontFlex:RegisterEvent("ZONE_CHANGED", FontFlex:Update())

--This function inserts our GUI table into the ElvUI Config. You can read about AceConfig here: http://www.wowace.com/addons/ace3/pages/ace-config-3-0-options-tables/
function FontFlex:InsertOptions()
	E.Options.args.FontFlex = {
		order = 100,
		type = "group",
		name = "FontFlex",
		args = {
			Enabled = ACH:Toggle(L["Enabled"], L["Enable custom zone text font"], 1, nil, nil, nil, function() return E.db.FontFlex.Enabled; end, function(_, value) E.db.FontFlex.Enabled = value; FontFlex:Update(); end),
			Font = ACH:SharedMediaFont(L["Font"], nil, 1, nil, function() return E.db.FontFlex.Font; end, function(_, value) E.db.FontFlex.Font = value; FontFlex:Update(); end),
			FontSize = ACH:Range(L["Font Size"], nil, 1, {min = 12, max = 64, step = 1}, nil, function() return E.db.FontFlex.FontSize; end, function(_, value) E.db.FontFlex.FontSize = value; FontFlex:Update(); end),
			FontOutline = ACH:FontFlags(L["Font Outline"], nil, 1, nil, function() return E.db.FontFlex.FontOutline; end, function(_, value) E.db.FontFlex.FontOutline = value; FontFlex:Update(); end),
		},
	}
end

function FontFlex:Initialize()
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addonName, FontFlex.InsertOptions)
	FontFlex:Update()

-- 	FontFlex:Update()
-- 	FontFlex:RegisterEvent("ZONE_CHANGED_NEW_AREA", FontFlex.OnZoneChange)
-- 	FontFlex:RegisterEvent("ZONE_CHANGED", FontFlex.OnSubZoneChange)
-- 	FontFlex:RegisterEvent("ZONE_CHANGED_INDOORS", FontFlex.OnIndoorZoneChange)
-- 	local fontWidgetInstance = AGSMW.
-- 	fontWidgetInstance:SetList(LSM:HashTable("font"))
-- 	C_Timer.After(10, function() FontFlex:Update() end)
end

E:RegisterModule(FontFlex:GetName()) --Register the module with ElvUI. ElvUI will now call FontFlex:Initialize() when ElvUI is ready to load our plugin.
