--[[
	author: Aussiemon
	
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
	
	Adjustment of size for specific BW first-person weapon models.
--]]

local mod = get_mod("SmallerBWStaffs")

-- ##########################################################
-- ################## Variables #############################

mod.scaled_unit = nil
mod.scale_factor = nil
mod.counter = 1
mod.LookupTable = {}
mod.LookupScaleTable = {}

-- Lookup table for active settings
mod.LookupTable["units/weapons/player/wpn_brw_staff_06/wpn_brw_staff_06"] = "red_staff_active" -- Red
mod.LookupTable["units/weapons/player/wpn_brw_staff_05/wpn_brw_staff_05"] = "bolt_staff_active" -- Bolt
mod.LookupTable["units/weapons/player/wpn_brw_staff_04/wpn_brw_staff_04"] = "beam_staff_active" -- Beam
mod.LookupTable["units/weapons/player/wpn_brw_staff_03/wpn_brw_staff_03"] = "conflag_staff_active" -- Conflag
mod.LookupTable["units/weapons/player/wpn_brw_staff_02/wpn_brw_staff_02"] = "fireball_staff_active" -- Fireball

-- Lookup table for scale settings
mod.LookupScaleTable["units/weapons/player/wpn_brw_staff_06/wpn_brw_staff_06"] = "red_staff_scale" -- Red
mod.LookupScaleTable["units/weapons/player/wpn_brw_staff_05/wpn_brw_staff_05"] = "bolt_staff_scale" -- Bolt
mod.LookupScaleTable["units/weapons/player/wpn_brw_staff_04/wpn_brw_staff_04"] = "beam_staff_scale" -- Beam
mod.LookupScaleTable["units/weapons/player/wpn_brw_staff_03/wpn_brw_staff_03"] = "conflag_staff_scale" -- Conflag
mod.LookupScaleTable["units/weapons/player/wpn_brw_staff_02/wpn_brw_staff_02"] = "fireball_staff_scale" -- Fireball

local Unit = Unit
local Vector3 = Vector3

local UnitSpawner = UnitSpawner

-- ##########################################################
-- ################## Functions #############################

-- Updates bright wizard staff size with scaling factor
mod.bw_staff_apply_scale = function(scaling_factor, remove_unit, calling_function)
	if mod.scaled_unit and Unit.alive(mod.scaled_unit) then
	
		mod:pcall(function()
		
			local root_node = Unit.has_node(mod.scaled_unit, "root_point") and Unit.node(mod.scaled_unit, "root_point") or 0
			local current_scale = Unit.local_scale(mod.scaled_unit, root_node)
			
			Unit.set_local_scale(mod.scaled_unit, root_node, 
				Vector3(current_scale.x * (scaling_factor or 1),
					current_scale.y * (scaling_factor or 1),
					current_scale.z * (scaling_factor or 1)))
			if remove_unit then
				mod.scaled_unit = nil
				mod.scale_factor = nil
			end
		end)
		
		if calling_function then
			-- mod:echo(calling_function)
		end
	end
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(UnitSpawner, "spawn_local_unit", function (func, self, unit_name, position, rotation, material, ...)
	local unit = func(self, unit_name, position, rotation, material, ...)
	
	-- Save oversized staff unit
	if mod.LookupTable[unit_name] and mod:get(mod.LookupTable[unit_name]) then
		mod.scaled_unit = unit
		mod.scaled_unit_name = unit_name
		mod.counter = 1
	end
	
	return unit
end)

mod:hook(UnitSpawner, "spawn_local_unit_with_extensions", function (func, self, unit_name, ...)
	local unit, unit_template_name = func(self, unit_name, ...)
	
	-- Handle delayed scaling
	if mod.scale_factor then
		if mod.counter > 2 then
			mod.bw_staff_apply_scale(mod.scale_factor, true, nil)
		else
			mod.counter = mod.counter + 1
		end
	end
	
	if mod:get(mod.LookupTable[unit_name]) then
		-- Apply scaling factor
		local scale_setting = mod.LookupScaleTable[mod.scaled_unit_name] or ""
		mod.scale_factor = (mod:get(scale_setting) or 100) / 100
		
		mod.counter = mod.counter + 1
	end
	
	return unit, unit_template_name
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(initial_call)
	mod.scaled_unit = nil
	mod.scale_factor = nil
	mod.counter = 1
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(initial_call)
	mod.counter = 1
	mod.scale_factor = nil
	mod.scaled_unit = nil
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
