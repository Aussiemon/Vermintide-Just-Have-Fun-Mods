--[[
	author: Aussiemon
 
	-----
 
	Copyright 2018 Aussiemon

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
	-----
 
	Reports number of completed attempts for each level.
--]]

local command_name = "MissionStats"

-- ##########################################################
-- #################### Tables ##############################

StatPopups = StatPopups or {}

-- Level Key to Level Name Lookup Table
StatPopups.LevelKeyLookups = {
	magnus = "Horn of Magnus",
	merchant = "Supply and Demand",
	sewers_short = "Smuggler's Run",
	wizard = "Wizard's Tower",
	bridge = "Black Powder",
	forest_ambush = "Engines of War",
	city_wall = "Man the Ramparts",
	cemetery = "Garden of Morr",
	farm = "Wheat and Chaff",
	tunnels = "Enemy Below",
	courtyard_level = "Well Watch",
	docks_short_level = "Waterfront",
	end_boss = "White Rat",
	dlc_castle = "Castle Drachenfels",
	dlc_castle_dungeon = "The Dungeons",
	dlc_portals = "Summoner's Peak",
	dlc_dwarf_interior = "Khazid Kro",
	dlc_dwarf_exterior = "Cursed Rune",
	dlc_dwarf_beacons = "Chain of Fire",
	dlc_stromdorf_hills = "The Courier",
	dlc_stromdorf_town = "Reaching Out",
	dlc_reikwald_forest = "Reikwald Forest",
	dlc_reikwald_river = "The River Reik",
	chamber = "Waylaid",
	dlc_challenge_wizard = "Trial of the Foolhardy",
	dlc_survival_magnus = "Town Meeting",
	dlc_survival_ruins = "The Fall"
}

-- Array of ordered keys for proper printing order
StatPopups.LevelKeyArray = {
	"magnus",
	"merchant",
	"sewers_short",
	"wizard",
	"bridge",
	"forest_ambush",
	"city_wall",
	"cemetery",
	"farm",
	"tunnels",
	"courtyard_level",
	"docks_short_level",
	"end_boss",
	"dlc_castle",
	"dlc_castle_dungeon",
	"dlc_portals",
	"dlc_dwarf_interior",
	"dlc_dwarf_exterior",
	"dlc_dwarf_beacons",
	"dlc_stromdorf_hills",
	"dlc_stromdorf_town",
	"dlc_reikwald_forest",
	"dlc_reikwald_river",
	"chamber",
	"dlc_challenge_wizard",
	"dlc_survival_magnus",
	"dlc_survival_ruins"
}

-- Lookup table for the prefixes under which Last Stand stats are stored
StatPopups.SurvivalLevelPrefixes = {
	dlc_survival_ruins = "ruins",
	dlc_survival_magnus = "magnus",
	length = 2
}

-- 1200p and lower sizing definitions
StatPopups.scenegraph_definition = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.popup + 1
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.popup
		},
		size = {
			1920,
			1080
		}
	},
	popup_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		},
		size = {
			844,
			740
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-125,
			1
		},
		size = {
			700,
			60
		}
	},
	popup_text = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-240,
			1
		},
		size = {
			1920,
			260
		}
	},
	buttons_root = {
		vertical_alignment = "bottom",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			83,
			1
		},
		size = {
			1,
			1
		}
	},
	button_1_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_2_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-150,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_2_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			150,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-200,
			18,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			-15,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_3 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			200,
			18,
			1
		},
		size = {
			220,
			62
		}
	},
	timer = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "right"
	},
	center_timer = {
		vertical_alignment = "bottom",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		}
	}
}

-- 1200p and lower widget definitions
StatPopups.frame_widget_definition = {
	scenegraph_id = "popup_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "background_tint",
				texture_id = "background_tint"
			},
			{
				pass_type = "texture",
				texture_id = "background"
			},
			{
				style_id = "text",
				pass_type = "text",
				text_id = "text_field"
			},
			{
				style_id = "topic",
				pass_type = "text",
				text_id = "topic_field"
			},
			{
				style_id = "timer",
				pass_type = "text",
				text_id = "timer_field"
			},
			{
				style_id = "center_timer",
				pass_type = "text",
				text_id = "center_timer_field"
			}
		}
	},
	content = {
		topic_field = "",
		text_start_offset = 0,
		background = "prestige_bg",
		center_timer_field = "",
		timer_field = "",
		background_tint = "gradient_dice_game_reward",
		text_field = ""
	},
	style = {
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		text = {
			word_wrap = true,
			scenegraph_id = "popup_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				2
			}
		},
		topic = {
			font_size = 54,
			scenegraph_id = "title_text",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				8,
				2
			}
		},
		timer = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				320,
				203,
				8
			}
		},
		center_timer = {
			vertical_alignment = "center",
			dynamic_font = true,
			font_size = 44,
			horizontal_alignment = "center",
			pixel_perfect = true,
			font_type = "hell_shark",
			scenegraph_id = "center_timer",
			text_color = Colors.get_color_table_with_alpha("white", 255)
		}
	}
}

