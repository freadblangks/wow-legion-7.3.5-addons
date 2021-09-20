  ----------------------------------------------------------------------------------------------------------------------
    -- This program is free software: you can redistribute it and/or modify
    -- it under the terms of the GNU General Public License as published by
    -- the Free Software Foundation, either version 3 of the License, or
    -- (at your option) any later version.
	
    -- This program is distributed in the hope that it will be useful,
    -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    -- GNU General Public License for more details.

    -- You should have received a copy of the GNU General Public License
    -- along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------

--- Designed to handle interaction with the player, react to their input, and adjust program behaviour accordingly
-- @module Controllers

--- GUI.lua.
-- Controls the displays and manages player interaction with its individual parts
-- @section GUI


local addonName, TotalAP = ...
if not TotalAP then return end

local activeView, usableViews

--- Align progress bars and spec icons in relation to the AnchorFrame (DefaultView only) - temporary crutch that will be removed later
-- TODO: Set this via ConfigUI instead (also, Views need differentiation in its handling)
local function AlignGUI(alignment)

	local validAlignments = { "center", "bottom", "top" }
	local settings = TotalAP.Settings.GetReference()
	
	for k, v in pairs(validAlignments) do
	
	if alignment == v then -- Update SavedVars and align UI as requested
				settings["infoFrame"]["alignment"] = v
				settings["specIcons"]["alignment"] = v
				return true
		end
		
	end
	
	
	TotalAP.Debug("Attempted to align GUI, but the requested alignment does not exist. Valid options are: center (default), bottom, top")
	return false

end

--- Create all required frames for a given view. This does NOT render (show) them, but they will be stored in the respective ViewObject and can be used at will afterwards
-- @param[opt] name The name of the view template that should be used; "DefaultView" if none was given
local function CreateView(name)

	if not name then
		name = "DefaultView"
		TotalAP.Debug("Attempted to create view with an invalid name; using " .. name .. " instead")
	end

	-- Instantiate view object and store it in list of created (available) views
	local View = TotalAP.GUI[name]
	local ViewObject = View:CreateNew()
	
	usableViews[name] = ViewObject
	
end

--- Retrieves the name of the currently active view
-- @return The name of the currently active view; nil if none was set (this should not happen under normal circumstances)
local function GetActiveView()

	return activeView

end

--- Sets the currently active view
-- @param name The name of a view
local function SetActiveView(name)

	-- TODO: If view doesn't exist, Debug message
	if not name then
		name = "DefaultView"
		TotalAP.Debug("Attempted to set view with an invalid name; using " .. tostring(name) .. " instead")
	end

	-- Set view to active
	activeView = name
	if not activeView then
		TotalAP.Debug("Attempted to set view as activeView: " .. tostring(name) .. " -> invalid view or view is not usable yet")
	end
	
	-- TODO. Custom view (save elements in SV instead of name?)
	
end

--- Prepares the internal structures to allow Views to be rendered and updated
local function InitialiseGUI()
	
	usableViews = {}
	
	-- Create views (will be rendered later, but if the Frames aren't created earlier they won't be saved in the client's LayoutCache) - TODO: Forfeit relying on the Layout Cache in favour of manual positioning to avoid accidental resets?
	CreateView("DefaultView")
	
	-- Use default view (TODO: Use view that was selected and saved via "activeView" setting)
	SetActiveView("DefaultView")
	
end

--- Updates the displays of currently active View using all available information that the addon has gathered
local function RenderGUI()

	if ( TotalAP.Cache.GetNumIgnoredSpecs() == GetNumSpecializations() ) and not TotalAP.specIgnoredWarningGiven and GetNumSpecializations() > 0 then -- Print warning and instructions on how to reset ignored specs... just in case -- TODO: use verbose setting for optional warnings/notices like this?
	
		TotalAP.ChatMsg(format(TotalAP.L["All specs are set to being ignored for this character. Type %s to reset them if this is unintended."], "/" .. TotalAP.Controllers.GetSlashCommandAlias() .. " unignore"))
		TotalAP.specIgnoredWarningGiven = true -- TODO: Lame, but whatever
	
	end

	local ActiveViewObject = usableViews[activeView]
	
	if not ActiveViewObject then -- No views, no party...
		TotalAP.Debug("Failed to render GUI -> No usable Views have been created")
		return
	end

	ActiveViewObject:Render()
	
end

--- Returns the number of Views that have been initialised and are available (i.e., can be activated and rendered)
-- @return The number of usable views if any were created; zero otherwise
local function GetNumUsableViews()

	local numUsableViews = 0
	
	for k, v in pairs(usableViews) do -- Count views
		numUsableViews = numUsableViews + 1
	end
	
	return numUsableViews

end

--- Returns all Views that have been initialised and are available (i.e., can be activated and rendered)
-- @return A reference to the usableViews table
local function GetUsableViews()
	return usableViews
end


TotalAP.Controllers.AlignGUI = AlignGUI
TotalAP.Controllers.CreateView = CreateView
TotalAP.Controllers.GetActiveView  = GetActiveView
TotalAP.Controllers.SetActiveView  = SetActiveView
TotalAP.Controllers.InitialiseGUI  = InitialiseGUI
TotalAP.Controllers.RenderGUI  = RenderGUI
TotalAP.Controllers.GetNumUsableViews  = GetNumUsableViews
TotalAP.Controllers.GetUsableViews  = GetUsableViews


return TotalAP.Controllers
