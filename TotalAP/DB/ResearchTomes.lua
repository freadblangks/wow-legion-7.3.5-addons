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


local addonName, TotalAP = ...
if not TotalAP then return end

 -- Made obsolete in 7.3 -> Remove once everything has been cleaned up (?) Keeping it for now, as it is possible that there'll be different artifact-related items that are worth tracking
local researchTomes = {

--	[139390] = true,  -- Artifact Research Notes (max. AK 25) TODO: obsolete? Seem to be replaced by the AK 50 version entirely
--	[146745] = true,  -- Artifact Research Notes (max. AK 50)
--	[147860] = true,  -- Empowered Elven Tome (7.2)
--	[144433] = true,  -- Artifact Research Compendium: Volume I
--	[144434] = true,  -- Artifact Research Compendium: Volumes I & II
--	[144431] = true,  -- Artifact Research Compendium: Volumes I-III
--	[144395] = true,  -- Artifact Research Synopsis
--	[147852] = true,  -- Artifact Research Compendium: Volumes I-V
--	[147856] = true,  -- Artifact Research Compendium: Volumes I-IX
--	[147855] = true,  -- Artifact Research Compendium: Volumes I-VIII
--	[144435] = true,  -- Artifact Research Compendium: Volumes I-IV
--	[147853] = true,  -- Artifact Research Compendium: Volumes I-VI
--	[147854] = true,  -- Artifact Research Compendium: Volumes I-VII
	[141335] = true,  -- Lost Research Notes (TODO: Is this even ingame? -> Part of the obsolete Mage quest "Hidden History", perhaps?)

}

TotalAP.DB.ResearchTomes = researchTomes


return TotalAP.DB.ResearchTomes