-- 1440p and higher sizing definitons
StatPopups.scenegraph_definition_hd = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.popup + 1
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.popup
		},
		size = {
			1920,
			1080
		}
	},
	popup_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		},
		size = {
			1110,
			1000
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-170,
			1
		},
		size = {
			700,
			60
		}
	},
	popup_text = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-368,
			1
		},
		size = {
			1920,
			260
		}
	},
	buttons_root = {
		vertical_alignment = "bottom",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			130,
			1
		},
		size = {
			1,
			1
		}
	},
	button_1_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_2_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-150,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_2_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			150,
			0,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-200,
			18,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			-15,
			1
		},
		size = {
			220,
			62
		}
	},
	button_3_3 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			200,
			18,
			1
		},
		size = {
			220,
			62
		}
	},
	timer = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "right"
	},
	center_timer = {
		vertical_alignment = "bottom",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		}
	}
}

-- 1440p and higher widget definitons
StatPopups.frame_widget_definition_hd = {
	scenegraph_id = "popup_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "background_tint",
				texture_id = "background_tint"
			},
			{
				pass_type = "texture",
				texture_id = "background"
			},
			{
				style_id = "text",
				pass_type = "text",
				text_id = "text_field"
			},
			{
				style_id = "topic",
				pass_type = "text",
				text_id = "topic_field"
			},
			{
				style_id = "timer",
				pass_type = "text",
				text_id = "timer_field"
			},
			{
				style_id = "center_timer",
				pass_type = "text",
				text_id = "center_timer_field"
			}
		}
	},
	content = {
		topic_field = "",
		text_start_offset = 0,
		background = "prestige_bg",
		center_timer_field = "",
		timer_field = "",
		background_tint = "gradient_dice_game_reward",
		text_field = ""
	},
	style = {
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		text = {
			word_wrap = true,
			scenegraph_id = "popup_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				2
			}
		},
		topic = {
			font_size = 72,
			scenegraph_id = "title_text",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				8,
				2
			}
		},
		timer = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				320,
				203,
				8
			}
		},
		center_timer = {
			vertical_alignment = "center",
			dynamic_font = true,
			font_size = 44,
			horizontal_alignment = "center",
			pixel_perfect = true,
			font_type = "hell_shark",
			scenegraph_id = "center_timer",
			text_color = Colors.get_color_table_with_alpha("white", 255)
		}
	}
}

StatPopups._old_ui_scenegraph = StatPopups._old_ui_scenegraph or nil
StatPopups._old_ui_frame_widget = StatPopups._old_ui_frame_widget or nil

-- ##########################################################
-- ################### Functions ############################

-- Check for a resolution greater than 1200p
StatPopups.must_resize = function()

	local screen_w, screen_h = UIResolution()
	
	if screen_h > 1200 and not (HiDefUIScaling and HiDefUIScaling.is_enabled) then
		return true
	else
		return false
	end
end

-- Display the statistic's popup
StatPopups.create_popup = function(title, output_string)
	
	-- Prevent popup from stacking on an existing popup
	local popup_manager = Managers.popup
	if popup_manager.has_popup(popup_manager) or ShowCursorStack.stack_depth > 0 then
		return
	end
	
	-- Start closing chat window and transfer input
	local chat_manager = Managers.chat
	local chat_gui = chat_manager.chat_gui
	chat_gui:unblock_input(false)
	chat_gui.chat_closed = true
	chat_gui.chat_focused = false
	chat_gui.chat_close_time = 0
	chat_gui:clear_current_transition()
	chat_gui:set_menu_transition_fraction(0)
	chat_gui:_set_chat_window_alpha(1)
	chat_gui.tab_widget.style.button_notification.color[1] = UISettings.chat.tab_notification_alpha_1
	
	-- Change scenegraph definition and frame widget in popup handler
	local popup_handler = popup_manager._handler
	StatPopups._old_ui_scenegraph = StatPopups._old_ui_scenegraph or popup_handler.ui_scenegraph
	StatPopups._old_ui_frame_widget = StatPopups._old_ui_frame_widget or popup_handler.frame_widget
	
	-- Choose definition based upon current resolution
	local must_resize = StatPopups.must_resize()
	if not must_resize then
		StatPopups._ui_scenegraph = UISceneGraph.init_scenegraph(StatPopups.scenegraph_definition)
		StatPopups._ui_frame_widget = UIWidget.init(StatPopups.frame_widget_definition)
	else
		StatPopups._ui_scenegraph = UISceneGraph.init_scenegraph(StatPopups.scenegraph_definition_hd)
		StatPopups._ui_frame_widget = UIWidget.init(StatPopups.frame_widget_definition_hd)
	end
	
	popup_handler.ui_scenegraph = StatPopups._ui_scenegraph
	popup_handler.frame_widget = StatPopups._ui_frame_widget
	
	-- Initialize simple popup manager if necessary
	if not Managers.simple_popup then
		Managers.simple_popup = SimplePopup:new()
	end

	-- Display popup
	local simple_popup = Managers.simple_popup
	simple_popup.queue_popup(simple_popup, output_string, title, "accept", "Close")
	
	-- Resize text
	local n_popups = popup_handler.n_popups
	local popup = popup_handler.popups[n_popups]
	if not must_resize then
		popup.text_font_size = 21
	else
		popup.text_font_size = 28
	end
end

-- ##########################################################
-- #################### Hooks ###############################

Mods.hook.set("StatPopups", "SimplePopup.update", function(func, self, dt)

	func(self, dt)

	local popup_manager = Managers.popup
	local popup_handler = popup_manager._handler
	if #self._tracked_popups == 0 then
		if StatPopups._old_ui_scenegraph then
			popup_handler.ui_scenegraph = StatPopups._old_ui_scenegraph
			StatPopups._old_ui_scenegraph = nil
		end
		if StatPopups._old_ui_frame_widget then
			popup_handler.frame_widget = StatPopups._old_ui_frame_widget
			StatPopups._old_ui_frame_widget = nil
		end
	end
end)

-- ##########################################################
-- #################### Script ##############################

safe_pcall(function()

	local output_string = ""
	if not Managers.player then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local local_player = Managers.player:local_player()
	if not local_player then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local stat_db = Managers.player:statistics_db()
	if not stat_db then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local stats_id = local_player.stats_id(local_player)
	if not stats_id then
		EchoConsole("Please wait: stats not yet loaded!")
		return
	end

	local total_completed = 0
	local user_name = ""
	
	-- ############## Begin String Format ########################

	output_string = output_string .. "\n"
	
	local line_count = 0
	local total_count = 0
	local stored_survival_lines = ""

	-- Get listing for each level
	for _, level_name in pairs(StatPopups.LevelKeyArray) do
	
		line_count = line_count + 1
		total_count = total_count + 1

		local translated_name = StatPopups.LevelKeyLookups[level_name] or level_name
		
		-- If this is a Last Stand map, retrieve the prefix used in the stats database
		local survival_level_name = nil
		if StatPopups.SurvivalLevelPrefixes[level_name] then
			survival_level_name = StatPopups.SurvivalLevelPrefixes[level_name]
		end
		
		-- Format statistics into a line to append to the total output
		if survival_level_name then
		
			-- Last Stand mission
			local this_total_kills = nil
			local this_veteran_waves = nil
			local this_champion_waves = nil
			local this_heroic_waves = nil
			
			this_total_kills = 
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hard_kills")) 
				+ stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_harder_kills")) 
				+ stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hardest_kills"))
			this_veteran_waves = 
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hard_waves")) 
			this_champion_waves =
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_harder_waves")) 
			this_heroic_waves =
				stat_db.get_persistent_stat(stat_db, stats_id, ("survival_dlc_survival_" .. survival_level_name .. "_survival_hardest_waves"))
				
			line_count = line_count - 1
		
			-- Line is stored for printing after regular mission stats
			stored_survival_lines = stored_survival_lines .. "\n" .. translated_name .. ": " .. (this_total_kills) .. " kills, (" .. this_veteran_waves .. ", " .. this_champion_waves .. ", " .. this_heroic_waves .. ") best waves"
		else
		
			-- Regular mission
			local this_completion = stat_db.get_persistent_stat(stat_db, stats_id, "completed_levels", level_name) or 0
			total_completed = total_completed + this_completion
			
			if line_count > 3 then
				line_count = 1
				output_string = output_string .. "\n"
			end
			
			-- Line is appended immediately
			output_string = output_string .. translated_name .. ": " .. (this_completion)
			
			if line_count < 3 and total_count ~= (#StatPopups.LevelKeyArray - StatPopups.SurvivalLevelPrefixes.length) then
				output_string = output_string .. ",  "
			end
		end
	end

	local total_badges = stat_db.get_persistent_stat(stat_db, stats_id, "endurance_badges")
	
	-- Re-add Last Stand lines
	output_string = output_string .. stored_survival_lines
	
	-- Finalize
	output_string = output_string .. "\n" .. "Total Completions: " .. total_completed
	output_string = output_string .. "\n" .. "Total Endurance Badges: " .. total_badges
	
	-- ############## End String Format ########################
	
	StatPopups.create_popup("Mission Stats", output_string)
	
end)

-- ##########################################################
-- ##########################################################
